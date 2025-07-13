import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _autoSave = true;
  bool _analytics = true;
  String _defaultStyle = 'casual';
  String _defaultPlatform = 'instagram';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Appearance Section
            FadeInUp(
              child: _buildSection(
                title: 'Appearance',
                children: [
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return _buildSwitchTile(
                        icon: Icons.dark_mode,
                        title: 'Dark Mode',
                        subtitle: 'Enable dark theme',
                        value: themeProvider.isDarkMode,
                        onChanged: (value) {
                          themeProvider.toggleTheme();
                        },
                      );
                    },
                  ),
                  _buildDropdownTile(
                    icon: Icons.language,
                    title: 'Language',
                    subtitle: 'Select your preferred language',
                    value: 'English',
                    items: const ['English', 'Spanish', 'French', 'German'],
                    onChanged: (value) {
                      // TODO: Implement language change
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Notifications Section
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: _buildSection(
                title: 'Notifications',
                children: [
                  _buildSwitchTile(
                    icon: Icons.notifications,
                    title: 'Push Notifications',
                    subtitle: 'Receive app notifications',
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                  ),
                  _buildSwitchTile(
                    icon: Icons.email,
                    title: 'Email Updates',
                    subtitle: 'Receive updates via email',
                    value: false,
                    onChanged: (value) {
                      // TODO: Implement email notifications
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Caption Preferences Section
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: _buildSection(
                title: 'Caption Preferences',
                children: [
                  _buildDropdownTile(
                    icon: Icons.style,
                    title: 'Default Style',
                    subtitle: 'Your preferred caption style',
                    value: _defaultStyle,
                    items: const [
                      'casual',
                      'professional',
                      'funny',
                      'inspirational',
                      'trendy'
                    ],
                    onChanged: (value) {
                      setState(() {
                        _defaultStyle = value;
                      });
                    },
                  ),
                  _buildDropdownTile(
                    icon: Icons.share,
                    title: 'Default Platform',
                    subtitle: 'Your preferred social platform',
                    value: _defaultPlatform,
                    items: const [
                      'instagram',
                      'facebook',
                      'twitter',
                      'linkedin'
                    ],
                    onChanged: (value) {
                      setState(() {
                        _defaultPlatform = value;
                      });
                    },
                  ),
                  _buildSwitchTile(
                    icon: Icons.save,
                    title: 'Auto Save',
                    subtitle: 'Automatically save generated captions',
                    value: _autoSave,
                    onChanged: (value) {
                      setState(() {
                        _autoSave = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Privacy & Security Section
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: _buildSection(
                title: 'Privacy & Security',
                children: [
                  _buildSwitchTile(
                    icon: Icons.analytics,
                    title: 'Analytics',
                    subtitle: 'Help improve the app with usage data',
                    value: _analytics,
                    onChanged: (value) {
                      setState(() {
                        _analytics = value;
                      });
                    },
                  ),
                  _buildActionTile(
                    icon: Icons.lock,
                    title: 'Change Password',
                    subtitle: 'Update your account password',
                    onTap: _changePassword,
                  ),
                  _buildActionTile(
                    icon: Icons.delete_forever,
                    title: 'Delete Account',
                    subtitle: 'Permanently delete your account',
                    onTap: _deleteAccount,
                    isDestructive: true,
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Storage Section
            FadeInUp(
              delay: const Duration(milliseconds: 800),
              child: _buildSection(
                title: 'Storage',
                children: [
                  _buildActionTile(
                    icon: Icons.cached,
                    title: 'Clear Cache',
                    subtitle: 'Free up storage space',
                    onTap: _clearCache,
                  ),
                  _buildActionTile(
                    icon: Icons.download,
                    title: 'Export Data',
                    subtitle: 'Download your caption history',
                    onTap: _exportData,
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Support Section
            FadeInUp(
              delay: const Duration(milliseconds: 1000),
              child: _buildSection(
                title: 'Support',
                children: [
                  _buildActionTile(
                    icon: Icons.help,
                    title: 'Help Center',
                    subtitle: 'Get help and support',
                    onTap: _openHelpCenter,
                  ),
                  _buildActionTile(
                    icon: Icons.bug_report,
                    title: 'Report Bug',
                    subtitle: 'Report an issue or bug',
                    onTap: _reportBug,
                  ),
                  _buildActionTile(
                    icon: Icons.feedback,
                    title: 'Send Feedback',
                    subtitle: 'Share your thoughts with us',
                    onTap: _sendFeedback,
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // About Section
            FadeInUp(
              delay: const Duration(milliseconds: 1200),
              child: _buildSection(
                title: 'About',
                children: [
                  _buildActionTile(
                    icon: Icons.info,
                    title: 'App Version',
                    subtitle: '1.0.0 (Build 1)',
                    onTap: () {},
                    showArrow: false,
                  ),
                  _buildActionTile(
                    icon: Icons.privacy_tip,
                    title: 'Privacy Policy',
                    subtitle: 'Read our privacy policy',
                    onTap: () => context.push('/privacy-policy'),
                  ),
                  _buildActionTile(
                    icon: Icons.description,
                    title: 'Terms of Service',
                    subtitle: 'View terms and conditions',
                    onTap: () => context.push('/terms-conditions'),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 12.h),
        Container(
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
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
          size: 20.sp,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
    );
  }

  Widget _buildDropdownTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return ListTile(
      leading: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
          size: 20.sp,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
      ),
      trailing: DropdownButton<String>(
        value: value,
        onChanged: (newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item.toLowerCase() == item
                  ? item.replaceFirst(item[0], item[0].toUpperCase())
                  : item,
            ),
          );
        }).toList(),
        underline: Container(),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
    bool showArrow = true,
  }) {
    return ListTile(
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
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDestructive ? AppColors.error : null,
            ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
      ),
      trailing: showArrow
          ? Icon(
              Icons.chevron_right,
              color: AppColors.grey400,
            )
          : null,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
    );
  }

  void _changePassword() {
    // TODO: Implement change password
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Change password feature coming soon!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement account deletion
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deletion feature coming soon!'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _clearCache() {
    // TODO: Implement clear cache
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cache cleared successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _exportData() {
    // TODO: Implement data export
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data export feature coming soon!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _openHelpCenter() {
    // TODO: Implement help center
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Help center feature coming soon!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _reportBug() {
    // TODO: Implement bug reporting
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bug reporting feature coming soon!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _sendFeedback() {
    // TODO: Implement feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Feedback feature coming soon!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
