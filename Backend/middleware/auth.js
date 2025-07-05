const { verifyIdToken } = require('../config/firebase');

const authenticateToken = async (req, res, next) => {
  try {
    // Skip auth in test mode or if explicitly disabled
    if (process.env.NODE_ENV === 'test' || process.env.SKIP_AUTH === 'true') {
      req.user = {
        uid: 'test-user-id',
        email: 'test@example.com',
        name: 'Test User'
      };
      return next();
    }

    const authHeader = req.headers.authorization;
    const token = authHeader && authHeader.split(' ')[1]; // Bearer TOKEN

    if (!token) {
      return res.status(401).json({
        success: false,
        error: 'Access denied',
        message: 'No token provided'
      });
    }

    try {
      // Verify Firebase ID token
      const decodedToken = await verifyIdToken(token);
      req.user = decodedToken;
      next();
    } catch (tokenError) {
      console.error('Token verification error:', tokenError.message);
      
      // In development, be more lenient
      if (process.env.NODE_ENV === 'development') {
        console.warn('⚠️ Token verification failed in development mode, allowing request');
        req.user = {
          uid: 'dev-user-id',
          email: 'dev@example.com',
          name: 'Development User'
        };
        return next();
      }
      
      return res.status(403).json({
        success: false,
        error: 'Forbidden',
        message: 'Invalid or expired token'
      });
    }
  } catch (error) {
    console.error('Authentication middleware error:', error.message);
    return res.status(500).json({
      success: false,
      error: 'Authentication error',
      message: 'An error occurred during authentication'
    });
  }
};

module.exports = authenticateToken;
