# InstaCap - AI-Powered Caption Generator 📱✨

A beautiful Flutter application that generates AI-powered captions for your social media posts using image analysis.

## 🌟 Features

- **AI-Powered Caption Generation**: Upload an image and get engaging captions
- **Beautiful Liquid Glass UI**: Modern glassmorphism design with neon effects
- **Firebase Authentication**: Secure user authentication with email/password
- **Caption History**: Save and manage your generated captions
- **Cross-Platform**: Works on Android, iOS, and Web
- **Multiple Caption Styles**: Professional, casual, funny, and inspirational tones
- **Social Media Ready**: Optimized for Instagram, Facebook, Twitter, and more

## 🚀 Live Demo

- **Frontend**: Deployed on Flutter Web
- **Backend API**: https://instacap.onrender.com

## 🛠️ Tech Stack

### Frontend
- **Flutter 3.32.1** - Cross-platform development
- **Material Design 3** - Modern UI components
- **Provider** - State management
- **Firebase Auth** - User authentication
- **Google Fonts** - Typography (Plus Jakarta Sans, Inter)
- **Glassmorphism** - Modern UI effects
- **Animate Do** - Smooth animations

### Backend
- **Node.js & Express** - REST API server
- **OpenAI GPT** - AI caption generation
- **Firebase Admin** - User verification
- **Multer** - File upload handling
- **CORS** - Cross-origin support

## 📱 Screenshots

*Beautiful liquid glass interface with modern design*

## 🏗️ Project Structure

```
InstaCap/
├── Frontend/
│   └── insta_cap/
│       ├── lib/
│       │   ├── core/           # App configuration & themes
│       │   ├── models/         # Data models
│       │   ├── providers/      # State management
│       │   ├── services/       # API & authentication services
│       │   ├── presentation/   # UI screens & widgets
│       │   └── main.dart       # App entry point
│       ├── web/               # Web-specific files
│       └── android/           # Android configuration
├── Backend/
│   ├── routes/                # API endpoints
│   ├── middleware/            # Authentication & error handling
│   ├── config/                # Firebase & database config
│   ├── utils/                 # Utility functions
│   └── server.js             # Express server
└── docs/                     # Documentation
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0+)
- Node.js (16+)
- Firebase project
- OpenAI API key

### Frontend Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/prthamesh-pr/InstaCap.git
   cd InstaCap/Frontend/insta_cap
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Add your Firebase configuration to `lib/firebase_options.dart`
   - Update `web/index.html` with your Firebase config

4. **Run the app**
   ```bash
   flutter run
   ```

### Backend Setup

1. **Navigate to backend**
   ```bash
   cd Backend
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Environment variables**
   Create `.env` file:
   ```env
   NODE_ENV=production
   PORT=3001
   OPENAI_API_KEY=your_openai_api_key
   FIREBASE_PROJECT_ID=your_firebase_project_id
   FIREBASE_CLIENT_EMAIL=your_firebase_client_email
   FIREBASE_PRIVATE_KEY=your_firebase_private_key
   ```

4. **Start the server**
   ```bash
   npm start
   ```

## 🔥 Key Features Implementation

### Liquid Glass UI
- Custom glass widgets with backdrop filters
- Neon glow effects and animations
- Responsive design with ScreenUtil
- Modern color gradients and shadows

### AI Caption Generation
- OpenAI GPT integration for smart captions
- Image analysis for context-aware generation
- Multiple tone options (professional, casual, funny)
- Real-time generation with loading states

### Firebase Integration
- Secure user authentication
- Cloud Firestore for data storage
- Firebase Storage for image uploads
- Admin SDK for backend verification

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows (Flutter Desktop)
- ✅ macOS (Flutter Desktop)

## 🔧 Development

### Running Tests
```bash
# Frontend tests
cd Frontend/insta_cap
flutter test

# Backend tests
cd Backend
npm test
```

### Building for Production
```bash
# Android APK
flutter build apk --release

# iOS IPA
flutter build ipa --release

# Web
flutter build web --release
```

## 🌐 API Endpoints

### Authentication
- `POST /api/auth/verify` - Verify Firebase token

### Caption Generation
- `POST /api/captions/analyze-image` - Generate caption from image
- `GET /api/captions/history` - Get user's caption history
- `POST /api/captions/save` - Save a caption
- `DELETE /api/captions/:id` - Delete a caption

### User Management
- `GET /api/users/profile` - Get user profile
- `PUT /api/users/profile` - Update user profile
- `GET /api/users/stats` - Get user statistics

## 🎨 Design System

### Colors
- **Primary**: Purple gradient (#6C63FF → #8B84FF)
- **Secondary**: Coral (#FF6B6B → #FF8A8A)
- **Accent**: Cyan (#4ECDC4 → #6EDDDD)
- **Glass Effects**: Semi-transparent whites and blacks

### Typography
- **Headers**: Plus Jakarta Sans (Bold)
- **Body**: Inter (Regular/Medium)
- **Responsive**: ScreenUtil for adaptive sizing

## 🚀 Deployment

### Frontend (Web)
1. Build the web version:
   ```bash
   flutter build web --release
   ```
2. Deploy to Firebase Hosting, Netlify, or Vercel

### Backend (API)
1. Deploy to Render, Heroku, or DigitalOcean
2. Set environment variables
3. Update frontend API URL

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Prthamesh**
- GitHub: [@prthamesh-pr](https://github.com/prthamesh-pr)

## 🙏 Acknowledgments

- OpenAI for GPT API
- Firebase for authentication and hosting
- Flutter team for the amazing framework
- Material Design for UI guidelines

---

Made with ❤️ using Flutter & Node.js
