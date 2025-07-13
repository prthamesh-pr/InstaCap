import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).loadUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Profile Header
          SliverAppBar(
            expandedHeight: 280.h,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.primary,
            actions: [
              IconButton(
                onPressed: () => context.push('/settings'),
                icon: const Icon(Icons.settings),
                color: Colors.white,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: AppColors.primaryGradient,
                  ),
                ),
                child: Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    final user = userProvider.currentUser;

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 60.h),
                          FadeInDown(
                            child: CircleAvatar(
                              radius: 50.r,
                              backgroundColor: Colors.white,
                              backgroundImage: user?.profilePicture != null
                                  ? NetworkImage(user!.profilePicture!)
                                  : null,
                              child: user?.profilePicture == null
                                  ? Icon(
                                      Icons.person,
                                      size: 50.sp,
                                      color: AppColors.primary,
                                    )
                                  : null,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          FadeInDown(
                            delay: const Duration(milliseconds: 200),
                            child: Text(
                              user?.displayName ?? 'User',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          FadeInDown(
                            delay: const Duration(milliseconds: 400),
                            child: Text(
                              user?.email ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          FadeInDown(
                            delay: const Duration(milliseconds: 600),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                user?.isPremium == true
                                    ? 'Premium Member'
                                    : 'Free Member',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Stats Section
          SliverToBoxAdapter(
            child: FadeInUp(
              delay: const Duration(milliseconds: 800),
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
                child: Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    final stats = userProvider.userStats;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Activity',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.text_fields,
                                title: 'Captions Generated',
                                value: '${stats?.totalCaptions ?? 0}',
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.favorite,
                                title: 'Saved Captions',
                                value: '${stats?.savedCaptions ?? 0}',
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.calendar_today,
                                title: 'Days Active',
                                value: '${stats?.daysActive ?? 0}',
                                color: AppColors.success,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.trending_up,
                                title: 'This Month',
                                value: '${stats?.monthlyUsage ?? 0}',
                                color: AppColors.warning,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),

          // Quick Actions
          SliverToBoxAdapter(
            child: FadeInUp(
              delay: const Duration(milliseconds: 1000),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Actions',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 16.h),
                    _buildActionCard(
                      icon: Icons.diamond,
                      title: 'Upgrade to Premium',
                      subtitle:
                          'Unlock unlimited captions and advanced features',
                      onTap: () => context.push('/premium'),
                      showBadge: true,
                    ),
                    _buildActionCard(
                      icon: Icons.history,
                      title: 'Caption History',
                      subtitle: 'View and manage your generated captions',
                      onTap: () => context.push('/history'),
                    ),
                    _buildActionCard(
                      icon: Icons.share,
                      title: 'Share App',
                      subtitle: 'Tell your friends about InstaCap',
                      onTap: _shareApp,
                    ),
                    _buildActionCard(
                      icon: Icons.star_rate,
                      title: 'Rate Us',
                      subtitle: 'Help us improve by rating the app',
                      onTap: _rateApp,
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(height: 32.h),
          ),

          // Account Section
          SliverToBoxAdapter(
            child: FadeInUp(
              delay: const Duration(milliseconds: 1200),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 16.h),
                    _buildActionCard(
                      icon: Icons.edit,
                      title: 'Edit Profile',
                      subtitle: 'Update your profile information',
                      onTap: _editProfile,
                    ),
                    _buildActionCard(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      subtitle: 'Manage your notification preferences',
                      onTap: () => context.push('/settings'),
                    ),
                    _buildActionCard(
                      icon: Icons.privacy_tip,
                      title: 'Privacy Policy',
                      subtitle: 'Read our privacy policy',
                      onTap: () => context.push('/privacy-policy'),
                    ),
                    _buildActionCard(
                      icon: Icons.description,
                      title: 'Terms & Conditions',
                      subtitle: 'View terms and conditions',
                      onTap: () => context.push('/terms-conditions'),
                    ),
                    _buildActionCard(
                      icon: Icons.logout,
                      title: 'Sign Out',
                      subtitle: 'Sign out of your account',
                      onTap: _signOut,
                      isDestructive: true,
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(height: 40.h),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 24.sp,
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool showBadge = false,
    bool isDestructive = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: isDestructive
                ? AppColors.error.withValues(alpha: 0.1)
                : AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            icon,
            color: isDestructive ? AppColors.error : AppColors.primary,
            size: 20.sp,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDestructive ? AppColors.error : null,
                    ),
              ),
            ),
            if (showBadge)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'NEW',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10.sp,
                      ),
                ),
              ),
          ],
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: AppColors.grey400,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      ),
    );
  }

  void _editProfile() {
    // TODO: Implement edit profile functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit profile feature coming soon!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _shareApp() {
    // TODO: Implement share app functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share feature coming soon!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _rateApp() {
    // TODO: Implement rate app functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Rate app feature coming soon!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _signOut() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final goRouter = GoRouter.of(context);
              final authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              navigator.pop();
              await authProvider.signOut();
              if (mounted) {
                goRouter.go('/signin');
              }
            },
            child: Text(
              'Sign Out',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

extension SliverBoxHeight on num {
  Widget get sliver => SliverToBoxAdapter(
        child: SizedBox(height: toDouble()),
      );
}
