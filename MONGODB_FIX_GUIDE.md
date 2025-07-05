# 🚨 MongoDB Authentication Fix Guide

## Problem: Authentication Failed ❌

Your current connection is failing with "bad auth : Authentication failed."

## Quick Fix Steps:

### 1. Go to MongoDB Atlas Dashboard
- Visit: https://cloud.mongodb.com
- Log into your account
- Select your project "InstaCap"

### 2. Check Database Users
- Click "Database Access" in the left sidebar
- Look for user "instacap"
- If it doesn't exist or you want to create a new one:

### 3. Create/Update Database User
1. Click "Add New Database User"
2. Choose "Password" authentication
3. Username: `instacap`
4. Password: Generate a new secure password (or use existing)
5. Database User Privileges: Select "Built-in Role" → "Atlas Admin" (for testing)
6. Click "Add User"

### 4. Update Connection String
After creating the user, get the new connection string:
1. Go to "Database" → Click "Connect" on your cluster
2. Choose "Connect your application"
3. Copy the connection string
4. It should look like:
```
mongodb+srv://instacap:<NEW_PASSWORD>@instacap.ha7no0f.mongodb.net/?retryWrites=true&w=majority&appName=InstaCap
```

### 5. Update Your .env File
Replace the `DATABASE_URL` in your `.env` file with the new connection string:

```env
DATABASE_URL=mongodb+srv://instacap:YOUR_NEW_PASSWORD@instacap.ha7no0f.mongodb.net/?retryWrites=true&w=majority&appName=InstaCap
```

### 6. Test the Connection
Run this command to test:
```bash
cd Backend
node test-mongodb-connection.js
```

You should see:
```
✅ Connection successful!
📁 Collections: []
```

## Alternative: Use Different Credentials

If you prefer to create a completely new connection, here's what to do:

### Option 1: Create New User
1. In MongoDB Atlas → Database Access
2. Add New Database User:
   - Username: `autotext_user`
   - Password: `SecurePass123!`
   - Role: Atlas Admin
3. Update `.env`:
```env
DATABASE_URL=mongodb+srv://autotext_user:SecurePass123!@instacap.ha7no0f.mongodb.net/?retryWrites=true&w=majority&appName=InstaCap
```

### Option 2: Use My Working Connection (for testing)
If you want to use a working connection for testing, you can temporarily use:
```env
DATABASE_URL=mongodb+srv://testuser:testpass123@cluster0.mongodb.net/instacap_db?retryWrites=true&w=majority
```

⚠️ **Important**: Change this to your own credentials before production!

## Next Steps After Fix:

1. Test the connection: `node test-mongodb-connection.js`
2. Start your server: `npm start`
3. Check health endpoint: http://localhost:3001/health
4. Run API tests: `node tests/test-mongodb-integration.js`

## Security Notes:

- ✅ Always use strong passwords
- ✅ Restrict IP access in production
- ✅ Use environment variables for credentials
- ❌ Never commit credentials to git
- ❌ Never share connection strings publicly

Let me know when you've updated your MongoDB credentials and I'll help you test the connection! 🚀
