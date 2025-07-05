const { ObjectId } = require('mongodb');

class DataModels {
  // User profile model
  static createUserProfile(userData) {
    return {
      _id: new ObjectId(),
      uid: userData.uid, // Firebase UID
      email: userData.email,
      displayName: userData.displayName || 'User',
      photoURL: userData.photoURL || null,
      bio: userData.bio || '',
      preferences: {
        theme: userData.preferences?.theme || 'system',
        language: userData.preferences?.language || 'en',
        defaultTone: userData.preferences?.defaultTone || 'casual',
        notifications: {
          newFeatures: userData.preferences?.notifications?.newFeatures ?? true,
          tips: userData.preferences?.notifications?.tips ?? true,
          marketing: userData.preferences?.notifications?.marketing ?? false,
        },
      },
      subscription: {
        plan: 'free',
        expiresAt: null,
        features: ['basic_captions', 'history_access'],
      },
      createdAt: new Date(),
      updatedAt: new Date(),
      lastActiveAt: new Date(),
    };
  }

  // Caption model
  static createCaption(captionData) {
    return {
      _id: new ObjectId(),
      userId: captionData.userId,
      content: captionData.content,
      originalPrompt: captionData.originalPrompt || '',
      metadata: {
        tone: captionData.tone || 'casual',
        style: captionData.style || 'medium',
        language: captionData.language || 'en',
        includeHashtags: captionData.includeHashtags ?? true,
        includeEmojis: captionData.includeEmojis ?? true,
        imageType: captionData.imageType || null,
        processingTime: captionData.processingTime || 0,
        generationMethod: captionData.generationMethod || 'ai',
      },
      engagement: {
        likes: 0,
        shares: 0,
        copies: 0,
        views: 0,
      },
      flags: {
        isFavorite: false,
        isPublic: false,
        isReported: false,
      },
      tags: captionData.tags || [],
      createdAt: new Date(),
      updatedAt: new Date(),
    };
  }

  // Analytics event model
  static createAnalyticsEvent(eventData) {
    return {
      _id: new ObjectId(),
      userId: eventData.userId,
      eventType: eventData.eventType, // 'caption_generated', 'caption_shared', etc.
      eventData: eventData.data || {},
      sessionId: eventData.sessionId,
      userAgent: eventData.userAgent || '',
      ipAddress: eventData.ipAddress || '',
      timestamp: new Date(),
    };
  }

  // User statistics model
  static createUserStats(userId) {
    return {
      _id: new ObjectId(),
      userId: userId,
      captionsGenerated: 0,
      favoriteCaptionsCount: 0,
      totalApiCalls: 0,
      streakDays: 0,
      lastActiveDate: new Date(),
      monthlyStats: {
        captionsThisMonth: 0,
        apiCallsThisMonth: 0,
        favoriteActionsThisMonth: 0,
        month: new Date().getMonth() + 1,
        year: new Date().getFullYear(),
      },
      topCategories: {},
      preferences: {
        mostUsedTone: 'casual',
        mostUsedStyle: 'medium',
        averageLength: 0,
      },
      createdAt: new Date(),
      updatedAt: new Date(),
    };
  }

  // Validation schemas
  static validateUserProfile(data) {
    const errors = [];
    
    if (!data.uid) errors.push('UID is required');
    if (!data.email) errors.push('Email is required');
    if (data.displayName && data.displayName.length > 50) {
      errors.push('Display name must be less than 50 characters');
    }
    if (data.bio && data.bio.length > 200) {
      errors.push('Bio must be less than 200 characters');
    }
    
    return {
      isValid: errors.length === 0,
      errors,
    };
  }

  static validateCaption(data) {
    const errors = [];
    
    if (!data.userId) errors.push('User ID is required');
    if (!data.content) errors.push('Caption content is required');
    if (data.content && data.content.length > 2000) {
      errors.push('Caption content must be less than 2000 characters');
    }
    
    return {
      isValid: errors.length === 0,
      errors,
    };
  }
}

module.exports = DataModels;
