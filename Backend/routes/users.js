const express = require('express');
const router = express.Router();
const { getUserByUid } = require('../config/firebase');
const { admin } = require('../config/firebase');
const Joi = require('joi');
const { UserService, UserStatsService } = require('../services/DatabaseServices');

// Initialize services
const userService = new UserService();
const userStatsService = new UserStatsService();

// Validation schemas
const updateProfileSchema = Joi.object({
  displayName: Joi.string().min(2).max(50),
  photoURL: Joi.string().uri().allow(''),
  bio: Joi.string().max(200).allow(''),
  preferences: Joi.object({
    theme: Joi.string().valid('light', 'dark', 'system'),
    language: Joi.string().valid('en', 'es', 'fr', 'de', 'it', 'pt'),
    defaultTone: Joi.string().valid('casual', 'professional', 'funny', 'inspirational'),
    notifications: Joi.object({
      newFeatures: Joi.boolean(),
      tips: Joi.boolean(),
      marketing: Joi.boolean(),
    }),
  }),
});

// Get current user profile
router.get('/profile', async (req, res) => {
  try {
    // Get user from Firebase Auth
    const firebaseUser = await getUserByUid(req.user.uid);
    
    // Get or create user profile in MongoDB
    let dbUser = await userService.getUserByUid(req.user.uid);
    if (!dbUser) {
      dbUser = await userService.createOrUpdateUser({
        uid: req.user.uid,
        email: firebaseUser.email,
        displayName: firebaseUser.displayName,
        photoURL: firebaseUser.photoURL,
      });
    }
    
    // Get user statistics
    const stats = await userStatsService.getUserStats(req.user.uid);
    
    const profileData = {
      uid: dbUser.uid,
      email: dbUser.email,
      displayName: dbUser.displayName || 'User',
      photoURL: dbUser.photoURL || null,
      emailVerified: firebaseUser.emailVerified,
      bio: dbUser.bio || '',
      createdAt: firebaseUser.metadata.creationTime,
      lastSignIn: firebaseUser.metadata.lastSignInTime,
      preferences: dbUser.preferences,
      subscription: dbUser.subscription,
      stats: {
        captionsGenerated: stats.captionsGenerated,
        favoriteCaptionsCount: stats.favoriteCaptionsCount,
        streakDays: stats.streakDays,
        monthlyStats: stats.monthlyStats,
      }
    };
    
    res.json({
      success: true,
      user: profileData
    });
  } catch (error) {
    console.error('Profile fetch error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch user profile'
    });
  }
});

// Update user profile
router.put('/profile', async (req, res) => {
  try {
    // Validate input
    const { error, value } = updateProfileSchema.validate(req.body);
    if (error) {
      return res.status(400).json({
        success: false,
        error: 'Validation failed',
        details: error.details
      });
    }

    const { displayName, photoURL, bio, preferences } = value;
    
    // Update Firebase Auth profile
    const updateData = {};
    if (displayName) updateData.displayName = displayName;
    if (photoURL !== undefined) updateData.photoURL = photoURL;

    let updatedUser = null;
    if (Object.keys(updateData).length > 0) {
      updatedUser = await admin.auth().updateUser(req.user.uid, updateData);
    } else {
      updatedUser = await getUserByUid(req.user.uid);
    }

    // In a real app, you'd save bio and preferences to your database
    // For now, we'll just return success with the updated data
    
    res.json({
      success: true,
      message: 'Profile updated successfully',
      user: {
        uid: updatedUser.uid,
        email: updatedUser.email,
        displayName: updatedUser.displayName,
        photoURL: updatedUser.photoURL,
        bio: bio || 'Caption creator and social media enthusiast',
        preferences: preferences || {
          theme: 'system',
          language: 'en',
          defaultTone: 'casual',
          notifications: {
            newFeatures: true,
            tips: true,
            marketing: false,
          },
        },
      }
    });
  } catch (error) {
    console.error('Profile update error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to update profile'
    });
  }
});

// Get user statistics
router.get('/stats', async (req, res) => {
  try {
    // In a real app, you'd fetch this from a database
    // For now, generate realistic mock data
    const now = new Date();
    const thirtyDaysAgo = new Date(now.getTime() - (30 * 24 * 60 * 60 * 1000));
    
    const stats = {
      captionsGenerated: Math.floor(Math.random() * 100) + 50,
      favoriteCaptionsCount: Math.floor(Math.random() * 30) + 10,
      totalApiCalls: Math.floor(Math.random() * 200) + 100,
      lastActiveDate: new Date().toISOString(),
      accountCreated: thirtyDaysAgo.toISOString(),
      streakDays: Math.floor(Math.random() * 15) + 1,
      monthlyUsage: {
        captionsThisMonth: Math.floor(Math.random() * 50) + 20,
        apiCallsThisMonth: Math.floor(Math.random() * 100) + 50,
        favoriteActionsThisMonth: Math.floor(Math.random() * 20) + 5,
      },
      topCategories: [
        { name: 'casual', count: Math.floor(Math.random() * 30) + 10 },
        { name: 'professional', count: Math.floor(Math.random() * 20) + 5 },
        { name: 'funny', count: Math.floor(Math.random() * 15) + 3 },
      ],
    };

    res.json({
      success: true,
      stats
    });
  } catch (error) {
    console.error('Stats fetch error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch user statistics'
    });
  }
});

// Delete user account
router.delete('/account', async (req, res) => {
  try {
    const { confirmPassword } = req.body;
    
    if (!confirmPassword) {
      return res.status(400).json({
        success: false,
        error: 'Password confirmation required'
      });
    }

    // In a real app, you'd verify the password before deletion
    // For now, we'll just simulate the deletion
    
    // Delete user from Firebase Auth
    await admin.auth().deleteUser(req.user.uid);
    
    // In a real app, you'd also:
    // - Delete user data from database
    // - Cancel subscriptions
    // - Clean up associated files
    
    res.json({
      success: true,
      message: 'Account deleted successfully'
    });
  } catch (error) {
    console.error('Account deletion error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to delete account'
    });
  }
});

// Change password
router.put('/password', async (req, res) => {
  try {
    const { currentPassword, newPassword } = req.body;
    
    if (!currentPassword || !newPassword) {
      return res.status(400).json({
        success: false,
        error: 'Current password and new password are required'
      });
    }

    if (newPassword.length < 6) {
      return res.status(400).json({
        success: false,
        error: 'New password must be at least 6 characters long'
      });
    }

    // In a real app, you'd verify the current password first
    // For Firebase, password changes are typically handled client-side
    // This endpoint would be used with custom auth or for additional validation
    
    // Update password in Firebase
    await admin.auth().updateUser(req.user.uid, {
      password: newPassword
    });
    
    res.json({
      success: true,
      message: 'Password updated successfully'
    });
  } catch (error) {
    console.error('Password update error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to update password'
    });
  }
});

// Export user data (GDPR compliance)
router.get('/export', async (req, res) => {
  try {
    const user = await getUserByUid(req.user.uid);
    
    // In a real app, you'd gather all user data from various collections
    const exportData = {
      profile: {
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        createdAt: user.metadata.creationTime,
        lastSignIn: user.metadata.lastSignInTime,
      },
      captions: [], // Would be populated from database
      preferences: {}, // Would be populated from database
      statistics: {}, // Would be populated from database
      exportedAt: new Date().toISOString(),
    };
    
    res.json({
      success: true,
      data: exportData
    });
  } catch (error) {
    console.error('Data export error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to export user data'
    });
  }
});

module.exports = router;
