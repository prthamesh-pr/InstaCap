import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
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
                'Terms and Conditions',
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
                title: '1. Acceptance of Terms',
                content: '''
By downloading, installing, or using the InstaCap application ("Service"), you agree to be bound by these Terms and Conditions ("Terms").

If you do not agree to these Terms, do not use our Service. These Terms apply to all users of the Service.
''',
              ),
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: _buildSection(
                context: context,
                title: '2. Description of Service',
                content: '''
InstaCap is an AI-powered caption generation service that helps users create engaging captions for their social media content.

Our Service includes:
• AI-generated captions for images
• Multiple caption styles and tones
• Caption history and management
• Premium features for enhanced functionality
''',
              ),
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 800),
              child: _buildSection(
                context: context,
                title: '3. User Accounts',
                content: '''
To use certain features of our Service, you must create an account:

• You must provide accurate and complete information
• You are responsible for maintaining account security
• You must notify us immediately of any unauthorized use
• You may not share your account with others
• You must be at least 13 years old to create an account
''',
              ),
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 1000),
              child: _buildSection(
                context: context,
                title: '4. Acceptable Use',
                content: '''
You agree to use our Service only for lawful purposes and in accordance with these Terms:

You may NOT:
• Upload illegal, harmful, or offensive content
• Violate any intellectual property rights
• Attempt to hack or disrupt our Service
• Use our Service for spam or unauthorized advertising
• Impersonate others or provide false information
• Use automated systems to access our Service
''',
              ),
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 1200),
              child: _buildSection(
                context: context,
                title: '5. Content and Intellectual Property',
                content: '''
Content Ownership:
• You retain ownership of content you upload
• You grant us a license to process your content to provide our Service
• Generated captions are provided for your use
• You are responsible for ensuring you have rights to uploaded content

Our Intellectual Property:
• The Service and its technology are owned by us
• You may not copy, modify, or reverse engineer our Service
''',
              ),
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 1400),
              child: _buildSection(
                context: context,
                title: '6. Premium Services and Payment',
                content: '''
Premium Features:
• Some features require a paid subscription
• Subscription fees are charged in advance
• You can cancel your subscription at any time
• No refunds for partial subscription periods

Payment Terms:
• All fees are non-refundable except as required by law
• Prices may change with 30 days notice
• Failed payments may result in service suspension
''',
              ),
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 1600),
              child: _buildSection(
                context: context,
                title: '7. Privacy and Data Protection',
                content: '''
Your privacy is important to us. Our Privacy Policy explains how we collect, use, and protect your information.

By using our Service, you consent to:
• Collection and processing of your data as described in our Privacy Policy
• Use of cookies and similar technologies
• International transfer of data for service provision
''',
              ),
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 1800),
              child: _buildSection(
                context: context,
                title: '8. Disclaimers and Limitations',
                content: '''
Service Availability:
• Our Service is provided "as is" without warranties
• We do not guarantee uninterrupted service
• AI-generated content may not always be accurate or appropriate

Limitation of Liability:
• We are not liable for indirect or consequential damages
• Our liability is limited to the amount you paid for the Service
• Some jurisdictions do not allow these limitations
''',
              ),
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 2000),
              child: _buildSection(
                context: context,
                title: '9. Termination',
                content: '''
Account Termination:
• You may terminate your account at any time
• We may terminate accounts for violations of these Terms
• Upon termination, your right to use the Service ceases
• We may retain certain information as required by law

Effect of Termination:
• Access to premium features will cease
• Generated captions may remain accessible for a limited time
''',
              ),
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 2200),
              child: _buildSection(
                context: context,
                title: '10. Updates and Changes',
                content: '''
Service Updates:
• We may update our Service from time to time
• Updates may include new features or changes to existing features
• Continued use constitutes acceptance of updates

Terms Changes:
• We may modify these Terms with notice
• Material changes will be communicated to users
• Continued use after changes constitutes acceptance
''',
              ),
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 2400),
              child: _buildSection(
                context: context,
                title: '11. Governing Law',
                content: '''
These Terms are governed by the laws of [Your Jurisdiction] without regard to conflict of law principles.

Any disputes shall be resolved through:
• Good faith negotiation first
• Binding arbitration if negotiation fails
• Courts of [Your Jurisdiction] for injunctive relief
''',
              ),
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 2600),
              child: _buildSection(
                context: context,
                title: '12. Contact Information',
                content: '''
If you have questions about these Terms, contact us:

• Email: legal@instacap.app
• Address: 123 Legal Street, Terms City, TC 12345
• Phone: +1 (555) 123-4567

We will respond to your inquiry within 7 business days.
''',
              ),
            ),
            SizedBox(height: 40.h),
            FadeInUp(
              delay: const Duration(milliseconds: 2800),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.gavel,
                      size: 48.sp,
                      color: AppColors.secondary,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Legal Agreement',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'These terms constitute a legally binding agreement between you and InstaCap. Please read them carefully.',
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
                  color: AppColors.secondary,
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
