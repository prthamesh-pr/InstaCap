# InstaCap - Smart Social Media Caption Generator

A full-stack application that generates intelligent captions for social media images using AI. The project consists of a Node.js backend API and a Flutter mobile application.

## 🚀 Features

- **AI-Powered Caption Generation**: Generate creative, professional, funny, or inspirational captions
- **Multiple Platform Support**: Optimized captions for Instagram, Facebook, Twitter, and LinkedIn
- **Image Analysis**: Advanced image processing for context-aware captions
- **User Authentication**: Secure Firebase-based authentication
- **Caption History**: Save and manage generated captions
- **Trending Captions**: Discover popular captions from the community
- **Real-time Database**: MongoDB Atlas integration for scalable data storage

## 📁 Project Structure

```
InstaCap/
├── Backend/                 # Node.js API Server
│   ├── config/             # Configuration files
│   ├── middleware/         # Express middleware
│   ├── models/            # Database models
│   ├── routes/            # API routes
│   ├── services/          # Business logic services
│   ├── utils/             # Utility functions
│   └── tests/             # API tests
├── Frontend/               # Flutter Mobile App
│   └── insta_cap/         # Flutter project
├── docs/                  # Documentation
└── scripts/               # Utility scripts
```

## 🛠️ Technology Stack

### Backend
- **Node.js** with Express.js
- **MongoDB Atlas** for database
- **Firebase Admin** for authentication
- **OpenAI API** for advanced caption generation
- **Multer** for file upload handling
- **Sharp** for image processing
- **Python** integration for image analysis

### Frontend
- **Flutter** for cross-platform mobile app
- **Dart** programming language
- **BLoC** pattern for state management
- **Firebase** for authentication
- **Dio** for HTTP client

## 🔧 Installation & Setup

### Backend Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd InstaCap/Backend
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Environment Configuration**
   Create a `.env` file in the Backend directory:
   ```env
   NODE_ENV=development
   PORT=3001
   
   # MongoDB Atlas
   DATABASE_URL=mongodb+srv://username:password@cluster.mongodb.net/?retryWrites=true&w=majority&appName=InstaCap
   
   # OpenAI API
   OPENAI_API_KEY=your_openai_api_key
   
   # Firebase Configuration
   FIREBASE_PROJECT_ID=your_project_id
   FIREBASE_CLIENT_EMAIL=your_service_account_email
   FIREBASE_PRIVATE_KEY="your_private_key"
   
   # Security
   JWT_SECRET=your_jwt_secret
   ```

4. **Start the server**
   ```bash
   npm start
   ```

   The server will run on `http://localhost:3001`

### Frontend Setup

1. **Navigate to Flutter project**
   ```bash
   cd Frontend/insta_cap
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 📡 API Endpoints

### Caption Generation
- `POST /api/captions/analyze-image` - Generate captions from image
- `GET /api/captions/history` - Get user's caption history
- `GET /api/captions/trending` - Get trending captions

### Authentication
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `POST /api/auth/verify` - Verify JWT token
- `POST /api/auth/refresh` - Refresh access token

### User Management
- `GET /api/users/profile` - Get user profile
- `PUT /api/users/profile` - Update user profile

## 🧪 Testing

### Backend Tests
```bash
cd Backend
npm test
```

### API Testing with Postman
1. Import the Postman collection from `Backend/postman/`
2. Set up environment variables
3. Run the test suite

### Manual API Testing
```bash
# Test caption generation
node tests/test-caption-generation-mock.js

# Test MongoDB connection
node test-mongodb-connection.js
```

## 🔒 Security Features

- JWT-based authentication
- Firebase Admin SDK integration
- Rate limiting on API endpoints
- Input validation with Joi
- Secure file upload handling
- Environment variable protection

## 🌟 Key Features Implemented

### ✅ Caption Generation
- Multiple caption styles (casual, professional, funny, inspirational)
- Platform-specific optimization
- Hashtag and emoji integration
- Confidence scoring

### ✅ Database Integration
- MongoDB Atlas connection
- User caption history
- Analytics and trending data
- Efficient indexing

### ✅ Authentication System
- Firebase-based authentication
- JWT token management
- User session handling
- Secure API endpoints

### ✅ Error Handling
- Comprehensive error messages
- Fallback mechanisms
- Logging and monitoring
- Graceful degradation

## 🚧 Current Status

- ✅ Backend API fully functional
- ✅ MongoDB Atlas connected
- ✅ Multiple caption generation working
- ✅ Authentication system implemented
- ✅ Flutter app structure complete
- 🔄 Frontend-backend integration in progress

## 📱 Flutter App Features

- Beautiful UI with animations
- Image picker integration
- Caption generation flow
- History management
- Trending captions view
- User profile management

## 🔮 Future Enhancements

- [ ] Advanced image analysis with computer vision
- [ ] Social sharing integration
- [ ] Caption templates and customization
- [ ] Multi-language support
- [ ] Analytics dashboard
- [ ] Premium features

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

For support and questions:
- Create an issue in this repository
- Check the documentation in the `/docs` folder
- Review the API test files for examples

## 🎉 Acknowledgments

- OpenAI for GPT-4 Vision API
- Firebase for authentication services
- MongoDB Atlas for database hosting
- Flutter team for the amazing framework

---

**InstaCap** - Making social media captions intelligent and effortless! ✨
