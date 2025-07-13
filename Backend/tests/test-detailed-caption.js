// Detailed Caption Generation Test with Error Handling
const axios = require('axios');

const BASE_URL = 'http://localhost:3001/api';

async function detailedCaptionTest() {
  console.log('🔍 Detailed Caption Generation Test\n');

  // Test 1: Check if server is responding
  console.log('1. Testing server connectivity...');
  try {
    const healthResponse = await axios.get('http://localhost:3001/health');
    console.log('✅ Server is running:', healthResponse.data.status);
    console.log('📊 Database status:', healthResponse.data.database?.status);
  } catch (error) {
    console.log('❌ Server not responding:', error.message);
    return;
  }

  // Test 2: Check available routes
  console.log('\n2. Checking API routes...');
  try {
    const apiResponse = await axios.get(`${BASE_URL}`);
    console.log('✅ API Root:', apiResponse.data.message);
    console.log('📋 Available endpoints:', apiResponse.data.endpoints);
  } catch (error) {
    console.log('❌ API root failed:', error.response?.status, error.response?.data);
  }

  // Test 3: Test caption generation with detailed error handling
  console.log('\n3. Testing caption generation endpoint...');
  try {
    const captionData = {
      platform: 'instagram',
      style: 'casual',
      userId: 'test_user_123'
    };

    console.log('📤 Sending request to:', `${BASE_URL}/captions/analyze-image`);
    console.log('📦 Request data:', captionData);

    const response = await axios.post(`${BASE_URL}/captions/analyze-image`, captionData, {
      headers: {
        'Content-Type': 'application/json'
      },
      timeout: 10000
    });

    console.log('✅ Response status:', response.status);
    console.log('📨 Response data:', response.data);
    
  } catch (error) {
    console.log('❌ Caption generation failed:');
    console.log('   Status:', error.response?.status);
    console.log('   Status Text:', error.response?.statusText);
    console.log('   Error Message:', error.response?.data?.message || error.message);
    console.log('   Full Error Data:', error.response?.data);
    
    if (error.code === 'ECONNREFUSED') {
      console.log('🔍 Connection refused - server may not be running');
    } else if (error.code === 'ECONNRESET') {
      console.log('🔍 Connection reset - server may be overloaded');
    }
  }

  // Test 4: Test trending endpoint (should work)
  console.log('\n4. Testing trending endpoint...');
  try {
    const trendingResponse = await axios.get(`${BASE_URL}/captions/trending`);
    console.log('✅ Trending status:', trendingResponse.status);
    console.log('📊 Trending data count:', trendingResponse.data.data?.length);
    console.log('🔥 First trending item:', trendingResponse.data.data?.[0]?.caption?.substring(0, 50));
  } catch (error) {
    console.log('❌ Trending failed:');
    console.log('   Status:', error.response?.status);
    console.log('   Error:', error.response?.data?.message || error.message);
  }

  // Test 5: Test with authentication (if needed)
  console.log('\n5. Testing with mock authentication...');
  try {
    const authHeaders = {
      'Authorization': 'Bearer test_token_123',
      'Content-Type': 'application/json'
    };

    const authResponse = await axios.post(`${BASE_URL}/captions/analyze-image`, {
      platform: 'instagram',
      style: 'casual',
      userId: 'test_user_123'
    }, { headers: authHeaders });

    console.log('✅ Auth response status:', authResponse.status);
    console.log('📨 Auth response data:', authResponse.data);
    
  } catch (error) {
    console.log('❌ Auth test failed:');
    console.log('   Status:', error.response?.status);
    console.log('   Error:', error.response?.data?.message || error.message);
    
    if (error.response?.status === 401) {
      console.log('🔐 Authentication required - this is expected');
    }
  }

  console.log('\n📋 Summary:');
  console.log('- Server connectivity: Check above results');
  console.log('- API endpoints: Check route availability');
  console.log('- Authentication: May be required for some endpoints');
  console.log('- Error details: See specific error messages above');
}

detailedCaptionTest();
