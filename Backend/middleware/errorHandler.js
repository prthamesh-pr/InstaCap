const errorHandler = (err, req, res, next) => {
  console.error('Error:', err);

  // Default error
  let error = {
    status: err.statusCode || 500,
    message: err.message || 'Internal Server Error'
  };

  // Firebase Auth errors
  if (err.code && err.code.startsWith('auth/')) {
    error.status = 401;
    error.message = 'Authentication failed';
  }

  // OpenAI API errors
  if (err.code === 'insufficient_quota') {
    error.status = 429;
    error.message = 'AI service quota exceeded. Please try again later.';
  }

  // Validation errors
  if (err.name === 'ValidationError') {
    error.status = 400;
    error.message = 'Validation failed';
    error.details = err.details;
  }

  // File upload errors
  if (err.code === 'LIMIT_FILE_SIZE') {
    error.status = 413;
    error.message = 'File too large';
  }

  // Send error response
  res.status(error.status).json({
    success: false,
    error: error.message,
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack }),
    ...(error.details && { details: error.details })
  });
};

module.exports = errorHandler;
