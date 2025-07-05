# AutoText - Smart Social Media Caption Generator

A complete Flutter + Node.js application for generating intelligent Instagram captions using AI.

## 🚀 Features

### Frontend (Flutter)
- **Modern UI/UX** with Material 3 design
- **Firebase Authentication** (Email/Password)
- **Multi-input Support** (Text prompts & Image analysis)
- **Customizable Settings** (Tone, Style, Hashtags, Emojis)
- **Caption History** with local storage
- **Trending Suggestions** and templates
- **Dark/Light Theme** support
- **Responsive Design** for all screen sizes

### Backend (Node.js)
- **RESTful API** with Express.js
- **Firebase Admin SDK** for authentication
- **OpenAI GPT Integration** for caption generation
- **Image Analysis** using GPT-4 Vision
- **Rate Limiting** and security middleware
- **Error Handling** and validation
- **CORS** enabled for cross-origin requests

## 📋 Prerequisites

### For Backend:
- Node.js (v16+)
- npm or yarn
- OpenAI API key
- Firebase project with Admin SDK

### For Frontend:
- Flutter SDK (latest stable)
- Dart SDK
- Android Studio / Xcode (for mobile)
- Firebase project configuration

## 🛠️ Installation & Setup

### 1. Backend Setup

```bash
# Navigate to backend directory
cd Backend

# Install dependencies
npm install

# Create environment file
cp .env.example .env

# Configure your environment variables in .env:
# - OPENAI_API_KEY: Your OpenAI API key
# - FIREBASE_PROJECT_ID: Your Firebase project ID
# - FIREBASE_CLIENT_EMAIL: Service account email
# - FIREBASE_PRIVATE_KEY: Service account private key
```

#### Firebase Admin Setup:
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select existing
3. Go to Project Settings > Service Accounts
4. Generate new private key
5. Add the credentials to your `.env` file

#### OpenAI Setup:
1. Get API key from [OpenAI Platform](https://platform.openai.com/api-keys)
2. Add to `.env` file as `OPENAI_API_KEY`

```bash
# Start the backend server
npm run dev

# Server will run on http://localhost:3000
```

### 2. Frontend Setup

```bash
# Navigate to frontend directory
cd Frontend/insta_cap

# Get Flutter dependencies
flutter pub get

# Configure Firebase for Flutter
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase (follow prompts)
flutterfire configure

# This will update firebase_options.dart with your project config
```

#### Manual Firebase Configuration (Alternative):
If FlutterFire CLI doesn't work, manually update `lib/firebase_options.dart` with your Firebase project credentials.

```bash
# Run the app
flutter run

# For web
flutter run -d chrome

# For specific device
flutter devices
flutter run -d <device-id>
```

### 3. API Configuration

Update the API base URL in `lib/providers/caption_provider.dart`:

```dart
// For local development
static const String baseUrl = 'http://localhost:3000/api';

// For production
static const String baseUrl = 'https://your-api-domain.com/api';
```

## 🔧 Configuration

### Backend Environment Variables

```env
# Server Configuration
NODE_ENV=development
PORT=3000

# OpenAI Configuration
OPENAI_API_KEY=your_openai_api_key_here

# Firebase Configuration
FIREBASE_PROJECT_ID=your_firebase_project_id
FIREBASE_CLIENT_EMAIL=your_firebase_client_email
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n"

# Rate Limiting
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100

# File Upload
MAX_FILE_SIZE=5242880
ALLOWED_FILE_TYPES=image/jpeg,image/png,image/webp
```

### Frontend Configuration

Update `lib/providers/caption_provider.dart` for your backend URL:

```dart
static const String baseUrl = 'http://your-backend-url:3000/api';
```

## 📱 Usage

### For Users:
1. **Sign Up/Login** with email and password
2. **Generate Captions** by:
   - Entering a text prompt, OR
   - Uploading an image for analysis
3. **Customize** tone, style, hashtags, and emojis
4. **View History** of generated captions
5. **Browse Trending** ideas and templates

### API Endpoints:

#### Authentication
- `POST /api/auth/verify` - Verify Firebase token
- `POST /api/auth/refresh` - Refresh token
- `POST /api/auth/logout` - Logout user

#### Captions
- `POST /api/captions/generate` - Generate caption from text
- `POST /api/captions/analyze-image` - Generate caption from image
- `GET /api/captions/trending` - Get trending suggestions
- `GET /api/captions/templates` - Get caption templates

#### Users
- `GET /api/users/profile` - Get user profile
- `PUT /api/users/profile` - Update user profile
- `GET /api/users/stats` - Get user statistics

## 🚀 Deployment

### Backend Deployment (Heroku/Railway/DigitalOcean)

```bash
# Build for production
npm install --production

# Set environment variables on your hosting platform
# Deploy using your platform's CLI or web interface
```

### Frontend Deployment

#### Web Deployment:
```bash
# Build for web
flutter build web

# Deploy the build/web folder to your hosting service
# (Netlify, Vercel, Firebase Hosting, etc.)
```

#### Mobile App:
```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release
```

## 🔒 Security Features

- **Firebase Authentication** with secure token validation
- **Rate Limiting** to prevent API abuse
- **CORS** configuration for secure cross-origin requests
- **Input Validation** and sanitization
- **Error Handling** without exposing sensitive information
- **Helmet.js** for security headers

## 🧪 Testing

### Backend Testing:
```bash
cd Backend
npm test
```

### Frontend Testing:
```bash
cd Frontend/insta_cap
flutter test
```

## 📊 Monitoring & Analytics

The app includes:
- **Error Logging** for debugging
- **Request Logging** with Morgan
- **Performance Monitoring** ready
- **User Analytics** hooks (implement as needed)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Troubleshooting

### Common Issues:

#### Backend Issues:
- **Port already in use**: Change PORT in .env or kill the process
- **Firebase errors**: Verify service account credentials
- **OpenAI errors**: Check API key and quota

#### Frontend Issues:
- **Firebase not configured**: Run `flutterfire configure`
- **Dependencies issues**: Run `flutter clean && flutter pub get`
- **Network errors**: Check backend URL and CORS settings

### Getting Help:
- Check the GitHub issues for common problems
- Verify all environment variables are set correctly
- Ensure Firebase and OpenAI accounts are properly configured

## 📈 Roadmap

- [ ] **Social Media Integration** (Instagram, Twitter, Facebook)
- [ ] **Batch Caption Generation**
- [ ] **Caption Scheduling**
- [ ] **Analytics Dashboard**
- [ ] **Team Collaboration Features**
- [ ] **Multi-language Support**
- [ ] **Voice Input**
- [ ] **Caption Performance Tracking**

---

## 💡 Tips for Success

1. **Start with the backend** - get the API working first
2. **Test authentication** thoroughly before adding features
3. **Use environment variables** for all sensitive data
4. **Monitor API usage** to stay within OpenAI limits
5. **Implement proper error handling** for better UX

Happy coding! 🎉
