const express = require('express');
const router = express.Router();
const authenticateToken = require('../middleware/auth');
const { getDatabase } = require('../config/mongodb');

// GET /api/user-details - Get user profile details
router.get('/', authenticateToken, async (req, res) => {
  try {
    const db = getDatabase();
    if (!db) {
      return res.status(500).json({ 
        success: false, 
        error: 'Database connection not available' 
      });
    }

    const usersCollection = db.collection('users');
    const user = await usersCollection.findOne({ 
      uid: req.user.uid 
    });

    if (!user) {
      return res.status(404).json({ 
        success: false, 
        error: 'User not found' 
      });
    }

    // Remove sensitive information
    const { _id, uid, ...userDetails } = user;

    res.json({
      success: true,
      data: {
        uid: uid,
        name: userDetails.name || userDetails.displayName || '',
        email: userDetails.email || '',
        photoURL: userDetails.photoURL || '',
        bio: userDetails.bio || '',
        location: userDetails.location || '',
        website: userDetails.website || '',
        joinedAt: userDetails.createdAt || new Date(),
        totalCaptions: userDetails.totalCaptions || 0,
        lastLoginAt: userDetails.lastLoginAt || new Date(),
        preferences: userDetails.preferences || {
          theme: 'system',
          language: 'en',
          notifications: true
        }
      }
    });
  } catch (error) {
    console.error('Error fetching user details:', error);
    res.status(500).json({ 
      success: false, 
      error: 'Failed to fetch user details' 
    });
  }
});

// PUT /api/user-details - Update user profile details
router.put('/', authenticateToken, async (req, res) => {
  try {
    const db = getDatabase();
    if (!db) {
      return res.status(500).json({ 
        success: false, 
        error: 'Database connection not available' 
      });
    }

    const { name, bio, location, website, preferences } = req.body;

    const updateData = {
      updatedAt: new Date()
    };

    if (name !== undefined) updateData.name = name;
    if (bio !== undefined) updateData.bio = bio;
    if (location !== undefined) updateData.location = location;
    if (website !== undefined) updateData.website = website;
    if (preferences !== undefined) updateData.preferences = preferences;

    const usersCollection = db.collection('users');
    const result = await usersCollection.updateOne(
      { uid: req.user.uid },
      { $set: updateData },
      { upsert: true }
    );

    if (result.matchedCount === 0 && result.upsertedCount === 0) {
      return res.status(404).json({ 
        success: false, 
        error: 'User not found' 
      });
    }

    res.json({
      success: true,
      message: 'User details updated successfully'
    });
  } catch (error) {
    console.error('Error updating user details:', error);
    res.status(500).json({ 
      success: false, 
      error: 'Failed to update user details' 
    });
  }
});

// GET /api/user-details/stats - Get user statistics
router.get('/stats', authenticateToken, async (req, res) => {
  try {
    const db = getDatabase();
    if (!db) {
      return res.status(500).json({ 
        success: false, 
        error: 'Database connection not available' 
      });
    }

    const captionsCollection = db.collection('captions');
    const analyticsCollection = db.collection('analytics');

    // Get user's caption count
    const totalCaptions = await captionsCollection.countDocuments({ 
      userId: req.user.uid 
    });

    // Get captions from last 30 days
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
    
    const recentCaptions = await captionsCollection.countDocuments({ 
      userId: req.user.uid,
      createdAt: { $gte: thirtyDaysAgo }
    });

    // Get user's favorite styles
    const styleStats = await captionsCollection.aggregate([
      { $match: { userId: req.user.uid } },
      { $group: { _id: '$style', count: { $sum: 1 } } },
      { $sort: { count: -1 } },
      { $limit: 5 }
    ]).toArray();

    res.json({
      success: true,
      data: {
        totalCaptions,
        recentCaptions,
        favoriteStyles: styleStats.map(style => ({
          name: style._id,
          count: style.count
        })),
        joinedAt: req.user.created_at || new Date()
      }
    });
  } catch (error) {
    console.error('Error fetching user stats:', error);
    res.status(500).json({ 
      success: false, 
      error: 'Failed to fetch user statistics' 
    });
  }
});

module.exports = router;
