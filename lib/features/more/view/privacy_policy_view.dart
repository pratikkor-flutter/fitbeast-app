import 'package:flutter/material.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Privacy Matters',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'FitBeast is committed to protecting your personal information. This policy explains how we collect, use, and safeguard your data.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),

            // Policy sections shown linearly
            _buildPolicySection(
              context,
              title: '1. Information We Collect',
              content:
                  'We collect personal data you provide when creating an account, including name, email, age, weight, and height. We also automatically collect activity data like steps, workouts, and sleep patterns when you connect health services.',
            ),

            _buildPolicySection(
              context,
              title: '2. How We Use Your Data',
              content:
                  'Your data helps us provide personalized fitness recommendations, track your progress, and improve our services. We may use anonymized data for research and analytics to enhance user experience.',
            ),

            _buildPolicySection(
              context,
              title: '3. Data Sharing',
              content:
                  'We do not sell your personal data. We may share information with trusted service providers who assist in operating our app, and only when necessary to provide our services.',
            ),

            _buildPolicySection(
              context,
              title: '4. Data Security',
              content:
                  'We implement industry-standard security measures including encryption and secure servers to protect your information from unauthorized access or disclosure.',
            ),

            _buildPolicySection(
              context,
              title: '5. Your Rights',
              content:
                  'You can access, correct, or delete your personal data through your account settings. You may also request a copy of your data or withdraw consent for data processing.',
            ),

            _buildPolicySection(
              context,
              title: '6. Cookies & Tracking',
              content:
                  'We use cookies to improve app functionality and analyze usage patterns. You can manage cookie preferences in your device settings.',
            ),

            _buildPolicySection(
              context,
              title: '7. Policy Updates',
              content:
                  'We may update this policy periodically. Continued use of the app after changes constitutes acceptance of the updated policy.',
            ),

            const SizedBox(height: 24),
            // GDPR/CCPA Compliance Section
            Text(
              'Your Privacy Rights',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildComplianceItem(
              context,
              icon: Icons.gavel,
              title: 'GDPR Compliance',
              subtitle: 'For users in the European Union',
            ),
            _buildComplianceItem(
              context,
              icon: Icons.verified_user,
              title: 'CCPA Compliance',
              subtitle: 'For California residents',
            ),
            const SizedBox(height: 24),
            // Contact section
            Text(
              'Contact Us',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildContactOption(
              context,
              icon: Icons.email,
              title: 'Privacy Questions',
              subtitle: 'desk.daemons@gmail.com',
              onTap: () {
                // Handle email tap
              },
            ),
            _buildContactOption(
              context,
              icon: Icons.description,
              title: 'Data Requests',
              subtitle: 'Submit formal data requests',
              onTap: () {
                // Handle data request tap
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicySection(BuildContext context,
      {required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildComplianceItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }

  Widget _buildContactOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }
}
