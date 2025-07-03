import 'package:flutter/material.dart';

class AboutFitBeastView extends StatelessWidget {
  const AboutFitBeastView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'About FitBeast',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo and Description
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.transparent,
                    backgroundImage:
                        AssetImage('assets/images/fitbeast_logo.png'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'FitBeast v1.0.0',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'FitBeast - Be Fit With Us',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // App Description
            Text(
              'About FitBeast',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'FitBeast is a comprehensive fitness app designed to help you achieve your health goals. '
              'With personalized workout plans, nutrition tracking, and progress analytics, we make fitness '
              'accessible and effective for everyone.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 32),

            // Team Section
            Text(
              'Our Team',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'We are a passionate team of fitness enthusiasts and developers committed to creating '
              'the best fitness experience for our users.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 32),

            // Contact Information (styled like your reference image)
            Text(
              'Contact Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            _buildContactItem(
              context,
              icon: Icons.phone,
              text: '+91 7028472481',
              onTap: () {
                // Handle phone tap
              },
            ),
            _buildContactItem(
              context,
              icon: Icons.email,
              text: 'desk.daemons@gmail.com',
              onTap: () {
                // Handle email tap
              },
            ),
            _buildContactItem(
              context,
              icon: Icons.location_on,
              text: 'ZCOER, Pune\nMaharashtra, IND',
              onTap: () {
                // Handle location tap
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 22, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
