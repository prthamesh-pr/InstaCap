import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

import '../../../core/theme/app_theme.dart';
import '../../../providers/caption_provider.dart';
import '../../../models/caption_model.dart';
import '../../widgets/gradient_button.dart';

class CaptionResultScreen extends StatefulWidget {
  final List<CaptionData> captions;
  final File? imageFile;
  final String style;
  final String platform;

  const CaptionResultScreen({
    super.key,
    required this.captions,
    this.imageFile,
    required this.style,
    required this.platform,
  });

  @override
  State<CaptionResultScreen> createState() => _CaptionResultScreenState();
}

class _CaptionResultScreenState extends State<CaptionResultScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Caption copied to clipboard!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  void _shareCaption(String text) {
    Share.share(text, subject: 'Check out this amazing caption!');
  }

  void _generateMoreCaptions() async {
    final captionProvider =
        Provider.of<CaptionProvider>(context, listen: false);

    final success = await captionProvider.generateMoreCaptions(
      imageFile: widget.imageFile,
      style: widget.style,
      platform: widget.platform,
      count: 3,
    );

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(captionProvider.error ?? 'Failed to generate more captions'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generated Captions'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Add to favorites
            },
            icon: const Icon(Icons.favorite_border),
          ),
        ],
      ),
      body: Column(
        children: [
          // Image Preview (if available)
          if (widget.imageFile != null)
            FadeInDown(
              child: Container(
                height: 200.h,
                width: double.infinity,
                margin: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Image.file(
                    widget.imageFile!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

          // Caption Info
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      widget.style.toUpperCase(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      widget.platform.toUpperCase(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  const Spacer(),
                  Consumer<CaptionProvider>(
                    builder: (context, captionProvider, child) {
                      return Text(
                        '${captionProvider.captions.length} captions',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20.h),

          // Captions List
          Expanded(
            child: Consumer<CaptionProvider>(
              builder: (context, captionProvider, child) {
                if (captionProvider.captions.isEmpty) {
                  return const Center(
                    child: Text('No captions available'),
                  );
                }

                return FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemCount: captionProvider.captions.length,
                    itemBuilder: (context, index) {
                      final caption = captionProvider.captions[index];
                      return _buildCaptionCard(caption, index);
                    },
                  ),
                );
              },
            ),
          ),

          // Page Indicator
          Consumer<CaptionProvider>(
            builder: (context, captionProvider, child) {
              return FadeInUp(
                delay: const Duration(milliseconds: 600),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      captionProvider.captions.length,
                      (index) => _buildDot(index),
                    ),
                  ),
                ),
              );
            },
          ),

          // Generate More Button
          FadeInUp(
            delay: const Duration(milliseconds: 800),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Consumer<CaptionProvider>(
                builder: (context, captionProvider, child) {
                  return GradientButton(
                    onPressed: captionProvider.isLoading
                        ? () {}
                        : _generateMoreCaptions,
                    text: 'Generate More Captions',
                    gradient: AppColors.secondaryGradient,
                    icon: Icons.refresh,
                    isLoading: captionProvider.isLoading,
                  );
                },
              ),
            ),
          ),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildCaptionCard(CaptionData caption, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Caption Header
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.h,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Caption ${index + 1}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      'Confidence: ${(caption.metadata.confidence * 100).toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'AI Generated',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Caption Text
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                caption.caption,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                      fontSize: 16.sp,
                    ),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Caption Stats
          Row(
            children: [
              _buildStatChip(
                icon: Icons.text_fields,
                label: '${caption.metadata.characterCount} chars',
              ),
              SizedBox(width: 8.w),
              _buildStatChip(
                icon: Icons.tag,
                label: '${caption.metadata.hashtagCount} tags',
              ),
              SizedBox(width: 8.w),
              _buildStatChip(
                icon: Icons.mood,
                label: '${caption.metadata.emojis.length} emojis',
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _copyToClipboard(caption.caption),
                  icon: Icon(Icons.copy, size: 16.sp),
                  label: const Text('Copy'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _shareCaption(caption.caption),
                  icon: Icon(Icons.share, size: 16.sp),
                  label: const Text('Share'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12.sp,
            color: AppColors.grey600,
          ),
          SizedBox(width: 4.w),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.grey600,
                  fontSize: 10.sp,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      width: _currentIndex == index ? 24.w : 8.w,
      height: 8.h,
      decoration: BoxDecoration(
        color: _currentIndex == index ? AppColors.primary : AppColors.grey300,
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }
}
