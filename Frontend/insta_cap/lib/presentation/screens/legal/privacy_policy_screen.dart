import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
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
            FadeInDown(
              child: Text(
                'Privacy Policy',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            SizedBox(height: 8.h),
            FadeInDown(
              delay: const Duration(milliseconds: 200),
              child: Text(
                'Last updated: ${DateTime.now().year}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ),
            SizedBox(height: 24.h),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: _buildSection(
                context: context,
                title: '1. Information We Collect',
                content: '''
We collect information you provide directly to us, such as when you create an account, use our services, or contact us for support.

• Account Information: Email address, username, and profile information
• Content: Images and captions you upload or generate
• Usage Data: How you interact with our app and services
• Device Information: Device type, operating system, and app version
''',
              ),
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: _buildSection(
                context: context,
                title: '2. How We Use Your Information',
                content: '''
We use the information we collect to:

• Provide, maintain, and improve our services
• Generate AI-powered captions for your images
• Personalize your experience
• Communicate with you about our services
• Analyze usage patterns to improve our app
• Ensure security and prevent fraud
''',
              ),
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 800),
              child: _buildSection(
                context: context,
                title: '3. Information Sharing',
                content: '''
We do not sell, trade, or otherwise transfer your personal information to third parties except as described in this policy:

• Service Providers: We may share information with trusted third-party service providers
• Legal Requirements: We may disclose information if required by law
• Business Transfers: Information may be transferred in connection with a merger or acquisition
• Consent: We may share information with your consent
''',
              ),
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 1000),
              child: _buildSection(
                context: context,
                title: '4. Data Security',
                content: '''
We implement appropriate security measures to protect your personal information:

• Encryption of data in transit and at rest
• Regular security assessments and updates
• Access controls and authentication
• Secure data storage and backup procedures

However, no method of transmission over the internet is 100% secure.
''',
              ),
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 1200),
              child: _buildSection(
                context: context,
                title: '5. Data Retention',
                content: '''
We retain your information for as long as necessary to:

• Provide our services to you
• Comply with legal obligations
• Resolve disputes and enforce agreements
• Improve our services

You can request deletion of your account and associated data at any time.
''',
              ),
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 1400),
              child: _buildSection(
                context: context,
                title: '6. Your Rights',
                content: '''
You have the right to:

• Access your personal information
• Correct inaccurate information
• Delete your account and data
• Object to processing of your information
• Data portability (receive a copy of your data)
• Withdraw consent at any time
''',
              ),
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 1600),
              child: _buildSection(
                context: context,
                title: '7. Children\'s Privacy',
                content: '''
Our service is not intended for children under 13 years of age. We do not knowingly collect personal information from children under 13.

If you are a parent or guardian and believe your child has provided us with personal information, please contact us.
''',
              ),
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 1800),
              child: _buildSection(
                context: context,
                title: '8. International Data Transfers',
                content: '''
Your information may be transferred to and processed in countries other than your own. We ensure appropriate safeguards are in place to protect your information.
''',
              ),
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 2000),
              child: _buildSection(
                context: context,
                title: '9. Changes to This Policy',
                content: '''
We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last updated" date.

We encourage you to review this Privacy Policy periodically for any changes.
''',
              ),
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 2200),
              child: _buildSection(
                context: context,
                title: '10. Contact Us',
                content: '''
If you have any questions about this Privacy Policy, please contact us:

• Email: privacy@instacap.app
• Address: 123 Privacy Street, Data City, DC 12345
• Phone: +1 (555) 123-4567

We will respond to your inquiry within 30 days.
''',
              ),
            ),
            SizedBox(height: 40.h),
            FadeInUp(
              delay: const Duration(milliseconds: 2400),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.security,
                      size: 48.sp,
                      color: AppColors.primary,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Your Privacy Matters',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'We are committed to protecting your privacy and being transparent about how we handle your data.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required String content,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      padding: EdgeInsets.all(16.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
          ),
          SizedBox(height: 12.h),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }
}
