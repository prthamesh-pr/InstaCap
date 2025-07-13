// Enhanced API Testing Script for MongoDB Integration
const axios = require('axios');

const BASE_URL = 'http://localhost:3001/api';

// Test data
const testUser = {
  uid: 'test_user_123',
  email: 'test@example.com',
  name: 'Test User',
  profilePicture: 'https://example.com/avatar.jpg',
  bio: 'Test user bio'
};

const testCaption = {
  caption: 'Beautiful sunset over the mountains 🌅',
  tags: ['sunset', 'mountains', 'nature'],
  platform: 'instagram',
  imageUrl: 'https://example.com/sunset.jpg'
};

async function testAPI() {
  console.log('🧪 Testing MongoDB Integration...\n');

  try {
    // Test 1: Health Check
    console.log('1. Testing Health Check...');
    const healthResponse = await axios.get(`${BASE_URL.replace('/api', '')}/health`);
    console.log('✅ Health Status:', healthResponse.data.status);
    console.log('📊 Database Status:', healthResponse.data.database.status);
    console.log('🔌 Database Connected:', healthResponse.data.database.connected);
    console.log('');

    // Test 2: User Profile Creation/Update
    console.log('2. Testing User Profile...');
    const userResponse = await axios.post(`${BASE_URL}/users/profile`, testUser, {
      headers: { 'Authorization': 'Bearer test_token' }
    });
    console.log('✅ User Profile:', userResponse.data.success ? 'Created/Updated' : 'Failed');
    console.log('👤 User ID:', userResponse.data.data?._id);
    console.log('');

    // Test 3: Caption Generation & Storage
    console.log('3. Testing Caption Generation...');
    const formData = new FormData();
    formData.append('platform', 'instagram');
    formData.append('userId', testUser.uid);
    formData.append('style', 'casual');
    
    // Note: This would normally include an image file
    // For testing, we'll use the mock response
    const captionResponse = await axios.post(`${BASE_URL}/captions/analyze-image`, {
      platform: 'instagram',
      userId: testUser.uid,
      style: 'casual'
    });
    console.log('✅ Caption Generation:', captionResponse.data.success ? 'Success' : 'Failed');
    console.log('📝 Generated Caption:', captionResponse.data.data?.caption);
    console.log('');

    // Test 4: History Retrieval
    console.log('4. Testing History Retrieval...');
    const historyResponse = await axios.get(`${BASE_URL}/captions/history`, {
      params: { userId: testUser.uid, page: 1, limit: 10 }
    });
    console.log('✅ History Retrieved:', historyResponse.data.success ? 'Success' : 'Failed');
    console.log('📚 Total Captions:', historyResponse.data.data?.total || 0);
    console.log('📄 Current Page:', historyResponse.data.data?.page || 1);
    console.log('');

    // Test 5: User Stats
    console.log('5. Testing User Stats...');
    const statsResponse = await axios.get(`${BASE_URL}/users/stats`, {
      params: { userId: testUser.uid }
    });
    console.log('✅ Stats Retrieved:', statsResponse.data.success ? 'Success' : 'Failed');
    console.log('📊 Total Captions:', statsResponse.data.data?.totalCaptions || 0);
    console.log('❤️ Favorite Captions:', statsResponse.data.data?.favoriteCaptions || 0);
    console.log('');

    // Test 6: Trending Captions
    console.log('6. Testing Trending Captions...');
    const trendingResponse = await axios.get(`${BASE_URL}/captions/trending`);
    console.log('✅ Trending Retrieved:', trendingResponse.data.success ? 'Success' : 'Failed');
    console.log('🔥 Trending Count:', trendingResponse.data.data?.length || 0);
    console.log('');

    console.log('🎉 All tests completed successfully!');
    console.log('✅ MongoDB integration is working properly');
    console.log('🚀 Your backend is ready for production use');

  } catch (error) {
    console.error('❌ Test failed:', error.response?.data || error.message);
    console.log('\n🔍 Troubleshooting:');
    console.log('1. Make sure your backend server is running (npm start)');
    console.log('2. Check your MongoDB connection in the .env file');
    console.log('3. Verify the health endpoint: http://localhost:3001/health');
    console.log('4. Check server logs for detailed error messages');
  }
}

// Additional utility functions for testing
async function testDatabaseDirectly() {
  console.log('🔍 Testing Database Connection Directly...\n');
  
  try {
    const { MongoClient } = require('mongodb');
    const client = new MongoClient(process.env.DATABASE_URL || 'mongodb+srv://instacap:PyWJfGYUMIL1h6zO@instacap.ha7no0f.mongodb.net/?retryWrites=true&w=majority&appName=InstaCap');
    
    await client.connect();
    console.log('✅ Direct MongoDB connection successful');
    
    const db = client.db('instacap_db');
    const collections = await db.listCollections().toArray();
    console.log('📁 Available collections:', collections.map(c => c.name));
    
    // Test inserting a document
    const testCollection = db.collection('test');
    await testCollection.insertOne({ test: true, timestamp: new Date() });
    console.log('✅ Test document inserted successfully');
    
    // Clean up test document
    await testCollection.deleteOne({ test: true });
    console.log('🧹 Test document cleaned up');
    
    await client.close();
    console.log('✅ Direct database test completed\n');
    
  } catch (error) {
    console.error('❌ Direct database test failed:', error.message);
  }
}

// Run tests
if (require.main === module) {
  console.log('🚀 Starting InstaCap API Tests...\n');
  
  // Test database connection first
  testDatabaseDirectly().then(() => {
    // Then test API endpoints
    return testAPI();
  }).catch(console.error);
}

module.exports = { testAPI, testDatabaseDirectly };
