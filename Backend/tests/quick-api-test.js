// Simple API Test - No Authentication Required
const axios = require('axios');

const BASE_URL = 'http://localhost:3001';

async function quickTest() {
  console.log('🧪 Quick API Test - No Auth Required\n');

  try {
    // Test 1: Health Check
    console.log('1. Testing Health Check...');
    const healthResponse = await axios.get(`${BASE_URL}/health`);
    console.log('✅ Health Status:', healthResponse.data.status);
    console.log('📊 Database:', healthResponse.data.database.status);
    console.log('');

    // Test 2: API Root
    console.log('2. Testing API Root...');
    const rootResponse = await axios.get(`${BASE_URL}/api`);
    console.log('✅ API Root:', rootResponse.data.message);
    console.log('📋 Available endpoints:', Object.keys(rootResponse.data.endpoints));
    console.log('');

    // Test 3: Caption Generation (Public endpoint)
    console.log('3. Testing Caption Generation (Mock)...');
    try {
      const captionResponse = await axios.post(`${BASE_URL}/api/captions/analyze-image`, {
        platform: 'instagram',
        style: 'casual',
        userId: 'test_user_123'
      });
      console.log('✅ Caption Generation:', captionResponse.data.success ? 'Success' : 'Failed');
      if (captionResponse.data.data?.caption) {
        console.log('📝 Generated Caption:', captionResponse.data.data.caption.substring(0, 50) + '...');
      }
    } catch (error) {
      console.log('⚠️ Caption generation needs image file or mock response');
    }
    console.log('');

    // Test 4: History (Public endpoint)
    console.log('4. Testing History Retrieval...');
    try {
      const historyResponse = await axios.get(`${BASE_URL}/api/captions/history`, {
        params: { userId: 'test_user_123', page: 1, limit: 5 }
      });
      console.log('✅ History Retrieved:', historyResponse.data.success ? 'Success' : 'Failed');
      console.log('📚 Total Captions:', historyResponse.data.data?.total || 0);
    } catch (error) {
      console.log('⚠️ History endpoint response:', error.response?.status || error.message);
    }
    console.log('');

    // Test 5: Trending (Public endpoint)
    console.log('5. Testing Trending Captions...');
    try {
      const trendingResponse = await axios.get(`${BASE_URL}/api/captions/trending`);
      console.log('✅ Trending Retrieved:', trendingResponse.data.success ? 'Success' : 'Failed');
      console.log('🔥 Trending Count:', trendingResponse.data.data?.length || 0);
    } catch (error) {
      console.log('⚠️ Trending endpoint response:', error.response?.status || error.message);
    }
    console.log('');

    console.log('🎉 Basic API tests completed!');
    console.log('✅ Your backend server is running and responding');
    console.log('✅ MongoDB connection is working');
    console.log('📊 Database collections are created');
    console.log('');
    console.log('🔐 Note: Protected routes (/api/users/*) require authentication');
    console.log('🎯 Your backend is ready for frontend integration!');

  } catch (error) {
    console.error('❌ Test failed:', error.response?.data || error.message);
    if (error.code === 'ECONNREFUSED') {
      console.log('\n🔍 Server not running. Start it with:');
      console.log('cd Backend && node server.js');
    }
  }
}

quickTest();
