import 'package:fitbeast/core/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

class PostRegOnboardingSuccessView extends StatelessWidget {
  const PostRegOnboardingSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/success.json',
              width: 200,
              height: 200,
              frameBuilder: (context, child, composition) {
                return Animate(
                  effects: [
                    FadeEffect(duration: 500.ms),
                    const ScaleEffect(
                      begin: Offset(1, 1),
                      end: Offset(1.1, 1.1),
                      curve: Curves.easeInOut,
                    ),
                  ],
                  child: child,
                );
              },
            ),
            const SizedBox(height: 32),
            Text(
              'Profile Complete!',
              style: AppTextTheme.displaySmall.copyWith(
                color: Colors.white,
              ),
            )
                .animate()
                .fadeIn(delay: 300.ms)
                .slide(begin: const Offset(0, 0.2)),
            const SizedBox(height: 16),
            Text(
              'Redirecting to your dashboard...',
              style: AppTextTheme.bodyMedium.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
