/**
 * Environment variable checker utility
 * Used to validate required environment variables on startup
 */
const checkRequiredEnvVars = () => {
  const requiredVars = [
    'OPENAI_API_KEY',
    'FIREBASE_PROJECT_ID', 
    'FIREBASE_CLIENT_EMAIL', 
    'FIREBASE_PRIVATE_KEY',
    'DATABASE_URL'
  ];
  
  const missingVars = requiredVars.filter(varName => !process.env[varName]);
  
  if (missingVars.length > 0) {
    console.warn(`⚠️ Missing environment variables: ${missingVars.join(', ')}`);
    console.warn('Some features may not work properly. Please set these variables in your .env file');
    
    // In development, we can continue with limited functionality
    if (process.env.NODE_ENV === 'development') {
      console.log('🔧 Continuing in development mode with mock data...');
      return true;
    }
    
    return false;
  }
  
  return true;
};

module.exports = { checkRequiredEnvVars };
