import 'package:flutter/material.dart';

class TermsAndConditionsView extends StatelessWidget {
  const TermsAndConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Terms & Conditions',
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
            const Text(
              'Last Updated: June 12, 2023',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Welcome to FitBeast!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'These Terms and Conditions outline the rules and regulations for the use of FitBeast\'s App.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            
            // Terms sections
            _buildTermSection(
              title: '1. Acceptance of Terms',
              content: 'By accessing or using the FitBeast app, you agree to be bound by these Terms. If you disagree with any part of the terms, you may not access the app.',
            ),
            
            _buildTermSection(
              title: '2. User Account',
              content: 'You must provide accurate information when creating an account and keep it updated. You are responsible for maintaining the confidentiality of your account credentials.',
            ),
            
            _buildTermSection(
              title: '3. Privacy Policy',
              content: 'Your use of the app is also governed by our Privacy Policy, which explains how we collect, use, and protect your personal information.',
            ),
            
            _buildTermSection(
              title: '4. Health Disclaimer',
              content: 'FitBeast is not a medical app. The health and fitness information provided is for general informational purposes only and should not be considered medical advice.',
            ),
            
            _buildTermSection(
              title: '5. User Responsibilities',
              content: 'You agree to use the app only for lawful purposes and in ways that do not infringe the rights of others or restrict their use of the app.',
            ),
            
            _buildTermSection(
              title: '6. Intellectual Property',
              content: 'All content, features, and functionality of the app are the exclusive property of FitBeast and are protected by copyright and other intellectual property laws.',
            ),
            
            _buildTermSection(
              title: '7. Limitation of Liability',
              content: 'FitBeast will not be liable for any indirect, incidental, special, or consequential damages resulting from your use of the app.',
            ),
            
            _buildTermSection(
              title: '8. Changes to Terms',
              content: 'We reserve the right to modify these terms at any time. Your continued use of the app after such changes constitutes your acceptance of the new terms.',
            ),
            
            const SizedBox(height: 24),
            const Text(
              'If you have any questions about these Terms, please contact us at support@fitbeast.app',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTermSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}