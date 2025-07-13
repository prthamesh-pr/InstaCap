import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../widgets/gradient_button.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  int _selectedPlanIndex = 1; // Default to monthly

  final List<PremiumPlan> _plans = [
    PremiumPlan(
      title: 'Weekly',
      price: '\$2.99',
      period: 'per week',
      description: 'Perfect for trying out premium features',
      features: [
        'Unlimited caption generation',
        'Advanced AI styles',
        'Priority processing',
        'Ad-free experience',
        'Export in multiple formats',
      ],
      isPopular: false,
    ),
    PremiumPlan(
      title: 'Monthly',
      price: '\$9.99',
      period: 'per month',
      description: 'Most popular choice for regular users',
      features: [
        'Everything in Weekly',
        'Batch caption generation',
        'Custom style creation',
        'Analytics dashboard',
        'Priority support',
        'Advanced templates',
      ],
      isPopular: true,
    ),
    PremiumPlan(
      title: 'Yearly',
      price: '\$79.99',
      period: 'per year',
      description: 'Best value - Save 33%!',
      features: [
        'Everything in Monthly',
        'Team collaboration',
        'White-label options',
        'API access',
        'Custom integrations',
        'Dedicated account manager',
      ],
      isPopular: false,
      originalPrice: '\$119.88',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Premium Header
          SliverAppBar(
            expandedHeight: 300.h,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: AppColors.primaryGradient,
                  ),
                ),
                child: Stack(
                  children: [
                    // Background Pattern
                    Positioned(
                      top: -50.h,
                      right: -50.w,
                      child: Container(
                        width: 200.w,
                        height: 200.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -30.h,
                      left: -30.w,
                      child: Container(
                        width: 150.w,
                        height: 150.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                    ),

                    // Content
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 60.h),
                          FadeInDown(
                            child: Icon(
                              Icons.diamond,
                              size: 60.sp,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          FadeInDown(
                            delay: const Duration(milliseconds: 200),
                            child: Text(
                              'Go Premium',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          FadeInDown(
                            delay: const Duration(milliseconds: 400),
                            child: Text(
                              'Unlock unlimited creativity with AI-powered\ncaption generation',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Current Plan Status
          SliverToBoxAdapter(
            child: FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: Container(
                margin: EdgeInsets.all(20.w),
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.person,
                        color: AppColors.warning,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Plan: Free',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            '5 captions remaining this month',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        'Free',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.warning,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Premium Features
          SliverToBoxAdapter(
            child: FadeInUp(
              delay: const Duration(milliseconds: 800),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Premium Features',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 16.h),
                    _buildFeatureItem(
                      icon: Icons.all_inclusive,
                      title: 'Unlimited Generation',
                      description:
                          'Generate unlimited captions without restrictions',
                    ),
                    _buildFeatureItem(
                      icon: Icons.palette,
                      title: 'Advanced AI Styles',
                      description: 'Access to 20+ professional writing styles',
                    ),
                    _buildFeatureItem(
                      icon: Icons.speed,
                      title: 'Priority Processing',
                      description: 'Get your captions generated faster',
                    ),
                    _buildFeatureItem(
                      icon: Icons.analytics,
                      title: 'Advanced Analytics',
                      description: 'Track performance and engagement metrics',
                    ),
                    _buildFeatureItem(
                      icon: Icons.download,
                      title: 'Export Options',
                      description: 'Export captions in multiple formats',
                    ),
                    _buildFeatureItem(
                      icon: Icons.support_agent,
                      title: 'Priority Support',
                      description: '24/7 premium customer support',
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(height: 32.h),
          ),

          // Pricing Plans
          SliverToBoxAdapter(
            child: FadeInUp(
              delay: const Duration(milliseconds: 1000),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose Your Plan',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 16.h),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _plans.length,
                      itemBuilder: (context, index) {
                        return _buildPlanCard(_plans[index], index);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(height: 32.h),
          ),

          // Subscription Button
          SliverToBoxAdapter(
            child: FadeInUp(
              delay: const Duration(milliseconds: 1200),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    GradientButton(
                      onPressed: _subscribeToPlan,
                      text: 'Start Free Trial',
                      gradient: AppColors.primaryGradient,
                      icon: Icons.diamond,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      '7-day free trial, then ${_plans[_selectedPlanIndex].price} ${_plans[_selectedPlanIndex].period}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    TextButton(
                      onPressed: () {
                        // Show terms and conditions
                        context.push('/terms-conditions');
                      },
                      child: Text(
                        'Terms and Conditions',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.primary,
                              decoration: TextDecoration.underline,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 40.h)),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(PremiumPlan plan, int index) {
    final isSelected = _selectedPlanIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlanIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (plan.isPopular)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.secondaryGradient,
                    ),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16.r),
                      bottomLeft: Radius.circular(16.r),
                    ),
                  ),
                  child: Text(
                    'POPULAR',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plan.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              plan.description,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (plan.originalPrice != null)
                            Text(
                              plan.originalPrice!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                            ),
                          Text(
                            plan.price,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                          ),
                          Text(
                            plan.period,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  ...plan.features.map((feature) => Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 16.sp,
                              color: AppColors.success,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                feature,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _subscribeToPlan() {
    // TODO: Implement subscription logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Starting ${_plans[_selectedPlanIndex].title} subscription...'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}

extension SliverBoxHeight on num {
  Widget get sliver => SliverToBoxAdapter(
        child: SizedBox(height: toDouble()),
      );
}

class PremiumPlan {
  final String title;
  final String price;
  final String period;
  final String description;
  final List<String> features;
  final bool isPopular;
  final String? originalPrice;

  const PremiumPlan({
    required this.title,
    required this.price,
    required this.period,
    required this.description,
    required this.features,
    this.isPopular = false,
    this.originalPrice,
  });
}
