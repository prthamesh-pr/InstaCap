const mongoService = require('../config/mongodb');
const DataModels = require('../models/DataModels');

class UserService {
  constructor() {
    this.mongoService = mongoService;
  }

  async getDB() {
    if (!this.mongoService.isConnected) {
      await this.mongoService.connect();
    }
    return this.mongoService.db;
  }

  // Create or update user profile
  async createOrUpdateUser(userData) {
    try {
      const db = await this.getDB();
      const usersCollection = db.collection('users');
      
      // Check if user exists
      const existingUser = await usersCollection.findOne({ uid: userData.uid });
      
      if (existingUser) {
        // Update existing user
        const updateData = {
          displayName: userData.displayName || existingUser.displayName,
          photoURL: userData.photoURL !== undefined ? userData.photoURL : existingUser.photoURL,
          bio: userData.bio || existingUser.bio,
          preferences: { ...existingUser.preferences, ...userData.preferences },
          updatedAt: new Date(),
          lastActiveAt: new Date(),
        };
        
        await usersCollection.updateOne(
          { uid: userData.uid },
          { $set: updateData }
        );
        
        return await usersCollection.findOne({ uid: userData.uid });
      } else {
        // Create new user
        const newUser = DataModels.createUserProfile(userData);
        await usersCollection.insertOne(newUser);
        
        // Create user statistics
        const statsService = new UserStatsService();
        await statsService.createUserStats(userData.uid);
        
        return newUser;
      }
    } catch (error) {
      console.error('Error creating/updating user:', error);
      throw error;
    }
  }

  // Get user by UID
  async getUserByUid(uid) {
    try {
      const db = await this.getDB();
      const usersCollection = db.collection('users');
      return await usersCollection.findOne({ uid });
    } catch (error) {
      console.error('Error getting user:', error);
      throw error;
    }
  }

  // Update user profile
  async updateUserProfile(uid, updateData) {
    try {
      const validation = DataModels.validateUserProfile({ uid, ...updateData });
      if (!validation.isValid) {
        throw new Error(`Validation failed: ${validation.errors.join(', ')}`);
      }

      const db = await this.getDB();
      const usersCollection = db.collection('users');
      
      const update = {
        ...updateData,
        updatedAt: new Date(),
        lastActiveAt: new Date(),
      };
      
      await usersCollection.updateOne(
        { uid },
        { $set: update }
      );
      
      return await usersCollection.findOne({ uid });
    } catch (error) {
      console.error('Error updating user profile:', error);
      throw error;
    }
  }

  // Delete user
  async deleteUser(uid) {
    try {
      const db = await this.getDB();
      const usersCollection = db.collection('users');
      
      // Also delete related data
      const captionService = new CaptionService();
      await captionService.deleteUserCaptions(uid);
      
      const statsService = new UserStatsService();
      await statsService.deleteUserStats(uid);
      
      return await usersCollection.deleteOne({ uid });
    } catch (error) {
      console.error('Error deleting user:', error);
      throw error;
    }
  }

  // Get user activity summary
  async getUserActivity(uid, days = 30) {
    try {
      const db = await this.getDB();
      const captionsCollection = db.collection('captions');
      
      const startDate = new Date();
      startDate.setDate(startDate.getDate() - days);
      
      const activity = await captionsCollection.aggregate([
        {
          $match: {
            userId: uid,
            createdAt: { $gte: startDate }
          }
        },
        {
          $group: {
            _id: {
              $dateToString: { format: "%Y-%m-%d", date: "$createdAt" }
            },
            count: { $sum: 1 },
            tones: { $push: "$metadata.tone" },
            styles: { $push: "$metadata.style" }
          }
        },
        { $sort: { _id: 1 } }
      ]).toArray();
      
      return activity;
    } catch (error) {
      console.error('Error getting user activity:', error);
      throw error;
    }
  }
}

class CaptionService {
  constructor() {
    this.mongoService = mongoService;
  }

  async getDB() {
    if (!this.mongoService.isConnected) {
      await this.mongoService.connect();
    }
    return this.mongoService.db;
  }

  // Create caption
  async createCaption(captionData) {
    try {
      const validation = DataModels.validateCaption(captionData);
      if (!validation.isValid) {
        throw new Error(`Validation failed: ${validation.errors.join(', ')}`);
      }

      const db = await this.getDB();
      const captionsCollection = db.collection('captions');
      
      const newCaption = DataModels.createCaption(captionData);
      await captionsCollection.insertOne(newCaption);
      
      // Update user stats
      const statsService = new UserStatsService();
      await statsService.incrementCaptionCount(captionData.userId);
      
      return newCaption;
    } catch (error) {
      console.error('Error creating caption:', error);
      throw error;
    }
  }

  // Get user captions with pagination
  async getUserCaptions(userId, options = {}) {
    try {
      const {
        page = 1,
        limit = 20,
        search = '',
        category = 'all',
        sortBy = 'createdAt',
        sortOrder = -1
      } = options;

      const db = await this.getDB();
      const captionsCollection = db.collection('captions');
      
      // Build query
      const query = { userId };
      
      if (search) {
        query.content = { $regex: search, $options: 'i' };
      }
      
      if (category === 'favorites') {
        query['flags.isFavorite'] = true;
      }
      
      // Get total count
      const totalItems = await captionsCollection.countDocuments(query);
      
      // Get paginated results
      const captions = await captionsCollection
        .find(query)
        .sort({ [sortBy]: sortOrder })
        .skip((page - 1) * limit)
        .limit(limit)
        .toArray();
      
      return {
        captions,
        pagination: {
          currentPage: page,
          totalPages: Math.ceil(totalItems / limit),
          totalItems,
          hasNextPage: page < Math.ceil(totalItems / limit),
          hasPrevPage: page > 1,
          itemsPerPage: limit,
          itemsOnPage: captions.length
        }
      };
    } catch (error) {
      console.error('Error getting user captions:', error);
      throw error;
    }
  }

  // Toggle favorite
  async toggleFavorite(captionId, userId) {
    try {
      const db = await this.getDB();
      const captionsCollection = db.collection('captions');
      
      const caption = await captionsCollection.findOne({ 
        _id: new ObjectId(captionId), 
        userId 
      });
      
      if (!caption) {
        throw new Error('Caption not found');
      }
      
      const newFavoriteStatus = !caption.flags.isFavorite;
      
      await captionsCollection.updateOne(
        { _id: new ObjectId(captionId) },
        { 
          $set: { 
            'flags.isFavorite': newFavoriteStatus,
            updatedAt: new Date()
          }
        }
      );
      
      return { isFavorite: newFavoriteStatus };
    } catch (error) {
      console.error('Error toggling favorite:', error);
      throw error;
    }
  }

  // Delete caption
  async deleteCaption(captionId, userId) {
    try {
      const db = await this.getDB();
      const captionsCollection = db.collection('captions');
      
      return await captionsCollection.deleteOne({ 
        _id: new ObjectId(captionId), 
        userId 
      });
    } catch (error) {
      console.error('Error deleting caption:', error);
      throw error;
    }
  }

  // Delete all user captions
  async deleteUserCaptions(userId) {
    try {
      const db = await this.getDB();
      const captionsCollection = db.collection('captions');
      
      return await captionsCollection.deleteMany({ userId });
    } catch (error) {
      console.error('Error deleting user captions:', error);
      throw error;
    }
  }

  // Get trending captions
  async getTrendingCaptions(options = {}) {
    try {
      const { limit = 20, category = 'all' } = options;
      
      const db = await this.getDB();
      const captionsCollection = db.collection('captions');
      
      // Simple trending algorithm based on recent engagement
      const sevenDaysAgo = new Date();
      sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);
      
      const query = {
        createdAt: { $gte: sevenDaysAgo },
        'flags.isPublic': true
      };
      
      if (category !== 'all') {
        query['metadata.tone'] = category;
      }
      
      const trending = await captionsCollection
        .find(query)
        .sort({ 
          'engagement.likes': -1, 
          'engagement.shares': -1,
          'engagement.copies': -1 
        })
        .limit(limit)
        .toArray();
      
      return trending;
    } catch (error) {
      console.error('Error getting trending captions:', error);
      throw error;
    }
  }
}

class UserStatsService {
  constructor() {
    this.mongoService = mongoService;
  }

  async getDB() {
    if (!this.mongoService.isConnected) {
      await this.mongoService.connect();
    }
    return this.mongoService.db;
  }

  // Create user stats
  async createUserStats(userId) {
    try {
      const db = await this.getDB();
      const statsCollection = db.collection('user_stats');
      
      const existingStats = await statsCollection.findOne({ userId });
      if (!existingStats) {
        const newStats = DataModels.createUserStats(userId);
        await statsCollection.insertOne(newStats);
        return newStats;
      }
      
      return existingStats;
    } catch (error) {
      console.error('Error creating user stats:', error);
      throw error;
    }
  }

  // Get user stats
  async getUserStats(userId) {
    try {
      const db = await this.getDB();
      const statsCollection = db.collection('user_stats');
      
      let stats = await statsCollection.findOne({ userId });
      if (!stats) {
        stats = await this.createUserStats(userId);
      }
      
      return stats;
    } catch (error) {
      console.error('Error getting user stats:', error);
      throw error;
    }
  }

  // Increment caption count
  async incrementCaptionCount(userId) {
    try {
      const db = await this.getDB();
      const statsCollection = db.collection('user_stats');
      
      await statsCollection.updateOne(
        { userId },
        { 
          $inc: { 
            captionsGenerated: 1,
            'monthlyStats.captionsThisMonth': 1,
            'monthlyStats.apiCallsThisMonth': 1
          },
          $set: { updatedAt: new Date() }
        },
        { upsert: true }
      );
    } catch (error) {
      console.error('Error incrementing caption count:', error);
      throw error;
    }
  }

  // Delete user stats
  async deleteUserStats(userId) {
    try {
      const db = await this.getDB();
      const statsCollection = db.collection('user_stats');
      
      return await statsCollection.deleteOne({ userId });
    } catch (error) {
      console.error('Error deleting user stats:', error);
      throw error;
    }
  }
}

module.exports = {
  UserService,
  CaptionService,
  UserStatsService
};
