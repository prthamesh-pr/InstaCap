const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
const initializeFirebase = () => {
  try {
    if (!admin.apps.length) {
      // Use test mode if NODE_ENV is test
      if (process.env.NODE_ENV === 'test') {
        console.log('🧪 Initializing Firebase in test mode');
        admin.initializeApp({
          projectId: 'demo-project',
        });
        console.log('✅ Firebase Admin initialized in test mode');
        return true;
      }

      // Development mode - use default Firebase project
      if (process.env.NODE_ENV === 'development') {
        console.log('🔧 Initializing Firebase in development mode');
        admin.initializeApp({
          projectId: 'autotext-caption-generator',
        });
        console.log('✅ Firebase Admin initialized in development mode');
        return true;
      }
      
      // Production mode - require all env vars
      const requiredEnvVars = ['FIREBASE_PROJECT_ID', 'FIREBASE_CLIENT_EMAIL', 'FIREBASE_PRIVATE_KEY'];
      const missingVars = requiredEnvVars.filter(varName => !process.env[varName]);
      
      if (missingVars.length > 0) {
        console.warn(`⚠️ Missing Firebase environment variables: ${missingVars.join(', ')}`);
        console.warn('Using default configuration for development');
        
        admin.initializeApp({
          projectId: 'autotext-caption-generator',
        });
        return true;
      }

      const serviceAccount = {
        type: "service_account",
        project_id: process.env.FIREBASE_PROJECT_ID,
        client_email: process.env.FIREBASE_CLIENT_EMAIL,
        private_key: process.env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, '\n'),
      };

      admin.initializeApp({
        credential: admin.credential.cert(serviceAccount),
        projectId: process.env.FIREBASE_PROJECT_ID,
      });

      console.log('✅ Firebase Admin initialized successfully');
      return true;
    }
    return true;
  } catch (error) {
    console.error('❌ Firebase initialization error:', error.message);
    console.warn('⚠️ Continuing without Firebase authentication');
    return false;
  }
};

// Verify Firebase ID token
const verifyIdToken = async (idToken) => {
  try {
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    return decodedToken;
  } catch (error) {
    console.error('Token verification error:', error.message);
    throw new Error('Invalid token');
  }
};

// Get user by UID
const getUserByUid = async (uid) => {
  try {
    const userRecord = await admin.auth().getUser(uid);
    return userRecord;
  } catch (error) {
    console.error('Get user error:', error.message);
    throw error;
  }
};

module.exports = {
  initializeFirebase,
  verifyIdToken,
  getUserByUid,
  admin
};
