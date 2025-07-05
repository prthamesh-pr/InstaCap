const express = require('express');
const router = express.Router();
const multer = require('multer');
const sharp = require('sharp');
const { v4: uuidv4 } = require('uuid');
const OpenAI = require('openai');
const Joi = require('joi');
const { spawn } = require('child_process');
const path = require('path');
const authenticateToken = require('../middleware/auth');
const { CaptionService, UserStatsService } = require('../services/DatabaseServices');

// Initialize services
const captionService = new CaptionService();
const userStatsService = new UserStatsService();

// Initialize OpenAI
let openai;
try {
  if (!process.env.OPENAI_API_KEY) {
    console.warn('⚠️ Missing OpenAI API key. Mock responses will be used.');
  } else {
    openai = new OpenAI({
      apiKey: process.env.OPENAI_API_KEY,
    });
    console.log('✅ OpenAI initialized successfully');
  }
} catch (error) {
  console.error('❌ OpenAI initialization error:', error.message);
  console.warn('⚠️ OpenAI unavailable, using mock responses');
}

// Configure multer for file uploads
const upload = multer({
  storage: multer.memoryStorage(),
  limits: {
    fileSize: parseInt(process.env.MAX_FILE_SIZE) || 5 * 1024 * 1024, // 5MB
  },
  fileFilter: (req, file, cb) => {
    const allowedTypes = process.env.ALLOWED_FILE_TYPES?.split(',') || ['image/jpeg', 'image/png', 'image/webp'];
    if (allowedTypes.includes(file.mimetype)) {
      cb(null, true);
    } else {
      cb(new Error('Invalid file type'), false);
    }
  }
});

// Validation schemas
const imageAnalysisSchema = Joi.object({
  tone: Joi.string().valid('casual', 'professional', 'funny', 'inspirational', 'trendy').default('casual'),
  style: Joi.string().valid('short', 'medium', 'long').default('medium'),
  includeHashtags: Joi.boolean().default(true),
  includeEmojis: Joi.boolean().default(true),
  language: Joi.string().valid('en', 'es', 'fr', 'de', 'it', 'pt').default('en'),
  count: Joi.number().integer().min(1).max(5).default(3)
});

// Mock image caption generation function - returns multiple captions  
const generateMockImageCaptions = (tone, style, includeHashtags, includeEmojis, count = 3) => {
  const baseCaptions = [
    "Just another day in paradise! 🌴",
    "Living my best life, one moment at a time! ✨", 
    "Good vibes and great times! 🌟",
    "Making memories that will last forever! 📸",
    "Caught in the act of enjoying life! 📸",
    "Life is beautiful when you focus on the good stuff! 🌟",
    "Creating memories one photo at a time! 💫",
    "Finding magic in ordinary moments! ✨"
  ];
  
  let results = baseCaptions.slice(0, count).map(caption => {
    let processedCaption = caption;
    
    if (!includeEmojis) {
      processedCaption = processedCaption.replace(/[^\w\s!?.,'"()-]/g, '');
    }
    
    if (includeHashtags) {
      const hashtags = '#photooftheday #instagood #picoftheday #bestoftheday #happy';
      processedCaption += '\n\n' + hashtags;
    }
    
    return processedCaption.trim();
  });

  return results;
};

// Generate caption from image analysis (Public for testing)
router.post('/analyze-image', upload.single('image'), async (req, res) => {
  try {
    const { platform = 'instagram', style = 'casual', userId = 'anonymous', prompt, count = 3 } = req.body;

    // Mock caption generation based on style and platform
    const mockCaptions = {
      casual: {
        instagram: [
          "Living my best life ✨ #goodvibes #blessed",
          "Just another beautiful day 🌅 #sunshine #happy",
          "Chasing dreams and catching sunsets 🌇 #adventure"
        ],
        facebook: [
          "Having an amazing time with friends! What a perfect day.",
          "Grateful for moments like these. Life is beautiful!",
          "Sometimes you just need to stop and appreciate the little things."
        ],
        twitter: [
          "Perfect moment captured ✨ #life",
          "When life gives you good vibes 🌟",
          "Simple pleasures, big smiles 😊"
        ]
      },
      professional: {
        instagram: [
          "Excellence in every detail. #professional #success #growth",
          "Building tomorrow, one step at a time. #leadership #innovation",
          "Committed to delivering outstanding results. #teamwork #excellence"
        ],
        linkedin: [
          "Proud to share this milestone with my amazing team.",
          "Innovation happens when great minds collaborate.",
          "Grateful for the opportunity to work on meaningful projects."
        ]
      },
      funny: {
        instagram: [
          "Me pretending I have my life together 😂 #adulting #help",
          "Current mood: 99% coffee, 1% human ☕ #mood #relatable",
          "Plot twist: I'm actually just winging it 🤷‍♂️ #life #truth"
        ]
      },
      inspirational: {
        instagram: [
          "Every sunrise is a new opportunity to shine ✨ #motivation #inspiration",
          "Believe in yourself, magic happens when you do 🌟 #dreams #believe",
          "Your potential is limitless. Never stop growing 🌱 #growth #mindset"
        ]
      }
    };

    // Get appropriate captions based on style and platform
    const styleSet = mockCaptions[style] || mockCaptions.casual;
    const platformCaptions = styleSet[platform] || styleSet.instagram || styleSet[Object.keys(styleSet)[0]];
    
    // Return multiple captions as requested
    const requestedCount = Math.min(parseInt(count) || 3, platformCaptions.length);
    const selectedCaptions = platformCaptions.slice(0, requestedCount);

    // Create response data with multiple captions
    const captionsData = selectedCaptions.map((caption, index) => {
      const hashtags = caption.match(/#\w+/g) || [];
      const emojis = caption.match(/[\u{1F600}-\u{1F64F}]|[\u{1F300}-\u{1F5FF}]|[\u{1F680}-\u{1F6FF}]|[\u{1F1E0}-\u{1F1FF}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]/gu) || [];

      return {
        caption: caption,
        tags: hashtags.map(tag => tag.substring(1)), // Remove # from tags
        platform: platform,
        style: style,
        metadata: {
          confidence: 0.95 - (index * 0.05), // Slightly decrease confidence for alternatives
          processingTime: Math.floor(Math.random() * 1000) + 500,
          model: 'mock-gpt-4-vision',
          emojis: emojis,
          hashtagCount: hashtags.length
        },
        analysis: prompt || 'Mock image analysis: Beautiful scene with great lighting and composition'
      };
    });

    // Save to database if userId provided (save the first/primary caption)
    if (userId && userId !== 'anonymous' && captionsData.length > 0) {
      try {
        const primaryCaption = captionsData[0];
        const savedCaption = await captionService.createCaption({
          userId: userId,
          caption: primaryCaption.caption,
          tags: primaryCaption.tags,
          platform: platform,
          imageAnalysis: primaryCaption.analysis,
          metadata: primaryCaption.metadata
        });
        primaryCaption.id = savedCaption._id;
        primaryCaption.saved = true;
      } catch (dbError) {
        console.error('Database save error:', dbError);
        captionsData[0].saved = false;
        captionsData[0].saveError = 'Failed to save to database';
      }
    }

    // Return response in the format expected by Flutter app
    res.json({
      success: true,
      message: 'Captions generated successfully',
      captions: selectedCaptions, // Array of caption strings
      data: captionsData, // Detailed data for each caption
      count: selectedCaptions.length
    });

  } catch (error) {
    console.error('Caption generation error:', error);
    res.status(500).json({
      success: false,
      error: 'Caption generation failed',
      message: error.message
    });
  }
});

// Get caption history with pagination (Public for testing)
router.get('/history', async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 20;
    const search = req.query.search || '';
    const category = req.query.category || 'all';
    const userId = req.query.userId || 'anonymous';

    if (userId === 'anonymous') {
      // Return mock history for anonymous users
      const mockHistory = [
        {
          id: 'mock_1',
          caption: 'Living my best life ✨ #goodvibes #blessed',
          style: 'casual',
          platform: 'instagram',
          createdAt: new Date(Date.now() - 86400000).toISOString(), // 1 day ago
          isFavorite: false,
          tags: ['goodvibes', 'blessed']
        },
        {
          id: 'mock_2', 
          caption: 'Excellence in every detail. #professional #success',
          style: 'professional',
          platform: 'linkedin',
          createdAt: new Date(Date.now() - 172800000).toISOString(), // 2 days ago
          isFavorite: true,
          tags: ['professional', 'success']
        }
      ];

      return res.json({
        success: true,
        data: {
          captions: mockHistory,
          total: mockHistory.length,
          page: page,
          totalPages: 1,
          hasMore: false
        }
      });
    }

    // Get captions from database for real users
    const result = await captionService.getUserCaptions(userId, {
      page,
      limit,
      search,
      category,
    });

    res.json({
      success: true,
      data: {
        captions: result.captions || [],
        total: result.total || 0,
        page: page,
        totalPages: Math.ceil((result.total || 0) / limit),
        hasMore: page < Math.ceil((result.total || 0) / limit)
      }
    });

  } catch (error) {
    console.error('History fetch error:', error);
    
    // Fallback to mock data if database fails
    res.json({
      success: true,
      data: {
        captions: [],
        total: 0,
        page: 1,
        totalPages: 0,
        hasMore: false
      },
      message: 'Using fallback data due to database error'
    });
  }
});

// Get trending captions
router.get('/trending', async (req, res) => {
  try {
    const category = req.query.category || 'all';
    const limit = parseInt(req.query.limit) || 20;

    // Try to get from database first
    const trending = await captionService.getTrendingCaptions({ category, limit });
    
    if (trending.length > 0) {
      res.json({
        success: true,
        data: trending.map(caption => ({
          id: caption._id.toString(),
          caption: caption.content,
          tone: caption.metadata.tone,
          style: caption.metadata.style,
          engagementScore: caption.engagement.likes + caption.engagement.shares + caption.engagement.copies,
          createdAt: caption.createdAt.toISOString(),
          category: caption.metadata.tone
        })),
        category,
        count: trending.length
      });
    } else {
      // Fallback to mock data
      const trendingCaptions = [];
      for (let i = 0; i < limit; i++) {
        trendingCaptions.push({
          id: uuidv4(),
          caption: `Trending caption ${i + 1} - ${category}: ${_generateSampleCaption()}`,
          tone: ['casual', 'professional', 'funny'][i % 3],
          style: ['short', 'medium', 'long'][i % 3],
          engagementScore: 95 - i,
          createdAt: new Date(Date.now() - i * 3600000).toISOString(),
          category
        });
      }

      res.json({
        success: true,
        data: trendingCaptions,
        category,
        count: trendingCaptions.length,
        note: 'Using fallback data'
      });
    }
  } catch (error) {
    console.error('Trending captions error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch trending captions'
    });
  }
});

// Toggle favorite caption
router.put('/:captionId/favorite', authenticateToken, async (req, res) => {
  try {
    const { captionId } = req.params;
    const result = await captionService.toggleFavorite(captionId, req.user.uid);
    
    res.json({
      success: true,
      isFavorite: result.isFavorite,
      message: result.isFavorite ? 'Added to favorites' : 'Removed from favorites'
    });
  } catch (error) {
    console.error('Toggle favorite error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to toggle favorite'
    });
  }
});

// Delete caption
router.delete('/:captionId', authenticateToken, async (req, res) => {
  try {
    const { captionId } = req.params;
    await captionService.deleteCaption(captionId, req.user.uid);
    
    res.json({
      success: true,
      message: 'Caption deleted successfully'
    });
  } catch (error) {
    console.error('Delete caption error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to delete caption'
    });
  }
});

// Get caption analytics
router.get('/analytics', authenticateToken, async (req, res) => {
  try {
    const stats = await userStatsService.getUserStats(req.user.uid);
    
    res.json({
      success: true,
      analytics: {
        totalCaptions: stats.captionsGenerated,
        favoriteCaptions: stats.favoriteCaptionsCount,
        monthlyStats: stats.monthlyStats,
        topCategories: stats.topCategories,
        preferences: stats.preferences
      }
    });
  } catch (error) {
    console.error('Analytics error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch analytics'
    });
  }
});

// Helper function to generate sample captions
const _generateSampleCaption = () => {
  const samples = [
    "Living my best life! ✨ #goodvibes",
    "Caught in a perfect moment 📸",
    "Making memories that last forever 💫",
    "Just another day in paradise 🌴",
    "Finding beauty in the simple things",
    "Adventures await around every corner 🗺️",
    "Grateful for moments like these 🙏",
    "Life is beautiful when you focus on the good stuff",
    "Creating my own sunshine ☀️",
    "Every picture tells a story 📖"
  ];
  return samples[Math.floor(Math.random() * samples.length)];
};

module.exports = router;
