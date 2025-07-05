const { MongoClient } = require('mongodb');

class MongoDBService {
  constructor() {
    this.client = null;
    this.db = null;
    this.isConnected = false;
  }

  async connect() {
    try {
      const mongoUri = process.env.DATABASE_URL || 'mongodb://localhost:27017/instacap';
      const dbName = process.env.MONGODB_DB_NAME || 'instacap_db';

      // Enhanced connection options for MongoDB Atlas
      const connectionOptions = {
        serverSelectionTimeoutMS: 30000, // Increased timeout
        connectTimeoutMS: 30000,
        socketTimeoutMS: 45000,
        maxPoolSize: 10,
        minPoolSize: 2,
        maxIdleTimeMS: 30000,
        waitQueueTimeoutMS: 10000,
        retryWrites: true,
        w: 'majority'
      };

      // Add SSL configuration for Atlas connections
      if (mongoUri.includes('mongodb+srv://') || mongoUri.includes('.mongodb.net')) {
        connectionOptions.tls = true;
        connectionOptions.tlsAllowInvalidCertificates = false;
        connectionOptions.tlsAllowInvalidHostnames = false;
      }

      console.log('🔗 Connecting to MongoDB Atlas...');
      this.client = new MongoClient(mongoUri, connectionOptions);

      await this.client.connect();
      
      // Verify connection with a ping
      await this.client.db('admin').command({ ping: 1 });
      
      this.db = this.client.db(dbName);
      this.isConnected = true;

      console.log('✅ MongoDB connected successfully to:', mongoUri.replace(/\/\/.*@/, '//***:***@'));
      console.log('📊 Database name:', dbName);
      
      // Create collections and indexes
      await this.createCollections();
      
      return true;
    } catch (error) {
      console.error('❌ MongoDB connection failed:', error.message);
      
      // Provide specific error guidance
      if (error.message.includes('SSL') || error.message.includes('TLS')) {
        console.error('🔒 SSL/TLS Error - Try these solutions:');
        console.error('   1. Check if your IP is whitelisted in MongoDB Atlas');
        console.error('   2. Verify your connection string format');
        console.error('   3. Ensure your cluster is properly configured');
      } else if (error.message.includes('authentication failed')) {
        console.error('🔐 Authentication Error - Check:');
        console.error('   1. Username and password in connection string');
        console.error('   2. Database user exists in MongoDB Atlas');
        console.error('   3. User has proper read/write permissions');
      } else if (error.message.includes('timeout')) {
        console.error('⏱️ Connection Timeout - Try:');
        console.error('   1. Check your internet connection');
        console.error('   2. Verify MongoDB Atlas cluster is running');
        console.error('   3. Check firewall settings');
      }
      
      this.isConnected = false;
      return false;
    }
  }

  async createCollections() {
    try {
      // Create collections with validation schemas
      const collections = ['users', 'captions', 'analytics', 'trending'];
      
      for (const collectionName of collections) {
        const collectionExists = await this.db.listCollections({ name: collectionName }).hasNext();
        if (!collectionExists) {
          await this.db.createCollection(collectionName);
          console.log(`📁 Created collection: ${collectionName}`);
        }
      }

      // Create indexes for better performance
      await this.createIndexes();
    } catch (error) {
      console.error('❌ Error creating collections:', error.message);
    }
  }

  async createIndexes() {
    try {
      // Users collection indexes
      await this.db.collection('users').createIndex({ email: 1 }, { unique: true });
      await this.db.collection('users').createIndex({ uid: 1 }, { unique: true });
      await this.db.collection('users').createIndex({ createdAt: 1 });

      // Captions collection indexes
      await this.db.collection('captions').createIndex({ userId: 1 });
      await this.db.collection('captions').createIndex({ createdAt: -1 });
      await this.db.collection('captions').createIndex({ tags: 1 });
      await this.db.collection('captions').createIndex({ likes: -1 });

      // Analytics collection indexes
      await this.db.collection('analytics').createIndex({ userId: 1 });
      await this.db.collection('analytics').createIndex({ event: 1 });
      await this.db.collection('analytics').createIndex({ timestamp: -1 });

      // Trending collection indexes
      await this.db.collection('trending').createIndex({ score: -1 });
      await this.db.collection('trending').createIndex({ updatedAt: -1 });

      console.log('📊 Database indexes created successfully');
    } catch (error) {
      console.error('❌ Error creating indexes:', error.message);
    }
  }

  async disconnect() {
    try {
      if (this.client) {
        await this.client.close();
        this.isConnected = false;
        console.log('✅ MongoDB disconnected successfully');
      }
    } catch (error) {
      console.error('❌ Error disconnecting from MongoDB:', error.message);
    }
  }

  getDb() {
    if (!this.isConnected || !this.db) {
      throw new Error('MongoDB is not connected');
    }
    return this.db;
  }

  getCollection(name) {
    return this.getDb().collection(name);
  }

  // User operations
  async createUser(userData) {
    try {
      const user = {
        ...userData,
        createdAt: new Date(),
        updatedAt: new Date(),
        lastLoginAt: new Date(),
        captionsGenerated: 0,
        totalLikes: 0,
        isActive: true
      };

      const result = await this.getCollection('users').insertOne(user);
      return { success: true, userId: result.insertedId, user };
    } catch (error) {
      console.error('❌ Error creating user:', error.message);
      return { success: false, error: error.message };
    }
  }

  async findUserByEmail(email) {
    try {
      const user = await this.getCollection('users').findOne({ email });
      return user;
    } catch (error) {
      console.error('❌ Error finding user by email:', error.message);
      return null;
    }
  }

  async findUserByUid(uid) {
    try {
      const user = await this.getCollection('users').findOne({ uid });
      return user;
    } catch (error) {
      console.error('❌ Error finding user by UID:', error.message);
      return null;
    }
  }

  async updateUser(uid, updateData) {
    try {
      const result = await this.getCollection('users').updateOne(
        { uid },
        { 
          $set: { 
            ...updateData, 
            updatedAt: new Date() 
          } 
        }
      );
      return { success: true, modifiedCount: result.modifiedCount };
    } catch (error) {
      console.error('❌ Error updating user:', error.message);
      return { success: false, error: error.message };
    }
  }

  // Caption operations
  async saveCaption(captionData) {
    try {
      const caption = {
        ...captionData,
        createdAt: new Date(),
        updatedAt: new Date(),
        likes: 0,
        isPublic: true,
        tags: captionData.tags || []
      };

      const result = await this.getCollection('captions').insertOne(caption);
      
      // Update user's caption count
      await this.getCollection('users').updateOne(
        { uid: captionData.userId },
        { $inc: { captionsGenerated: 1 } }
      );

      return { success: true, captionId: result.insertedId, caption };
    } catch (error) {
      console.error('❌ Error saving caption:', error.message);
      return { success: false, error: error.message };
    }
  }

  async getUserCaptions(userId, limit = 20, skip = 0) {
    try {
      const captions = await this.getCollection('captions')
        .find({ userId })
        .sort({ createdAt: -1 })
        .limit(limit)
        .skip(skip)
        .toArray();

      return captions;
    } catch (error) {
      console.error('❌ Error getting user captions:', error.message);
      return [];
    }
  }

  async getTrendingCaptions(limit = 20) {
    try {
      const trending = await this.getCollection('captions')
        .find({ isPublic: true })
        .sort({ likes: -1, createdAt: -1 })
        .limit(limit)
        .toArray();

      return trending;
    } catch (error) {
      console.error('❌ Error getting trending captions:', error.message);
      return [];
    }
  }

  // Analytics operations
  async logAnalytics(analyticsData) {
    try {
      const analytics = {
        ...analyticsData,
        timestamp: new Date()
      };

      await this.getCollection('analytics').insertOne(analytics);
      return { success: true };
    } catch (error) {
      console.error('❌ Error logging analytics:', error.message);
      return { success: false, error: error.message };
    }
  }

  async getAnalytics(userId, timeRange = '7d') {
    try {
      const endDate = new Date();
      const startDate = new Date();
      
      switch (timeRange) {
        case '1d':
          startDate.setDate(endDate.getDate() - 1);
          break;
        case '7d':
          startDate.setDate(endDate.getDate() - 7);
          break;
        case '30d':
          startDate.setDate(endDate.getDate() - 30);
          break;
        default:
          startDate.setDate(endDate.getDate() - 7);
      }

      const analytics = await this.getCollection('analytics')
        .find({
          userId,
          timestamp: {
            $gte: startDate,
            $lte: endDate
          }
        })
        .sort({ timestamp: -1 })
        .toArray();

      return analytics;
    } catch (error) {
      console.error('❌ Error getting analytics:', error.message);
      return [];
    }
  }

  // Health check
  async healthCheck() {
    try {
      await this.db.admin().ping();
      return { status: 'healthy', connected: this.isConnected };
    } catch (error) {
      return { status: 'unhealthy', connected: false, error: error.message };
    }
  }
}

// Export singleton instance
const mongoService = new MongoDBService();
module.exports = mongoService;
