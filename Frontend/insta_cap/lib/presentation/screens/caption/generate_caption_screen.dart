import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../../core/theme/app_theme.dart';
import '../../../providers/caption_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/gradient_button.dart';

class GenerateCaptionScreen extends StatefulWidget {
  const GenerateCaptionScreen({super.key});

  @override
  State<GenerateCaptionScreen> createState() => _GenerateCaptionScreenState();
}

class _GenerateCaptionScreenState extends State<GenerateCaptionScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _promptController = TextEditingController();

  String _selectedStyle = 'casual';
  String _selectedPlatform = 'instagram';
  int _captionCount = 3;

  final List<Map<String, dynamic>> _styles = [
    {
      'value': 'casual',
      'label': 'Casual',
      'icon': Icons.mood,
      'color': AppColors.primary
    },
    {
      'value': 'professional',
      'label': 'Professional',
      'icon': Icons.business,
      'color': AppColors.secondary
    },
    {
      'value': 'funny',
      'label': 'Funny',
      'icon': Icons.mood_outlined,
      'color': AppColors.accent
    },
    {
      'value': 'inspirational',
      'label': 'Inspirational',
      'icon': Icons.lightbulb,
      'color': AppColors.primary
    },
    {
      'value': 'trendy',
      'label': 'Trendy',
      'icon': Icons.trending_up,
      'color': AppColors.secondary
    },
  ];

  final List<Map<String, dynamic>> _platforms = [
    {'value': 'instagram', 'label': 'Instagram', 'icon': Icons.camera_alt},
    {'value': 'facebook', 'label': 'Facebook', 'icon': Icons.facebook},
    {'value': 'twitter', 'label': 'Twitter', 'icon': Icons.alternate_email},
    {'value': 'linkedin', 'label': 'LinkedIn', 'icon': Icons.work},
  ];

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showImagePickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Select Image Source',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: _buildImageSourceOption(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildImageSourceOption(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.grey50,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32.sp,
              color: AppColors.primary,
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _generateCaptions() async {
    final captionProvider =
        Provider.of<CaptionProvider>(context, listen: false);

    final success = await captionProvider.generateCaptions(
      imageFile: _selectedImage,
      style: _selectedStyle,
      platform: _selectedPlatform,
      prompt: _promptController.text.trim().isEmpty
          ? null
          : _promptController.text.trim(),
      count: _captionCount,
    );

    if (success && mounted) {
      context.push('/caption-result', extra: {
        'captions': captionProvider.captions,
        'imageFile': _selectedImage,
        'style': _selectedStyle,
        'platform': _selectedPlatform,
      });
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(captionProvider.error ?? 'Failed to generate captions'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Caption'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Upload Section
              FadeInUp(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upload Image',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Select an image to generate captions for (optional)',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    SizedBox(height: 16.h),
                    GestureDetector(
                      onTap: _showImagePickerBottomSheet,
                      child: Container(
                        width: double.infinity,
                        height: 200.h,
                        decoration: BoxDecoration(
                          color: AppColors.grey50,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColors.grey300,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: _selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate_outlined,
                                    size: 48.sp,
                                    color: AppColors.grey500,
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'Tap to select image',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.grey500,
                                        ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    if (_selectedImage != null) ...[
                      SizedBox(height: 8.h),
                      Center(
                        child: TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _selectedImage = null;
                            });
                          },
                          icon: Icon(Icons.delete_outline, size: 16.sp),
                          label: const Text('Remove Image'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              SizedBox(height: 32.h),

              // Style Selection
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Caption Style',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 16.h),
                    Wrap(
                      spacing: 12.w,
                      runSpacing: 12.h,
                      children: _styles.map((style) {
                        final isSelected = _selectedStyle == style['value'];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedStyle = style['value'];
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? style['color'] : Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: isSelected
                                    ? style['color']
                                    : AppColors.grey300,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  style['icon'],
                                  size: 16.sp,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.grey600,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  style['label'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: isSelected
                                            ? Colors.white
                                            : AppColors.grey600,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32.h),

              // Platform Selection
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Platform',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 16.h),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.h,
                        childAspectRatio: 3,
                      ),
                      itemCount: _platforms.length,
                      itemBuilder: (context, index) {
                        final platform = _platforms[index];
                        final isSelected =
                            _selectedPlatform == platform['value'];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedPlatform = platform['value'];
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color:
                                  isSelected ? AppColors.primary : Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.grey300,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  platform['icon'],
                                  size: 20.sp,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.grey600,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  platform['label'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: isSelected
                                            ? Colors.white
                                            : AppColors.grey600,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32.h),

              // Caption Count
              FadeInUp(
                delay: const Duration(milliseconds: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Number of Captions',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: _captionCount.toDouble(),
                            min: 3,
                            max: 6,
                            divisions: 3,
                            label: '$_captionCount captions',
                            activeColor: AppColors.primary,
                            onChanged: (value) {
                              setState(() {
                                _captionCount = value.round();
                              });
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            '$_captionCount',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32.h),

              // Custom Prompt (Optional)
              FadeInUp(
                delay: const Duration(milliseconds: 800),
                child: CustomTextField(
                  controller: _promptController,
                  labelText: 'Custom Prompt (Optional)',
                  hintText: 'Describe what you want in your caption...',
                  maxLines: 3,
                ),
              ),

              SizedBox(height: 40.h),

              // Generate Button
              FadeInUp(
                delay: const Duration(milliseconds: 1000),
                child: Consumer<CaptionProvider>(
                  builder: (context, captionProvider, child) {
                    return GradientButton(
                      onPressed:
                          captionProvider.isLoading ? () {} : _generateCaptions,
                      text: 'Generate Captions',
                      gradient: AppColors.primaryGradient,
                      icon: Icons.auto_awesome,
                      isLoading: captionProvider.isLoading,
                    );
                  },
                ),
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
