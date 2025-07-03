import 'package:fitbeast/core/theme/color_theme.dart';
import 'package:fitbeast/core/theme/text_theme.dart';
import 'package:fitbeast/features/post_reg_onboarding/controller/post_reg_onboarding_controller.dart';
import 'package:fitbeast/features/post_reg_onboarding/view/body_metrics_view.dart';
import 'package:fitbeast/features/post_reg_onboarding/view/fitness_goals_view.dart';
import 'package:fitbeast/features/post_reg_onboarding/view/health_profile_view.dart';
import 'package:fitbeast/features/post_reg_onboarding/widgets/onboarding_progress_bar.dart';
import 'package:fitbeast/widgets/button_variants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostRegOnboardingView extends StatelessWidget {
  final PostRegOnboardingController controller = Get.find();

  PostRegOnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Obx(() => OnboardingProgressBar(
              progress: controller.completionProgress.value,
            )),
        actions: [
          TextButton(
            onPressed: controller.skipOnboarding,
            child: Text(
              'Skip',
              style: AppTextTheme.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: PageView(
          controller: controller.pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            BodyMetricsView(),
            HealthProfileView(),
            FitnessGoalsView(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              if (controller.currentScreenIndex.value > 0)
                Expanded(
                  child: ButtonVariants.secondary(
                    onPressed: controller.previousScreen,
                    text: 'Back',
                  ),
                ),
              if (controller.currentScreenIndex.value > 0)
                const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ButtonVariants.primary(
                  onPressed: () async => await controller.nextScreen(),
                  text: controller.currentScreenIndex.value ==
                          controller.totalScreens - 1
                      ? 'Complete'
                      : 'Next',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
