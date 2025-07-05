#!/usr/bin/env python3
"""
Python-based image analysis service for InstaCap
Provides intelligent image analysis when OpenAI Vision API is unavailable
"""

import sys
import json
import base64
import io
import argparse
from PIL import Image, ImageStat
import colorsys
import random

def analyze_image_content(image_data, tone='casual', style='medium', include_hashtags=True, include_emojis=True):
    """
    Analyze image and generate caption based on visual elements
    """
    try:
        # Decode base64 image
        image_bytes = base64.b64decode(image_data)
        image = Image.open(io.BytesIO(image_bytes))
        
        # Convert to RGB if needed
        if image.mode != 'RGB':
            image = image.convert('RGB')
        
        # Analyze image properties
        analysis = analyze_image_properties(image)
        
        # Generate caption based on analysis
        caption = generate_caption_from_analysis(analysis, tone, style, include_hashtags, include_emojis)
        
        return {
            'success': True,
            'caption': caption,
            'analysis': analysis,
            'source': 'python_analyzer'
        }
        
    except Exception as e:
        return {
            'success': False,
            'error': str(e),
            'source': 'python_analyzer'
        }

def analyze_image_properties(image):
    """
    Extract visual properties from the image
    """
    # Get image dimensions
    width, height = image.size
    aspect_ratio = width / height
    
    # Analyze colors
    colors = analyze_colors(image)
    
    # Analyze brightness
    brightness = analyze_brightness(image)
    
    # Determine image type based on aspect ratio and colors
    image_type = determine_image_type(aspect_ratio, colors, brightness)
    
    return {
        'dimensions': {'width': width, 'height': height},
        'aspect_ratio': aspect_ratio,
        'colors': colors,
        'brightness': brightness,
        'type': image_type
    }

def analyze_colors(image):
    """
    Analyze the dominant colors and mood of the image
    """
    # Resize for faster processing
    small_image = image.resize((50, 50))
    
    # Get color statistics
    stat = ImageStat.Stat(small_image)
    
    # Average RGB values
    avg_r, avg_g, avg_b = stat.mean
    
    # Convert to HSV for better color analysis
    h, s, v = colorsys.rgb_to_hsv(avg_r/255, avg_g/255, avg_b/255)
    
    # Determine dominant color mood
    if s < 0.2:  # Low saturation
        color_mood = 'monochrome' if v < 0.3 else 'neutral'
    elif h < 0.1 or h > 0.9:  # Red range
        color_mood = 'warm'
    elif 0.1 <= h < 0.3:  # Yellow-green range
        color_mood = 'energetic'
    elif 0.3 <= h < 0.7:  # Blue-green range
        color_mood = 'cool'
    else:  # Purple-pink range
        color_mood = 'creative'
    
    return {
        'dominant_rgb': [int(avg_r), int(avg_g), int(avg_b)],
        'saturation': s,
        'value': v,
        'mood': color_mood
    }

def analyze_brightness(image):
    """
    Analyze overall brightness and contrast
    """
    # Convert to grayscale
    gray = image.convert('L')
    stat = ImageStat.Stat(gray)
    
    brightness = stat.mean[0] / 255  # Normalize to 0-1
    
    if brightness < 0.3:
        brightness_level = 'dark'
    elif brightness > 0.7:
        brightness_level = 'bright'
    else:
        brightness_level = 'balanced'
    
    return {
        'level': brightness_level,
        'value': brightness
    }

def determine_image_type(aspect_ratio, colors, brightness):
    """
    Determine the likely type of image based on visual properties
    """
    if aspect_ratio > 1.5:
        base_type = 'landscape'
    elif aspect_ratio < 0.8:
        base_type = 'portrait'
    else:
        base_type = 'square'
    
    # Add mood modifiers
    modifiers = []
    
    if colors['mood'] == 'warm':
        modifiers.append('warm')
    elif colors['mood'] == 'cool':
        modifiers.append('cool')
    elif colors['mood'] == 'energetic':
        modifiers.append('vibrant')
    elif colors['mood'] == 'monochrome':
        modifiers.append('artistic')
    
    if brightness['level'] == 'dark':
        modifiers.append('moody')
    elif brightness['level'] == 'bright':
        modifiers.append('bright')
    
    return {
        'base': base_type,
        'modifiers': modifiers
    }

def generate_caption_from_analysis(analysis, tone, style, include_hashtags, include_emojis):
    """
    Generate a caption based on image analysis
    """
    # Caption templates based on image properties
    templates = {
        'landscape': {
            'casual': {
                'short': ["Views for days! {emoji}", "Nature calling {emoji}", "Wide open spaces {emoji}"],
                'medium': ["Sometimes you need to step back and take in the bigger picture. {emoji} What's your favorite view?", "There's something about wide open spaces that just speaks to the soul. {emoji} Where's your happy place?"],
                'long': ["Every landscape tells a story, and this one is speaking to me in all the right ways. {emoji} There's magic in those wide open spaces that reminds us how beautiful our world really is. Sometimes we get so caught up in the daily grind that we forget to look up and appreciate the view."]
            },
            'professional': {
                'short': ["Perspective matters. {emoji}", "Strategic viewpoint. {emoji}", "Expanding horizons. {emoji}"],
                'medium': ["Success often comes from taking a step back and seeing the bigger picture. {emoji} What new perspectives are you exploring?", "In business, as in life, it's important to maintain a broad perspective. {emoji} How are you expanding your horizons?"],
                'long': ["Leadership requires the ability to see beyond the immediate horizon and envision possibilities that others might miss. {emoji} Every great achievement starts with someone who dared to look further, think bigger, and pursue a vision that seemed impossible to others."]
            }
        },
        'portrait': {
            'casual': {
                'short': ["Just me being me {emoji}", "Feeling myself today {emoji}", "Portrait mode activated {emoji}"],
                'medium': ["Sometimes the best conversations happen with yourself. {emoji} What's one thing you're proud of today?", "Taking a moment to appreciate how far I've come. {emoji} Self-love isn't selfish, it's necessary."],
                'long': ["There's something powerful about taking a moment to really see yourself - not just the reflection in the mirror, but the person you've become through all the ups and downs. {emoji} Every line, every smile, every expression tells the story of your journey."]
            }
        },
        'square': {
            'casual': {
                'short': ["Perfect frame {emoji}", "Square vibes {emoji}", "Centered and ready {emoji}"],
                'medium': ["Sometimes life fits perfectly in a square frame. {emoji} What's your perfect moment looking like today?", "Finding balance in the chaos, one square at a time. {emoji} How do you stay centered?"],
                'long': ["There's something satisfying about a perfectly balanced composition - much like life, it's all about finding that sweet spot where everything just feels right. {emoji} Whether it's work-life balance or just the perfect lighting for a photo, harmony is everything."]
            }
        }
    }
    
    # Mood-based adjustments
    mood_emojis = {
        'warm': '🔥 🌅 ☀️ 🧡',
        'cool': '💙 🌊 ❄️ 🌙',
        'energetic': '⚡ 🌈 ✨ 💫',
        'creative': '🎨 💜 🌸 ✨',
        'monochrome': '🖤 🤍 📸 ⚫',
        'neutral': '🌟 ✨ 💛 🌼'
    }
    
    brightness_emojis = {
        'bright': '☀️ ✨ 🌟 💡',
        'dark': '🌙 🖤 🌃 ✨',
        'balanced': '🌤️ ⚖️ 🌈 💫'
    }
    
    # Select appropriate template
    image_type = analysis['type']['base']
    color_mood = analysis['colors']['mood']
    
    if image_type in templates and tone in templates[image_type]:
        template_options = templates[image_type][tone][style]
        caption_template = random.choice(template_options)
    else:
        # Fallback templates
        fallback_templates = {
            'short': ["Picture perfect moment {emoji}", "Loving this vibe {emoji}", "Just what I needed {emoji}"],
            'medium': ["Sometimes a picture really is worth a thousand words. {emoji} What story does this tell you?", "Capturing moments that matter, one frame at a time. {emoji} What's your favorite memory recently?"],
            'long': ["Every photo tells a story, and this one is all about embracing the moment and finding beauty in the everyday. {emoji} Life moves fast, but memories like these remind us to slow down and appreciate the journey we're on."]
        }
        caption_template = random.choice(fallback_templates[style])
    
    # Add appropriate emojis if requested
    if include_emojis:
        mood_emoji_set = mood_emojis.get(color_mood, '✨ 🌟 💫 ⭐')
        brightness_emoji_set = brightness_emojis.get(analysis['brightness']['level'], '✨ 🌟')
        
        # Pick random emojis
        all_emojis = mood_emoji_set.split() + brightness_emoji_set.split()
        selected_emoji = random.choice(all_emojis)
        
        caption = caption_template.format(emoji=selected_emoji)
    else:
        caption = caption_template.replace(' {emoji}', '').replace('{emoji}', '')
    
    # Add hashtags if requested
    if include_hashtags:
        base_hashtags = ['#photooftheday', '#instagood', '#picoftheday']
        
        # Add mood-specific hashtags
        mood_hashtags = {
            'warm': ['#sunset', '#golden', '#warmvibes', '#cozy'],
            'cool': ['#cool', '#calm', '#peaceful', '#blue'],
            'energetic': ['#vibrant', '#energy', '#colorful', '#alive'],
            'creative': ['#artistic', '#creative', '#unique', '#inspiration'],
            'monochrome': ['#blackandwhite', '#minimalist', '#classic', '#timeless'],
            'neutral': ['#natural', '#simple', '#clean', '#fresh']
        }
        
        type_hashtags = {
            'landscape': ['#landscape', '#nature', '#view', '#scenery'],
            'portrait': ['#portrait', '#selfie', '#mood', '#style'],
            'square': ['#square', '#composition', '#balance', '#perfect']
        }
        
        hashtags = base_hashtags.copy()
        hashtags.extend(mood_hashtags.get(color_mood, []))
        hashtags.extend(type_hashtags.get(image_type, []))
        
        # Limit to 10 hashtags
        hashtags = hashtags[:10]
        caption += '\n\n' + ' '.join(hashtags)
    
    return caption

def main():
    """
    Command line interface for the image analyzer
    """
    parser = argparse.ArgumentParser(description='Analyze image and generate caption')
    parser.add_argument('--image', required=True, help='Base64 encoded image data')
    parser.add_argument('--tone', default='casual', choices=['casual', 'professional', 'funny', 'inspirational', 'trendy'])
    parser.add_argument('--style', default='medium', choices=['short', 'medium', 'long'])
    parser.add_argument('--hashtags', action='store_true', default=True, help='Include hashtags')
    parser.add_argument('--emojis', action='store_true', default=True, help='Include emojis')
    
    args = parser.parse_args()
    
    result = analyze_image_content(
        args.image,
        args.tone,
        args.style,
        args.hashtags,
        args.emojis
    )
    
    print(json.dumps(result, indent=2))

if __name__ == '__main__':
    main()
