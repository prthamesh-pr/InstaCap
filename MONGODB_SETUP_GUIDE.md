# 📊 MongoDB Setup Guide for InstaCap

This guide will help you set up MongoDB Atlas (cloud database) for your InstaCap project.

## 🚀 Quick Setup (5 minutes)

### Step 1: Create MongoDB Atlas Account
1. Go to [MongoDB Atlas](https://cloud.mongodb.com)
2. Click "Try Free" or "Sign Up"
3. Create an account using email or Google/GitHub

### Step 2: Create a New Project
1. After logging in, click "New Project"
2. Name it "InstaCap" or "AutoText"
3. Click "Next" → "Create Project"

### Step 3: Create a Database Cluster
1. Click "Build a Database"
2. Choose **FREE** tier (M0 Sandbox)
3. Select a cloud provider (AWS recommended)
4. Choose region closest to you
5. Name your cluster "InstaCap" or keep default
6. Click "Create"

### Step 4: Create Database User
1. Under "Security Quick Start", create a database user:
   - Username: `instacap`
   - Password: Generate secure password or use: `PyWJfGYUMIL1h6zO`
   - Click "Create User"

### Step 5: Set Network Access
1. Click "Add IP Address"
2. For development, click "Allow Access from Anywhere" (0.0.0.0/0)
3. For production, add your specific IP addresses
4. Click "Confirm"

### Step 6: Get Connection String
1. Click "Connect" on your cluster
2. Choose "Connect your application"
3. Select "Node.js" and latest version
4. Copy the connection string (looks like):
   ```
   mongodb+srv://instacap:<password>@instacap.xxxxx.mongodb.net/?retryWrites=true&w=majority
   ```
5. Replace `<password>` with your actual password

### Step 7: Update Your .env File
Your `.env` file should already have:
```env
DATABASE_URL=mongodb+srv://instacap:PyWJfGYUMIL1h6zO@instacap.ha7no0f.mongodb.net/?retryWrites=true&w=majority&appName=InstaCap
MONGODB_DB_NAME=instacap_db
```

## 🔧 Testing the Connection

### 1. Start Your Backend Server
```bash
cd Backend
npm start
```

### 2. Check Health Endpoint
Visit: http://localhost:3001/health

You should see:
```json
{
  "status": "OK",
  "timestamp": "2025-01-05T...",
  "uptime": 123.45,
  "database": {
    "status": "connected",
    "connected": true,
    "ping": "success"
  },
  "services": {
    "firebase": true,
    "openai": true
  }
}
```

### 3. Check MongoDB Compass (Optional)
1. Download [MongoDB Compass](https://www.mongodb.com/products/compass)
2. Connect using your connection string
3. You should see your `instacap_db` database with collections:
   - `users`
   - `captions`
   - `analytics`
   - `trending`

## 📊 Database Structure

Your MongoDB database will automatically create these collections:

### `users` Collection
```javascript
{
  _id: ObjectId,
  uid: "firebase_user_id",
  email: "user@example.com",
  name: "User Name",
  profilePicture: "url",
  bio: "User bio",
  preferences: {
    theme: "dark",
    language: "en",
    notifications: true
  },
  stats: {
    totalCaptions: 0,
    favoriteCaptions: 0,
    totalLikes: 0
  },
  createdAt: Date,
  updatedAt: Date
}
```

### `captions` Collection
```javascript
{
  _id: ObjectId,
  userId: "firebase_user_id",
  caption: "Generated caption text",
  tags: ["tag1", "tag2"],
  platform: "instagram",
  imageUrl: "url",
  imageAnalysis: "AI analysis results",
  likes: 0,
  isFavorite: false,
  isPublic: false,
  metadata: {
    confidence: 0.95,
    processingTime: 1234,
    model: "gpt-4-vision"
  },
  createdAt: Date,
  updatedAt: Date
}
```

### `analytics` Collection
```javascript
{
  _id: ObjectId,
  userId: "firebase_user_id",
  event: "caption_generated",
  data: {},
  timestamp: Date
}
```

### `trending` Collection
```javascript
{
  _id: ObjectId,
  captionId: ObjectId,
  score: 100,
  category: "lifestyle",
  updatedAt: Date
}
```

## 🔒 Security Best Practices

### For Development:
- ✅ Your current setup is good for development
- ✅ Network access allows all IPs (0.0.0.0/0)

### For Production:
1. **Restrict IP Access**: Only allow your server's IP
2. **Use Strong Passwords**: Generate complex database passwords
3. **Enable Database Authentication**: Already enabled
4. **Use Environment Variables**: Never commit credentials to git
5. **Enable Audit Logs**: Available in paid plans

## 🚨 Troubleshooting

### Connection Issues:
1. **Check your connection string** - ensure password is correct
2. **Verify network access** - ensure your IP is whitelisted
3. **Check database user** - ensure user has read/write permissions

### Common Errors:
- `MongoServerError: bad auth` → Wrong username/password
- `MongoNetworkError` → Network/firewall issue
- `MongooseTimeoutError` → Connection timeout, check network

### Debug Commands:
```bash
# Test connection manually
node -e "
const { MongoClient } = require('mongodb');
const client = new MongoClient('YOUR_CONNECTION_STRING');
client.connect().then(() => {
  console.log('✅ Connected successfully');
  client.close();
}).catch(console.error);
"
```

## 📱 Next Steps

1. ✅ **Database Setup Complete** - Your backend is now connected to MongoDB
2. 🔄 **Test API Endpoints** - Use Postman or frontend to test CRUD operations
3. 🧹 **Clean Up Duplicates** - Run the cleanup script to remove duplicate files
4. 🎨 **Frontend Integration** - Ensure frontend uses the cleaned-up files
5. 🚀 **Deploy** - Deploy backend to production with proper security

## 🎯 Key Features Ready

Your backend now supports:
- ✅ User registration and profiles
- ✅ Caption generation and storage
- ✅ History with pagination and filtering
- ✅ Favorites and analytics
- ✅ Trending captions
- ✅ Real-time database operations
- ✅ Proper error handling
- ✅ Health monitoring

## 📞 Support

If you encounter any issues:
1. Check the server logs for detailed error messages
2. Verify your `.env` file configuration
3. Test the `/health` endpoint
4. Check MongoDB Atlas dashboard for connection status

**Your InstaCap backend is now production-ready with MongoDB Atlas! 🎉**
