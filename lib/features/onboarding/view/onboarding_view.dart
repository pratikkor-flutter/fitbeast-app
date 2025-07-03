import 'package:fitbeast/core/theme/color_theme.dart';
import 'package:fitbeast/core/theme/text_theme.dart';
import 'package:fitbeast/features/onboarding/controller/onboarding_controller.dart';
import 'package:fitbeast/widgets/button_variants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            LiquidSwipe(
              pages: controller.onboardingPages,
              onPageChangeCallback: controller.onPageChanged,
              liquidController: controller.liquidController,
              slideIconWidget:
                  const Icon(Icons.arrow_back_ios, color: Colors.white),
              fullTransitionValue: 900,
              enableLoop: false,
              waveType: WaveType.liquidReveal,
              positionSlideIcon: 0.8,
              ignoreUserGestureWhileAnimating: true,
            ),

            // Skip Button
            Positioned(
                top: MediaQuery.of(context).padding.top + 20,
                right: 24,
                child: Obx(
                  () => AnimatedOpacity(
                    opacity: controller.showSkipButton.value ? 1.0 : 0.0,
                    duration: 300.ms,
                    child: InkWell(
                      onTap: controller.skipOnboarding,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Text(
                          "Skip",
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                )),

            // Bottom Content
            Positioned(
              bottom: 0,
              child: Container(
                width: context.width,
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withAlpha(75),
                      Colors.black.withAlpha(185),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    // Animated Title
                    Obx(() => AnimatedSwitcher(
                          duration: 300.ms,
                          child: Text(
                            controller.currentTitle,
                            key: ValueKey(controller.currentPageIndex.value),
                            style: AppTextTheme.headlineMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )),

                    const SizedBox(height: 16),

                    // Animated Subtitle
                    Obx(() => AnimatedSwitcher(
                          duration: 300.ms,
                          child: Text(
                            controller.currentSubtitle,
                            key: ValueKey(controller.currentPageIndex.value),
                            style: AppTextTheme.bodyLarge.copyWith(
                              color: Colors.white.withAlpha(225),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )),

                    const SizedBox(height: 32),

                    // Dots Indicator
                    Obx(() => AnimatedSmoothIndicator(
                          activeIndex: controller.currentPageIndex.value,
                          count: controller.onboardingPages.length,
                          effect: ExpandingDotsEffect(
                            dotWidth: 8,
                            dotHeight: 8,
                            spacing: 8,
                            activeDotColor: AppColors.primary,
                            dotColor: Colors.white.withAlpha(100),
                            expansionFactor: 3,
                          ),
                        )),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Get Started Button
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Obx(
                () => AnimatedSwitcher(
                  duration: 300.ms,
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: ScaleTransition(scale: anim, child: child),
                  ),
                  child: controller.isLastPage
                      ? Center(
                          child: ButtonVariants.primary(
                            onPressed: controller.completeOnboarding,
                            text: 'Get Started',
                            width: context.width * 0.8,
                          ),
                        )
                      : const SizedBox.shrink(key: ValueKey('empty')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
