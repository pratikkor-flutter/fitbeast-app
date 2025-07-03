import 'package:flutter/material.dart';

class HelpView extends StatelessWidget {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Help Center'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Frequently Asked Questions',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            _buildFAQItem(
              context,
              question: 'How do I track my water intake?',
              answer:
                  'Go to the Today\'s Progress screen and tap on the Water Level section. You can log each time you drink water or adjust the total amount directly.',
            ),
            _buildFAQItem(
              context,
              question: 'Why isn\'t my step count updating?',
              answer:
                  'Make sure the app has permission to access your device\'s activity data. Also check that your phone\'s health services are enabled.',
            ),
            _buildFAQItem(
              context,
              question: 'How are calories calculated?',
              answer:
                  'Calories are estimated based on your activity data, height, weight, and age. For more accurate tracking, you can log meals manually in the Nutrition section.',
            ),
            _buildFAQItem(
              context,
              question: 'Can I customize my fitness goals?',
              answer:
                  'Yes! Go to the Plans tab and tap on "Edit Goals" to adjust your daily targets for steps, water, sleep, and calories.',
            ),
            const SizedBox(height: 30),
            Text(
              'Contact Support',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            _buildContactOption(
              context,
              icon: Icons.email,
              title: 'Email Us',
              subtitle: 'desk.daemons@gmail.com',
              onTap: () {
                // Handle email tap
              },
            ),
            const SizedBox(
              height: 10,
            ),
            _buildContactOption(
              context,
              icon: Icons.phone,
              title: 'Call Support',
              subtitle: '+91 9657546519',
              onTap: () {
                // Handle phone tap
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(BuildContext context,
      {required String question, required String answer}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ExpansionTile(
        shape: const RoundedRectangleBorder(
          side: BorderSide.none,
        ),
        collapsedShape: const RoundedRectangleBorder(
          side: BorderSide.none,
        ),
        title: Text(
          question,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Text(
              answer,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
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
