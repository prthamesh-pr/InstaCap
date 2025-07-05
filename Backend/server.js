const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const compression = require('compression');
const morgan = require('morgan');
const rateLimit = require('express-rate-limit');
require('dotenv').config();

// Check environment variables
const { checkRequiredEnvVars } = require('./utils/checkEnv');
const envVarsPresent = checkRequiredEnvVars();

// Initialize Firebase only if environment variables are present
const { initializeFirebase, admin } = require('./config/firebase');
let firebaseInitialized = false;
if (envVarsPresent) {
  try {
    firebaseInitialized = initializeFirebase();
    if (firebaseInitialized) {
      console.log('✅ Firebase initialized and ready for auth operations');
    }
  } catch (error) {
    console.error('❌ Firebase initialization failed:', error.message);
    if (process.env.NODE_ENV === 'production') {
      process.exit(1); // Exit in production if Firebase fails to initialize
    }
  }
} else {
  console.warn('⚠️ Starting server with limited functionality due to missing environment variables');
}

// Import MongoDB connection
const mongoService = require('./config/mongodb');

// Import routes
const authRoutes = require('./routes/auth');
const captionRoutes = require('./routes/captions');
const userRoutes = require('./routes/users');
const userDetailsRoutes = require('./routes/user-details');

console.log('Routes imported');

// Import middleware
const errorHandler = require('./middleware/errorHandler');
const authenticateToken = require('./middleware/auth');

const app = express();
const PORT = process.env.PORT || 3000;

// Security middleware
app.use(helmet());
app.use(compression());

// CORS configuration
app.use(cors({
  origin: function (origin, callback) {
    // Allow requests with no origin (like mobile apps or curl requests)
    if (!origin) return callback(null, true);
    
    // Allow Flutter web in development (localhost with random ports)
    if (origin.startsWith('http://localhost:') || origin.startsWith('http://127.0.0.1:')) {
      return callback(null, true);
    }
    
    // Allow production domains
    const allowedOrigins = [
      'https://instacap.onrender.com'
    ];
    
    if (allowedOrigins.includes(origin)) {
      return callback(null, true);
    }
    
    // For development, allow all origins
    if (process.env.NODE_ENV === 'development') {
      return callback(null, true);
    }
    
    return callback(new Error('Not allowed by CORS'));
  },
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS', 'PATCH'],
  allowedHeaders: ['Content-Type', 'Authorization', 'Accept', 'Origin', 'X-Requested-With'],
  optionsSuccessStatus: 200,
  preflightContinue: false
}));

// Explicitly handle preflight requests
app.options('*', (req, res) => {
  res.header('Access-Control-Allow-Origin', req.headers.origin || '*');
  res.header('Access-Control-Allow-Methods', 'GET,POST,PUT,DELETE,OPTIONS,PATCH');
  res.header('Access-Control-Allow-Headers', 'Content-Type,Authorization,Accept,Origin,X-Requested-With');
  res.header('Access-Control-Allow-Credentials', 'true');
  res.status(200).end();
});

// Request logging
if (process.env.NODE_ENV !== 'test') {
  app.use(morgan('combined'));
}

// Rate limiting
const limiter = rateLimit({
  windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 15 * 60 * 1000, // 15 minutes
  max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS) || 100, // limit each IP to 100 requests per windowMs
  message: {
    error: 'Too many requests from this IP, please try again later.'
  }
});
app.use('/api/', limiter);

// Body parsing middleware
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Health check endpoint
app.get('/health', async (req, res) => {
  try {
    const dbStatus = mongoService.isConnected ? 'connected' : 'disconnected';
    const dbConnection = await mongoService.getDb().admin().ping();
    
    res.status(200).json({
      status: 'OK',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      database: {
        status: dbStatus,
        connected: mongoService.isConnected,
        ping: dbConnection ? 'success' : 'failed'
      },
      services: {
        firebase: firebaseInitialized,
        openai: !!process.env.OPENAI_API_KEY
      }
    });
  } catch (error) {
    res.status(503).json({
      status: 'ERROR',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      database: {
        status: 'disconnected',
        connected: false,
        error: error.message
      },
      services: {
        firebase: firebaseInitialized,
        openai: !!process.env.OPENAI_API_KEY
      }
    });
  }
});

// API Routes
console.log('Setting up routes...');

// Get auth routes for logging
const listEndpoints = (router) => {
  return router.stack
    .filter(layer => layer.route)
    .map(layer => {
      const path = layer.route?.path;
      const methods = Object.keys(layer.route.methods).join(', ');
      return { path, methods };
    });
};

// Register auth routes
app.use('/api/auth', authRoutes);
console.log('Auth routes set up!');
console.log('Auth routes registered:', listEndpoints(authRoutes));

// Register protected routes
app.use('/api/users', authenticateToken, userRoutes);
app.use('/api/user-details', userDetailsRoutes);

// Register caption routes - some endpoints are public, others protected
app.use('/api/captions', captionRoutes);

// Debug endpoint to test direct route registration
app.post('/api/auth/register-test', (req, res) => {
  console.log('Register test endpoint called!', req.body);
  res.json({
    success: true,
    message: 'Register test endpoint working!',
    data: req.body
  });
});

// Simple API test endpoint (publicly accessible)
app.get('/api/test', (req, res) => {
  res.status(200).json({ 
    message: 'API is working correctly!',
    timestamp: new Date(),
    env: process.env.NODE_ENV
  });
});

// Root endpoint
app.get('/', (req, res) => {
  res.json({
    message: 'AutoText API Server',
    version: '1.0.0',
    endpoints: {
      health: '/health',
      auth: '/api/auth',
      captions: '/api/captions',
      users: '/api/users'
    }
  });
});

// API Root endpoint
app.get('/api', (req, res) => {
  res.json({
    message: 'AutoText API',
    version: '1.0.0',
    status: 'active',
    endpoints: {
      auth: '/api/auth',
      captions: '/api/captions',
      users: '/api/users'
    },
    documentation: 'https://github.com/your-repo/instacap-api'
  });
});

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({
    error: 'Route not found',
    message: `Cannot ${req.method} ${req.originalUrl}`
  });
});

// Global error handler
app.use(errorHandler);

// Unhandled promise rejections
process.on('unhandledRejection', (reason, promise) => {
  console.error('Unhandled Rejection at:', promise, 'reason:', reason);
});

// Uncaught exceptions
process.on('uncaughtException', (error) => {
  console.error('Uncaught Exception:', error);
  
  // Give the server a chance to gracefully terminate
  setTimeout(() => {
    process.exit(1);
  }, 1000).unref();
});

// Start server with MongoDB connection
async function startServer() {
  try {
    // Connect to MongoDB first
    const mongoConnected = await mongoService.connect();
    if (!mongoConnected) {
      console.error('❌ Failed to connect to MongoDB');
      if (process.env.NODE_ENV === 'production') {
        process.exit(1);
      }
    }

    // Start the Express server
    app.listen(PORT, '0.0.0.0', () => {
      console.log(`🚀 AutoText API Server running on port ${PORT}`);
      console.log(`📍 Environment: ${process.env.NODE_ENV || 'development'}`);
      console.log(`🔗 Health check: http://localhost:${PORT}/health`);
      console.log(`🌐 Server accessible from: http://localhost:${PORT}, http://127.0.0.1:${PORT}`);
      console.log(`📱 Flutter can use: http://localhost:${PORT} or http://127.0.0.1:${PORT}`);
    });

  } catch (error) {
    console.error('❌ Failed to start server:', error);
    process.exit(1);
  }
}

// Graceful shutdown
process.on('SIGINT', async () => {
  console.log('\n🔄 Graceful shutdown initiated...');
  try {
    await mongoService.disconnect();
    console.log('✅ Server shut down gracefully');
    process.exit(0);
  } catch (error) {
    console.error('❌ Error during shutdown:', error);
    process.exit(1);
  }
});

process.on('SIGTERM', async () => {
  console.log('\n🔄 SIGTERM received, shutting down gracefully...');
  try {
    await mongoService.disconnect();
    process.exit(0);
  } catch (error) {
    console.error('❌ Error during shutdown:', error);
    process.exit(1);
  }
});

// Start server
startServer();

module.exports = app;
