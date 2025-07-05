/**
 * Environment variable checker utility
 * Used to validate required environment variables on startup
 */
const checkRequiredEnvVars = () => {
  const requiredVars = [
    'OPENAI_API_KEY',
    'FIREBASE_PROJECT_ID', 
    'FIREBASE_CLIENT_EMAIL', 
    'FIREBASE_PRIVATE_KEY'
  ];
  
  const missingVars = requiredVars.filter(varName => !process.env[varName]);
  
  if (missingVars.length > 0) {
    console.error(`❌ Missing required environment variables: ${missingVars.join(', ')}`);
    console.error('Please set these variables in your .env file');
    return false;
  }
  
  return true;
};

module.exports = { checkRequiredEnvVars };
