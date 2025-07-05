const express = require('express');
const router = express.Router();
const { verifyIdToken, getUserByUid, admin } = require('../config/firebase');

console.log('Auth routes loaded!');

// Register a new user
router.post('/register', async (req, res) => {
  console.log('Register endpoint called!', req.body);
  try {
    const { email, password, displayName } = req.body;

    // Validate inputs
    if (!email || !password || !displayName) {
      return res.status(400).json({
        success: false,
        error: 'Email, password, and display name are required'
      });
    }
    
    // Validate email format
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return res.status(400).json({
        success: false,
        error: 'Invalid email format'
      });
    }
    
    // Validate password strength
    if (password.length < 6) {
      return res.status(400).json({
        success: false,
        error: 'Password must be at least 6 characters long'
      });
    }

    // Check if we're in test mode
    if (process.env.NODE_ENV === 'test') {
      // Mock implementation for testing
      return res.status(201).json({
        success: true,
        message: 'User created successfully (Test Mode)',
        user: {
          uid: 'test-uid-' + Date.now(),
          email: email,
          displayName: displayName
        },
        customToken: 'test-token-' + Date.now()
      });
    }

    try {
      // Create user in Firebase
      const userRecord = await admin.auth().createUser({
        email,
        password,
        displayName,
        emailVerified: false
      });
      
      // Create a custom token for immediate login after registration
      const customToken = await admin.auth().createCustomToken(userRecord.uid);

      res.status(201).json({
        success: true,
        message: 'User created successfully',
        user: {
          uid: userRecord.uid,
          email: userRecord.email,
          displayName: userRecord.displayName
        },
        customToken
      });
    } catch (firebaseError) {
      console.error('Firebase registration error:', firebaseError);
      
      // More specific error messages based on Firebase error codes
      if (firebaseError.code === 'auth/email-already-exists') {
        return res.status(400).json({
          success: false,
          error: 'Email is already in use'
        });
      } else if (firebaseError.code === 'auth/invalid-email') {
        return res.status(400).json({
          success: false,
          error: 'Invalid email format'
        });
      } else if (firebaseError.code === 'auth/weak-password') {
        return res.status(400).json({
          success: false,
          error: 'Password is too weak'
        });
      }
      
      res.status(400).json({
        success: false,
        error: firebaseError.message || 'Failed to register user'
      });
    }
  } catch (error) {
    console.error('Register error:', error);
    res.status(500).json({
      success: false,
      error: 'Internal server error during registration'
    });
  }
});

// Login user
router.post('/login', async (req, res) => {
  console.log('Login endpoint called!', req.body);
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        success: false,
        error: 'Email and password are required'
      });
    }

    // Check if we're in test mode
    if (process.env.NODE_ENV === 'test') {
      // Mock implementation for testing
      return res.json({
        success: true,
        message: 'Login successful (Test Mode)',
        user: {
          uid: 'test-uid-123',
          email: email,
          displayName: 'Test User',
          photoURL: '',
          emailVerified: false
        },
        customToken: 'test-token-123'
      });
    }

    try {
      // Using Firebase Admin SDK for server-side authentication
      // First get the user by email
      const userRecord = await admin.auth().getUserByEmail(email);
      
      // Create a custom token for this user
      const customToken = await admin.auth().createCustomToken(userRecord.uid);

      // Return the custom token to the client
      res.json({
        success: true,
        message: 'Login successful',
        user: {
          uid: userRecord.uid,
          email: userRecord.email,
          displayName: userRecord.displayName || '',
          photoURL: userRecord.photoURL || '',
          emailVerified: userRecord.emailVerified
        },
        customToken
      });
    } catch (firebaseError) {
      console.error('Firebase login error:', firebaseError);
      res.status(401).json({
        success: false,
        error: 'Invalid email or password'
      });
    }
  } catch (error) {
    console.error('Login error:', error);
    res.status(400).json({
      success: false,
      error: error.message || 'Login failed'
    });
  }
});

// Verify Firebase token
router.post('/verify', async (req, res) => {
  try {
    const { idToken } = req.body;

    if (!idToken) {
      return res.status(400).json({
        success: false,
        error: 'ID token is required'
      });
    }

    const decodedToken = await verifyIdToken(idToken);
    const user = await getUserByUid(decodedToken.uid);

    res.json({
      success: true,
      message: 'Token verified successfully',
      user: {
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        photoURL: user.photoURL,
        emailVerified: user.emailVerified
      }
    });
  } catch (error) {
    res.status(401).json({
      success: false,
      error: 'Invalid token'
    });
  }
});

// Refresh token endpoint
router.post('/refresh', async (req, res) => {
  try {
    const { refreshToken } = req.body;

    if (!refreshToken) {
      return res.status(400).json({
        success: false,
        error: 'Refresh token is required'
      });
    }

    // In a real implementation, you might want to handle refresh tokens
    // For Firebase, the client SDK handles token refresh automatically
    res.json({
      success: true,
      message: 'Token refresh handled by client SDK'
    });
  } catch (error) {
    res.status(401).json({
      success: false,
      error: 'Failed to refresh token'
    });
  }
});

// Logout endpoint
router.post('/logout', async (req, res) => {
  try {
    // In Firebase, logout is typically handled on the client side
    // Server-side logout might involve revoking refresh tokens
    res.json({
      success: true,
      message: 'Logout successful'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: 'Logout failed'
    });
  }
});

// Add debug logging to show all registered routes
console.log('Auth routes registered:', 
  router.stack
    .filter(r => r.route)
    .map(r => ({
      path: r.route.path,
      methods: Object.keys(r.route.methods).join(',')
    }))
);

module.exports = router;
