# InstaCap Backend API

This is the backend for the InstaCap application, a smart social media caption generator.

## Features

- Firebase Authentication
- OpenAI integration for generating captions
- User management
- Caption generation API
- MongoDB integration

## Prerequisites

- Node.js (>=18.0.0)
- npm or yarn
- MongoDB account
- OpenAI API key
- Firebase project

## Environment Setup

1. Create a `.env` file in the root directory with the following variables:

```
# Environment Configuration
NODE_ENV=development
PORT=3000

# OpenAI Configuration
OPENAI_API_KEY=your_openai_api_key_here

# Firebase Configuration
FIREBASE_PROJECT_ID="your-firebase-project-id"
FIREBASE_CLIENT_EMAIL="your-firebase-client-email"
FIREBASE_PRIVATE_KEY="your-firebase-private-key"

# Database Configuration (if using database)
DATABASE_URL=your_mongodb_connection_string
```

## Installation

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Start production server
npm start
```

## API Endpoints

### Authentication

- `POST /api/auth/register` - Register a new user
- `POST /api/auth/login` - Login a user
- `GET /api/auth/user` - Get current user

### Captions

- `POST /api/captions/generate` - Generate a new caption
- `GET /api/captions` - Get user's captions
- `DELETE /api/captions/:id` - Delete a caption

### Users

- `GET /api/users/profile` - Get user profile
- `PUT /api/users/profile` - Update user profile

## Deployment

This API can be deployed to platforms like Heroku, Railway, or Vercel.

## License

MIT
