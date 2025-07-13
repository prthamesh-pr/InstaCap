import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../widgets/glass_widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
    ));

    _controller.forward();

    _navigateToNextScreen();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.isFirstTime) {
      context.go('/onboarding');
    } else if (authProvider.isAuthenticated) {
      context.go('/home');
    } else {
      context.go('/signin');
    }
  }

  Widget _buildBackgroundParticles(BuildContext context) {
    return Stack(
      children: [
        // Floating particles with different sizes and opacity
        ...List.generate(15, (index) {
          return Positioned(
            top: (index * 50.0) % MediaQuery.of(context).size.height,
            left: (index * 30.0) % MediaQuery.of(context).size.width,
            child: FadeInUp(
              delay: Duration(milliseconds: index * 200),
              duration: const Duration(milliseconds: 2000),
              child: Container(
                width: (20 + (index % 3) * 10).w,
                height: (20 + (index % 3) * 10).w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.1),
                      Colors.white.withValues(alpha: 0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          );
        }),

        // Glass morphism overlay
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0.1),
                  Colors.white.withValues(alpha: 0.05),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.secondary,
              AppColors.accent,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background particles
            _buildBackgroundParticles(context),

            // Main content
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo with Glass Effect
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: GlassContainer(
                              width: 140.w,
                              height: 140.h,
                              borderRadius: BorderRadius.circular(35.r),
                              child: Icon(
                                Icons.auto_awesome,
                                size: 70.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 40.h),

                    // App Name with Google Fonts
                    FadeInUp(
                      delay: const Duration(milliseconds: 500),
                      child: Text(
                        'InstaCap',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 42.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              offset: Offset(0, 2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 12.h),

                    // Tagline with Glass Container
                    FadeInUp(
                      delay: const Duration(milliseconds: 700),
                      child: GlassContainer(
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.w, vertical: 12.h),
                        borderRadius: BorderRadius.circular(25.r),
                        child: Text(
                          'AI-Powered Caption Generator',
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            color: Colors.white.withValues(alpha: 0.95),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 100.h),

                    // Loading Animation with Neon Effect
                    FadeInUp(
                      delay: const Duration(milliseconds: 1000),
                      child: NeonContainer(
                        neonColor: Colors.white,
                        borderRadius: BorderRadius.circular(40.r),
                        child: Container(
                          width: 80.w,
                          height: 80.h,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(40.r),
                          ),
                          child: const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 3,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Loading text
                    FadeInUp(
                      delay: const Duration(milliseconds: 1200),
                      child: Text(
                        'Loading amazing captions...',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: Colors.white.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
