import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../providers/theme_provider.dart';
import '../widgets/themed_text.dart';
import '../widgets/feature_card.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/gradient_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/glass_widgets.dart';

class TextColorTestScreen extends StatefulWidget {
  const TextColorTestScreen({super.key});

  @override
  State<TextColorTestScreen> createState() => _TextColorTestScreenState();
}

class _TextColorTestScreenState extends State<TextColorTestScreen> {
  final _testController = TextEditingController();

  @override
  void dispose() {
    _testController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const HeadlineText('Text Color Test'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Theme Status
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleText('Current Theme: ${isDark ? 'Dark' : 'Light'}'),
                      SizedBox(height: 8.h),
                      BodyText('Test all text colors in both themes'),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // Typography Test
              const TitleText('Typography Test'),
              SizedBox(height: 16.h),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeadlineText('Headline Text'),
                      SizedBox(height: 8.h),
                      const TitleText('Title Text'),
                      SizedBox(height: 8.h),
                      const BodyText('Primary body text'),
                      SizedBox(height: 8.h),
                      const BodyText('Secondary body text', primary: false),
                      SizedBox(height: 8.h),
                      const CaptionText('Caption text'),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // Glass Effect Test
              const TitleText('Glass Effect Text'),
              SizedBox(height: 16.h),
              Container(
                width: double.infinity,
                height: 200.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: GlassContainer(
                        borderRadius: BorderRadius.circular(16.r),
                        child: Padding(
                          padding: EdgeInsets.all(20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const HeadlineText('Glass Headline', onGlass: true),
                              SizedBox(height: 8.h),
                              const BodyText('Glass body text', onGlass: true),
                              SizedBox(height: 8.h),
                              const BodyText('Glass secondary text', 
                                primary: false, onGlass: true),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // Gradient Text Test
              const TitleText('Gradient Background Text'),
              SizedBox(height: 16.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.accent],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeadlineText('Gradient Headline', onGradient: true),
                    SizedBox(height: 8.h),
                    const BodyText('Gradient body text', onGradient: true),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // Button Test
              const TitleText('Button Text'),
              SizedBox(height: 16.h),
              GradientButton(
                onPressed: () {},
                text: 'Gradient Button',
                gradient: const [AppColors.primary, AppColors.secondary],
                icon: Icons.star,
              ),

              SizedBox(height: 20.h),

              // Form Field Test
              const TitleText('Form Field Text'),
              SizedBox(height: 16.h),
              CustomTextField(
                controller: _testController,
                labelText: 'Test Label',
                hintText: 'Test hint text',
                prefixIcon: Icons.email,
              ),

              SizedBox(height: 20.h),

              // Feature Card Test
              const TitleText('Feature Cards'),
              SizedBox(height: 16.h),
              FeatureCard(
                icon: Icons.auto_awesome,
                title: 'AI Caption Generation',
                description: 'Generate amazing captions with AI',
                color: AppColors.primary,
              ),

              SizedBox(height: 16.h),

              // Quick Action Test
              const TitleText('Quick Action Cards'),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: QuickActionCard(
                      icon: Icons.photo_camera,
                      title: 'Camera',
                      description: 'Take photo',
                      color: AppColors.primary,
                      onTap: () {},
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: QuickActionCard(
                      icon: Icons.photo_library,
                      title: 'Gallery',
                      description: 'Choose photo',
                      color: AppColors.secondary,
                      onTap: () {},
                    ),
                  ),
                ],
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
