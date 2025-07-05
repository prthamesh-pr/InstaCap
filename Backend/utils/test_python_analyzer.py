#!/usr/bin/env python3
"""
Test script for Python image analyzer
"""

import sys
import base64
import json
from python_image_analyzer import analyze_image_content

# Create a simple test image (1x1 pixel red image)
def create_test_image():
    """Create a simple test image as base64"""
    # 1x1 red pixel PNG in base64
    red_pixel_png = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg=="
    return red_pixel_png

def test_analyzer():
    """Test the image analyzer"""
    print("Testing Python image analyzer...")
    
    test_image = create_test_image()
    
    # Test with different parameters
    test_cases = [
        {'tone': 'casual', 'style': 'short'},
        {'tone': 'professional', 'style': 'medium'},
        {'tone': 'casual', 'style': 'long', 'include_hashtags': True, 'include_emojis': True}
    ]
    
    for i, params in enumerate(test_cases):
        print(f"\nTest case {i+1}: {params}")
        
        result = analyze_image_content(
            test_image,
            params.get('tone', 'casual'),
            params.get('style', 'medium'),
            params.get('include_hashtags', True),
            params.get('include_emojis', True)
        )
        
        if result['success']:
            print("✅ Success!")
            print(f"Caption: {result['caption'][:100]}...")
            print(f"Analysis: {result['analysis']['type']}")
        else:
            print("❌ Failed!")
            print(f"Error: {result['error']}")

if __name__ == '__main__':
    test_analyzer()
