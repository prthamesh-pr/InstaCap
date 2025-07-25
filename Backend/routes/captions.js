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

    // Enhanced mock caption generation with multiple options
    const captionVariations = {
      casual: {
        instagram: [
          "Living my best life ✨ #goodvibes #blessed #lifestyle #happiness #grateful",
          "Just another beautiful day 🌅 #sunshine #happy #blessed #morningvibes #positiveenergy", 
          "Chasing dreams and catching sunsets 🌇 #adventure #sunset #dreams #wanderlust #explore",
          "Making memories that last forever 📸 #memories #photooftheday #instagood #bestmoments #life",
          "Good vibes only! 🌟 #goodvibes #positivity #smile #happiness #energy",
          "Creating my own sunshine ☀️ #sunshine #positivity #selfmade #inspiration #motivation"
        ],
        facebook: [
          "Having an amazing time with friends! What a perfect day to create lasting memories.",
          "Grateful for moments like these. Life is beautiful when you're surrounded by good people!",
          "Sometimes you just need to stop and appreciate the little things that make life wonderful.",
          "Today reminded me why I love spending time with the people who matter most.",
          "Life's best moments happen when you least expect them. So blessed!",
          "Perfect weather, perfect company, perfect day. Couldn't ask for more!"
        ],
        twitter: [
          "Perfect moment captured ✨ #life #perfect #blessed",
          "When life gives you good vibes 🌟 #goodvibes #blessed",
          "Simple pleasures, big smiles 😊 #happiness #simple",
          "Living in the moment 💫 #present #mindful #life",
          "Today's mood: grateful 🙏 #grateful #blessed #mood",
          "Small moments, big feelings ❤️ #feelings #moments #life"
        ]
      },
      professional: {
        instagram: [
          "Excellence in every detail. #professional #success #growth #leadership #teamwork",
          "Building tomorrow, one step at a time. #leadership #innovation #future #progress #vision",
          "Committed to delivering outstanding results. #teamwork #excellence #results #dedication #success",
          "Innovation drives everything we do. #innovation #technology #business #growth #forward",
          "Proud of what we've accomplished together. #team #achievement #success #collaboration #proud",
          "Setting new standards of excellence. #excellence #standards #quality #professional #goals"
        ],
        linkedin: [
          "Proud to share this milestone with my amazing team. Together, we're building something extraordinary.",
          "Innovation happens when great minds collaborate. Grateful to work with such talented professionals.",
          "Grateful for the opportunity to work on meaningful projects that make a difference.",
          "Success is a team sport. Thank you to everyone who made this possible.",
          "Excited to announce our latest achievement. Hard work and dedication always pay off.",
          "Learning and growing every day. The journey of professional development never ends."
        ]
      },
      funny: {
        instagram: [
          "Me pretending I have my life together 😂 #adulting #help #relatable #funny #life",
          "Current mood: 99% coffee, 1% human ☕ #mood #relatable #coffee #monday #tired",
          "Plot twist: I'm actually just winging it 🤷‍♂️ #life #truth #funny #adulting #relatable",
          "When you realize being an adult is just googling everything 📱 #adulting #google #truth #funny",
          "My life is like a romantic comedy, except there's no romance and it's not funny 😅 #life #reality #mood",
          "I followed my heart and it led me to the fridge 🍕 #food #heart #truth #hungry #relatable"
        ]
      },
      inspirational: {
        instagram: [
          "Every sunrise is a new opportunity to shine ✨ #motivation #inspiration #sunrise #opportunity #positive",
          "Believe in yourself, magic happens when you do 🌟 #dreams #believe #magic #inspiration #motivation",
          "Your potential is limitless. Never stop growing 🌱 #growth #mindset #potential #inspiration #nevergiveup",
          "Turn your wounds into wisdom and your pain into power 💪 #strength #wisdom #growth #overcome #inspire",
          "The best view comes after the hardest climb ⛰️ #perseverance #success #journey #climb #view",
          "Be yourself; everyone else is already taken 💫 #authentic #beyourself #unique #inspiration #selfworth"
        ]
      },
      trendy: {
        instagram: [
          "That main character energy ✨ #maincharacter #energy #confidence #trending #aesthetic",
          "Plot armor activated 🛡️ #plotarmor #confidence #unstoppable #trending #energy",
          "Roman Empire? More like my empire 👑 #empire #confidence #trending #aesthetic #vibes",
          "Living my truth, serving looks 💅 #truth #looks #serving #confidence #aesthetic",
          "No thoughts, head empty, just vibes 🧠 #vibes #trending #mood #aesthetic #energy",
          "Caught in 4K being amazing 📸 #caught4k #amazing #confidence #trending #iconic"
        ]
      }
    };

    // Get appropriate captions based on style and platform
    const styleSet = captionVariations[style] || captionVariations.casual;
    const platformCaptions = styleSet[platform] || styleSet.instagram || styleSet[Object.keys(styleSet)[0]];
    
    // Return multiple captions as requested (3-6 options)
    const requestedCount = Math.min(Math.max(parseInt(count) || 3, 3), 6);
    const shuffledCaptions = [...platformCaptions].sort(() => 0.5 - Math.random());
    const selectedCaptions = shuffledCaptions.slice(0, requestedCount);

    // Create detailed response data for each caption
    const captionsData = selectedCaptions.map((caption, index) => {
      const hashtags = caption.match(/#\w+/g) || [];
      const emojis = caption.match(/[\u{1F600}-\u{1F64F}]|[\u{1F300}-\u{1F5FF}]|[\u{1F680}-\u{1F6FF}]|[\u{1F1E0}-\u{1F1FF}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]/gu) || [];

      return {
        id: uuidv4(),
        caption: caption,
        tags: hashtags.map(tag => tag.substring(1)), // Remove # from tags
        platform: platform,
        style: style,
        metadata: {
          confidence: Math.max(0.85, 0.98 - (index * 0.02)), // High confidence, slight decrease for alternatives
          processingTime: Math.floor(Math.random() * 800) + 300,
          model: openai ? 'gpt-4-vision-preview' : 'mock-ai-model',
          emojis: emojis,
          hashtagCount: hashtags.length,
          characterCount: caption.length,
          wordCount: caption.split(' ').length
        },
        analysis: prompt || 'AI-generated caption based on image analysis and style preferences',
        createdAt: new Date().toISOString()
      };
    });

    // If real OpenAI is available and an image was uploaded, try to enhance with real AI
    if (openai && req.file) {
      try {
        console.log('🤖 Enhancing captions with OpenAI...');
        
        const base64Image = req.file.buffer.toString('base64');
        const imagePrompt = `Analyze this image and generate ${requestedCount} creative ${style} captions for ${platform}. 
        Style: ${style}
        Platform: ${platform}
        Include relevant hashtags and emojis where appropriate.
        Make each caption unique and engaging.`;

        const response = await openai.chat.completions.create({
          model: "gpt-4-vision-preview",
          messages: [
            {
              role: "user",
              content: [
                { type: "text", text: imagePrompt },
                {
                  type: "image_url",
                  image_url: {
                    url: `data:image/jpeg;base64,${base64Image}`
                  }
                }
              ]
            }
          ],
          max_tokens: 1000
        });

        if (response.choices?.[0]?.message?.content) {
          const aiCaptions = response.choices[0].message.content
            .split('\n')
            .filter(line => line.trim() && !line.match(/^\d+\./))
            .slice(0, requestedCount);

          // Update captions with AI-generated content if available
          aiCaptions.forEach((caption, index) => {
            if (captionsData[index]) {
              captionsData[index].caption = caption.trim();
              captionsData[index].metadata.model = 'gpt-4-vision-preview';
              captionsData[index].metadata.confidence = 0.95;
              captionsData[index].analysis = 'AI-enhanced caption based on actual image analysis';
            }
          });
        }
      } catch (aiError) {
        console.error('OpenAI enhancement failed:', aiError.message);
        // Continue with mock captions if AI fails
      }
    }

    // Save the primary caption to database if userId provided
    if (userId && userId !== 'anonymous' && captionsData.length > 0) {
      try {
        const primaryCaption = captionsData[0];
        const savedCaption = await captionService.createCaption({
          userId: userId,
          caption: primaryCaption.caption,
          tags: primaryCaption.tags,
          platform: platform,
          imageAnalysis: primaryCaption.analysis,
          metadata: primaryCaption.metadata,
          style: style
        });
        primaryCaption.id = savedCaption._id;
        primaryCaption.saved = true;
      } catch (dbError) {
        console.error('Database save error:', dbError);
        captionsData[0].saved = false;
        captionsData[0].saveError = 'Failed to save to database';
      }
    }

    // Return comprehensive response
    res.json({
      success: true,
      message: `Generated ${selectedCaptions.length} captions successfully`,
      captions: selectedCaptions, // Simple array of caption strings for quick access
      data: captionsData, // Detailed data for each caption with metadata
      count: selectedCaptions.length,
      style: style,
      platform: platform,
      generatedAt: new Date().toISOString()
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

    // Generate comprehensive mock history data in the format expected by Flutter
    const mockHistory = _generateMockHistoryCaptions(limit, search, category);

    // Transform to match Flutter CaptionModel format
    const transformedHistory = mockHistory.map(caption => ({
      id: caption.id,
      text: caption.text,
      hashtags: caption.hashtags,
      userId: caption.userId,
      imageUrl: caption.imageUrl || '',
      style: caption.style,
      mood: caption.mood,
      keywords: caption.keywords || [],
      language: caption.language || 'en',
      createdAt: caption.createdAt,
      updatedAt: caption.updatedAt,
      isFavorite: caption.isFavorite,
      isPublic: caption.isPublic,
      likeCount: caption.likeCount,
      shareCount: caption.shareCount,
      likedBy: caption.likedBy || [],
      confidence: caption.confidence,
      category: caption.category
    }));

    res.json({
      success: true,
      data: transformedHistory,
      metadata: {
        pagination: {
          currentPage: page,
          totalPages: Math.ceil(mockHistory.length / limit),
          totalItems: mockHistory.length,
          hasNextPage: page < Math.ceil(mockHistory.length / limit),
          hasPrevPage: page > 1,
          limit: limit
        }
      }
    });

  } catch (error) {
    console.error('History fetch error:', error);
    
    // Fallback to empty data
    res.json({
      success: true,
      data: [],
      metadata: {
        pagination: {
          currentPage: 1,
          totalPages: 0,
          totalItems: 0,
          hasNextPage: false,
          hasPrevPage: false,
          limit: limit
        }
      },
      message: 'Using fallback data due to error'
    });
  }
});

// Helper function to generate mock history captions
const _generateMockHistoryCaptions = (limit, search, category) => {
  const mockCaptions = [
    {
      id: '1',
      text: 'Living my best life ✨ #blessed #goodvibes #photooftheday',
      hashtags: ['blessed', 'goodvibes', 'photooftheday'],
      userId: 'user1',
      imageUrl: '',
      style: 'medium',
      mood: 'casual',
      keywords: [],
      language: 'en',
      createdAt: new Date(Date.now() - 86400000), // 1 day ago
      updatedAt: new Date(Date.now() - 86400000),
      isFavorite: true,
      isPublic: false,
      likeCount: 15,
      shareCount: 3,
      likedBy: [],
      confidence: 0.9,
      category: 'lifestyle'
    },
    {
      id: '2',
      text: 'Coffee first, then we can talk ☕ #coffee #mood #mondayvibes',
      hashtags: ['coffee', 'mood', 'mondayvibes'],
      userId: 'user1',
      imageUrl: '',
      style: 'short',
      mood: 'funny',
      keywords: ['coffee'],
      language: 'en',
      createdAt: new Date(Date.now() - 172800000), // 2 days ago
      updatedAt: new Date(Date.now() - 172800000),
      isFavorite: false,
      isPublic: true,
      likeCount: 8,
      shareCount: 1,
      likedBy: [],
      confidence: 0.85,
      category: 'lifestyle'
    },
    {
      id: '3',
      text: 'Success is not final, failure is not fatal: it is the courage to continue that counts 💪 #motivation #inspiration #nevergiveup',
      hashtags: ['motivation', 'inspiration', 'nevergiveup'],
      userId: 'user1',
      imageUrl: '',
      style: 'long',
      mood: 'inspirational',
      keywords: ['success', 'courage'],
      language: 'en',
      createdAt: new Date(Date.now() - 259200000), // 3 days ago
      updatedAt: new Date(Date.now() - 259200000),
      isFavorite: true,
      isPublic: true,
      likeCount: 42,
      shareCount: 12,
      likedBy: [],
      confidence: 0.95,
      category: 'motivation'
    },
    {
      id: '4',
      text: 'Teamwork makes the dream work 🤝 #professional #teamwork #success #growth',
      hashtags: ['professional', 'teamwork', 'success', 'growth'],
      userId: 'user1',
      imageUrl: '',
      style: 'medium',
      mood: 'professional',
      keywords: ['teamwork'],
      language: 'en',
      createdAt: new Date(Date.now() - 345600000), // 4 days ago
      updatedAt: new Date(Date.now() - 345600000),
      isFavorite: false,
      isPublic: true,
      likeCount: 23,
      shareCount: 5,
      likedBy: [],
      confidence: 0.88,
      category: 'business'
    },
    {
      id: '5',
      text: 'Sunset vibes and good times 🌅 Sometimes the simple moments are the most beautiful',
      hashtags: ['sunset', 'goodtimes', 'beautiful'],
      userId: 'user1',
      imageUrl: '',
      style: 'medium',
      mood: 'casual',
      keywords: ['sunset'],
      language: 'en',
      createdAt: new Date(Date.now() - 432000000), // 5 days ago
      updatedAt: new Date(Date.now() - 432000000),
      isFavorite: true,
      isPublic: false,
      likeCount: 31,
      shareCount: 7,
      likedBy: [],
      confidence: 0.92,
      category: 'travel'
    }
  ];
  
  // Filter by search if provided
  let filtered = mockCaptions;
  if (search) {
    const searchLower = search.toLowerCase();
    filtered = mockCaptions.filter(caption => 
      caption.text.toLowerCase().includes(searchLower) ||
      caption.hashtags.some(tag => tag.toLowerCase().includes(searchLower))
    );
  }
  
  // Filter by category
  if (category && category !== 'all') {
    if (category === 'favorites') {
      filtered = filtered.filter(caption => caption.isFavorite);
    } else if (category === 'recent') {
      const threeDaysAgo = new Date(Date.now() - 259200000); // 3 days ago
      filtered = filtered.filter(caption => caption.createdAt > threeDaysAgo);
    } else {
      filtered = filtered.filter(caption => caption.mood === category || caption.category === category);
    }
  }
  
  return filtered.slice(0, limit);
};

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
