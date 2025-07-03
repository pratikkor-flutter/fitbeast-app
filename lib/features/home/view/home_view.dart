import 'package:fitbeast/core/theme/color_theme.dart';
import 'package:fitbeast/core/theme/text_theme.dart';
import 'package:fitbeast/features/home/controller/home_controller.dart';
import 'package:fitbeast/features/home/widgets/circular_avtar_widget.dart';
import 'package:fitbeast/features/home/widgets/gym_voucher_carousel.dart';
import 'package:fitbeast/features/home/widgets/progress_fill_icon.dart';
import 'package:fitbeast/features/home/widgets/sleep_quality_indicator.dart';
import 'package:fitbeast/features/home/widgets/today_progress_card.dart';
import 'package:fitbeast/features/home/widgets/water_frequency_indicator.dart';
import 'package:fitbeast/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),

              // Header with Greeting
              _buildHeader(),
              SizedBox(height: 24.h),

              // Today's Progress Card
              Obx(
                () => TodayProgressCard(
                  caloriesProgress: controller.caloriesProgress(),
                  waterProgress: controller.waterProgress(),
                  sleepProgress: controller.sleepProgress(),
                ),
              ),
              SizedBox(height: 12.h),
              // Gym Voucher Carousel
              GymVoucherCarousel(),
              SizedBox(height: 12.h),
              // Daily Progress Cards
              _buildProgressCards(context),
              SizedBox(height: 12.h),
              // Progress Icons
              _buildProgressFillIcons(),
              SizedBox(height: 12.h),

              // Log Progress Cards
              _buildLogProgressCards(context),

              // extra space below the main content, to be visible over navbar
              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good ${controller.timeOfDay.value}, ${controller.name.value}!',
                style: AppTextTheme.headlineSmall,
              ).animate().fadeIn(duration: 500.ms),
              Text(
                'Ready to conquer your goals today?',
                style: AppTextTheme.bodyMedium,
              ),
            ],
          ),
          InkWell(
            onTap: () => Get.toNamed(Routes.profile),
            child: CircularAvatarWithInitials(name: controller.name.value),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCards(BuildContext context) {
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(10),
              blurRadius: 20,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(width: 8),
                const Icon(Icons.local_fire_department_rounded,
                    color: AppColors.primary, size: 22),
                const SizedBox(width: 8),
                Text('Calories Goal',
                    style: AppTextTheme.labelLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: LinearProgressIndicator(
                value: controller.caloriesProgress(),
                backgroundColor:
                    Theme.of(Get.context!).colorScheme.onSurface.withAlpha(50),
                color: AppColors.secondary,
                minHeight: 8,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${controller.caloriesProgress()} / 100 kcal',
                    style: AppTextTheme.bodySmall.copyWith(
                      color: Theme.of(Get.context!)
                          .colorScheme
                          .onSurface
                          .withAlpha(180),
                    ),
                  ),
                  Text(
                    '${(controller.caloriesProgress() * 100).toStringAsFixed(0)}%',
                    style: AppTextTheme.labelSmall
                        .copyWith(color: AppColors.secondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                // Calories Intake
                Expanded(
                  child: _buildProgressCard(
                    context: context,
                    title: 'Calories In',
                    value: controller.caloriesIntake.value.toInt(),
                    target: controller.caloriesTarget.value.toInt(),
                    color: AppColors.primary,
                    icon: Icons.restaurant,
                    textColor: AppColors.primaryLight,
                  ),
                ),
                const SizedBox(width: 12),
                // Calories Burned
                Expanded(
                  child: _buildProgressCard(
                    context: context,
                    title: 'Calories Out',
                    value: controller.caloriesBurned.value.toInt(),
                    target: controller.caloriesBurnTarget.value.toInt(),
                    color: AppColors.secondary,
                    icon: Icons.directions_run,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard({
    required BuildContext context,
    required String title,
    required int value,
    required int target,
    required Color color,
    Color? textColor,
    required IconData icon,
  }) {
    final percentage = target > 0 ? (value / target).clamp(0.0, 1.0) : 0.0;

    return Card(
      color: Theme.of(context).colorScheme.onSurface.withAlpha(10),
      shadowColor: Theme.of(context).colorScheme.onSurface.withAlpha(10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(title, style: AppTextTheme.labelMedium),
              ],
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: percentage,
              backgroundColor:
                  Theme.of(context).colorScheme.onSurface.withAlpha(50),
              color: color,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$value / $target kcal',
                  style: AppTextTheme.bodySmall.copyWith(
                    color: Theme.of(Get.context!)
                        .colorScheme
                        .onSurface
                        .withAlpha(180),
                  ),
                ),
                Text(
                  '${(percentage * 100).toStringAsFixed(0)}%',
                  style: AppTextTheme.labelSmall
                      .copyWith(color: textColor ?? color),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().scale(duration: 300.ms);
  }

  Widget _buildProgressFillIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Obx(
          () => ProgressFillIcon(
            icon: Icons.water_drop,
            progress:
                (controller.waterIntake.value / controller.waterTarget.value),
            fillColor: AppColors.accentBlue,
            label: 'Water Level',
            onTap: controller.logWater,
          ),
        ),
        const SizedBox(width: 12),
        Obx(
          () => WaterFrequencyIndicator(
            frequency: controller.waterFrequency.value,
            targetFrequency: controller.waterFreqTarget.value,
            onTap: controller.logWater,
          ),
        ),
        const SizedBox(width: 12),
        Obx(
          () => ProgressFillIcon(
            icon: Icons.bedtime,
            progress:
                (controller.sleepHours.value / controller.sleepTarget.value),
            fillColor: AppColors.accentPurple,
            label: 'Sleep Hours',
            onTap: controller.logSleep,
          ),
        ),
        const SizedBox(width: 12),
        Obx(
          () => SleepQualityIndicator(
            quality: controller.sleepQuality.value,
            onTap: controller.logSleep,
          ),
        )
      ],
    );
  }

  Widget _buildLogProgressCards(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(10),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 8),
              const Icon(Icons.insights, color: AppColors.secondary, size: 22),
              const SizedBox(width: 8),
              Text("Log Today's Activity",
                  style: AppTextTheme.labelLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Meal Completion Card
              Obx(
                () => _buildCompletionCard(
                  context: context,
                  title: 'Fuel-Up',
                  isCompleted: controller.isMealDone.value,
                  onTap: controller.logMeal,
                  color: AppColors.primary,
                  icon: Icons.restaurant_menu,
                ),
              ),

              SizedBox(height: 8.h),

              // Workout Completion Card
              Obx(
                () => _buildCompletionCard(
                  context: context,
                  title: 'Workout',
                  isCompleted: controller.isWorkoutDone.value,
                  onTap: controller.logWorkout,
                  color: AppColors.secondary,
                  icon: Icons.fitness_center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionCard({
    required BuildContext context,
    required String title,
    required bool isCompleted,
    required VoidCallback onTap,
    required Color color,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 120,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface.withAlpha(10),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(10),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(height: 8),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 28, color: color),
                ),
                if (isCompleted)
                  const Positioned(
                    bottom: 4,
                    right: 4,
                    child: Icon(Icons.check_circle,
                        color: AppColors.secondary, size: 16),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: AppTextTheme.labelMedium,
              textAlign: TextAlign.center,
            ),
            Text(
              isCompleted ? 'Done' : 'Log it',
              style: AppTextTheme.bodySmall.copyWith(
                fontSize: 11,
                color: isCompleted
                    ? Colors.green
                    : Theme.of(context).colorScheme.onSurface.withAlpha(200),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ).animate().fadeIn().slideY(
            begin: 0.1,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
          ),
    );
  }
}
