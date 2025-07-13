import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

import '../../../core/theme/app_theme.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/user_provider.dart';
import '../../widgets/feature_card.dart';
import '../../widgets/quick_action_card.dart';
import '../../widgets/glass_widgets.dart';
import '../../widgets/themed_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userName;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (authProvider.user != null) {
      setState(() {
        userName = authProvider.user!.displayName ?? 'User';
      });
      await userProvider.loadUserStats();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.backgroundLight,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withValues(alpha: 0.1),
              AppColors.secondary.withValues(alpha: 0.1),
              AppColors.accent.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _loadUserData,
            child: CustomScrollView(
              slivers: [
                // Glass App Bar
                SliverAppBar(
                  expandedHeight: 180.h,
                  floating: true,
                  pinned: false,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        // Glass effect background
                        Positioned.fill(
                          child: ClipRRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withValues(alpha: 0.2),
                                      Colors.white.withValues(alpha: 0.1),
                                    ],
                                  ),
                                  border: Border(
                                    bottom: BorderSide(
                                      color:
                                          Colors.white.withValues(alpha: 0.2),
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Content
                        Positioned(
                          left: 20.w,
                          right: 20.w,
                          bottom: 20.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FadeInDown(
                                      duration: Duration(milliseconds: 800),
                                      child: ThemedText(
                                        'Welcome back! 👋',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 28.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        onGlass: true,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    FadeInDown(
                                      duration: Duration(milliseconds: 900),
                                      delay: Duration(milliseconds: 100),
                                      child: ThemedText(
                                        userName ?? 'User',
                                        style: GoogleFonts.inter(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        primary: false,
                                        onGlass: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              FadeInDown(
                                duration: Duration(milliseconds: 1000),
                                delay: Duration(milliseconds: 200),
                                child: GlassButton(
                                  onPressed: () => context.push('/profile'),
                                  borderRadius: BorderRadius.circular(25.r),
                                  child: Icon(
                                    Icons.person_outline,
                                    color: AppColors.primary,
                                    size: 24.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Main Content
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      SizedBox(height: 20.h),

                      // Main Action Card
                      FadeInUp(
                        duration: Duration(milliseconds: 800),
                        child: NeonContainer(
                          neonColor: AppColors.primary,
                          child: Container(
                            padding: EdgeInsets.all(24.w),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.primary,
                                  AppColors.secondary,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ThemedText(
                                  'Create Amazing Captions',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  onGradient: true,
                                ),
                                SizedBox(height: 8.h),
                                ThemedText(
                                  'Upload an image and let AI generate perfect captions for your social media posts.',
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                  ),
                                  onGradient: true,
                                ),
                                SizedBox(height: 20.h),
                                SizedBox(
                                  width: double.infinity,
                                  child: GlassButton(
                                    onPressed: () {
                                      context.push('/generate-caption');
                                    },
                                    backgroundColor:
                                        Colors.white.withValues(alpha: 0.2),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.auto_awesome,
                                            size: 20.sp,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 8.w),
                                          ThemedText(
                                            'Generate Caption',
                                            style: GoogleFonts.inter(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            onGradient: true,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 32.h),

                      // Quick Actions
                      FadeInUp(
                        duration: Duration(milliseconds: 800),
                        delay: Duration(milliseconds: 200),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quick Actions',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              children: [
                                Expanded(
                                  child: GlassCard(
                                    child: QuickActionCard(
                                      icon: Icons.history,
                                      title: 'History',
                                      description: 'View past captions',
                                      color: AppColors.secondary,
                                      onTap: () {
                                        context.go('/history');
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: GlassCard(
                                    child: QuickActionCard(
                                      icon: Icons.star,
                                      title: 'Premium',
                                      description: 'Unlock all features',
                                      color: AppColors.accent,
                                      onTap: () {
                                        context.go('/premium');
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 32.h),

                      // Stats Section
                      FadeInUp(
                        duration: Duration(milliseconds: 800),
                        delay: Duration(milliseconds: 400),
                        child: Consumer<UserProvider>(
                          builder: (context, userProvider, child) {
                            final stats = userProvider.userStats;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your Stats',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                GlassCard(
                                  child: Padding(
                                    padding: EdgeInsets.all(20.w),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: _buildStatItem(
                                            title: 'Captions Generated',
                                            value:
                                                '${stats?.totalCaptions ?? 42}',
                                            icon: Icons.edit,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        Container(
                                          width: 1,
                                          height: 40.h,
                                          color: AppColors.grey200,
                                        ),
                                        Expanded(
                                          child: _buildStatItem(
                                            title: 'Favorites',
                                            value:
                                                '${stats?.savedCaptions ?? 15}',
                                            icon: Icons.favorite,
                                            color: AppColors.secondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 32.h),

                      // Features Section
                      FadeInUp(
                        duration: Duration(milliseconds: 800),
                        delay: Duration(milliseconds: 600),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Features',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            GlassCard(
                              child: FeatureCard(
                                icon: Icons.auto_awesome,
                                title: 'AI-Powered Generation',
                                description:
                                    'Advanced AI creates engaging captions tailored to your content.',
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            GlassCard(
                              child: FeatureCard(
                                icon: Icons.share,
                                title: 'Multiple Platforms',
                                description:
                                    'Optimized captions for Instagram, Facebook, Twitter, and more.',
                                color: AppColors.secondary,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            GlassCard(
                              child: FeatureCard(
                                icon: Icons.style,
                                title: 'Different Styles',
                                description:
                                    'Choose from casual, professional, funny, or inspirational tones.',
                                color: AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                          height: 100.h), // Extra space for bottom navigation
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24.sp,
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
