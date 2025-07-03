import 'package:fitbeast/features/post_reg_onboarding/controller/post_reg_onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitbeast/core/theme/color_theme.dart';
import 'package:fitbeast/core/theme/text_theme.dart';

class FitnessGoalsView extends GetView<PostRegOnboardingController> {
  const FitnessGoalsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(theme),
                const SizedBox(height: 40),

                // Primary Goal
                _buildGoalSection(theme),
                const SizedBox(height: 24),

                // Activity Level
                _buildActivitySection(theme),
                const SizedBox(height: 24),

                // Workout Days
                _buildWorkoutDaysSection(theme),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fitness Goals',
          style: AppTextTheme.displaySmall
              .copyWith(color: theme.textTheme.bodyLarge?.color),
        ),
        const SizedBox(height: 8),
        Text(
          'Set your targets for personalized plans',
          style: AppTextTheme.bodyMedium.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withAlpha(150),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Primary Goal',
          style: AppTextTheme.titleMedium
              .copyWith(color: theme.textTheme.bodyLarge?.color),
        ),
        const SizedBox(height: 12),
        Obx(() => SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'weightLoss',
                  label: Text('Lose Weight'),
                  icon: Icon(Icons.trending_down),
                ),
                ButtonSegment(
                  value: 'muscleGain',
                  label: Text('Gain Muscle'),
                  icon: Icon(Icons.trending_up),
                ),
                ButtonSegment(
                  value: 'maintenance',
                  label: Text('Maintain'),
                  icon: Icon(Icons.trending_flat),
                ),
              ],
              selected: {controller.fitnessGoal.value},
              onSelectionChanged: (newSelection) {
                controller.fitnessGoal.value = newSelection.first;
              },
              style: _segmentedButtonStyle(theme),
            )),
      ],
    );
  }

  ButtonStyle _segmentedButtonStyle(ThemeData theme) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return theme.cardColor.withAlpha(25);
      }),
      side: WidgetStateProperty.all(BorderSide(
        color: theme.dividerColor.withAlpha(130),
      )),
      textStyle: WidgetStateProperty.all(AppTextTheme.labelMedium),
    );
  }

  Widget _buildActivitySection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activity Level',
          style: AppTextTheme.titleMedium
              .copyWith(color: theme.textTheme.bodyLarge?.color),
        ),
        const SizedBox(height: 12),
        Obx(() => DropdownButtonFormField<String>(
              value: controller.activityLevel.value,
              items: const [
                DropdownMenuItem(
                  value: 'Beginner',
                  child: Text('Beginner (little/no exercise)'),
                ),
               
                DropdownMenuItem(
                  value: 'Intermediate',
                  child: Text('Intermediate (3-5 days/week)'),
                ),
                DropdownMenuItem(
                  value: 'Advanced',
                  child: Text('Advanced (6-7 days/week)'),
                ),
              ],
              onChanged: (value) => controller.activityLevel.value = value!,
              dropdownColor: theme.cardColor,
              style: AppTextTheme.bodyMedium
                  .copyWith(color: theme.textTheme.bodyMedium?.color),
              decoration: InputDecoration(
                filled: true,
                fillColor: theme.cardColor.withAlpha(25),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildWorkoutDaysSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Target Workout Days/Week',
          style: AppTextTheme.titleMedium
              .copyWith(color: theme.textTheme.bodyLarge?.color),
        ),
        const SizedBox(height: 12),
        Obx(() => Column(
              children: [
                Slider(
                  value: controller.workoutDays.value.toDouble(),
                  min: 1,
                  max: 7,
                  divisions: 6,
                  label: '${controller.workoutDays.value} days',
                  onChanged: (value) =>
                      controller.workoutDays.value = value.toInt(),
                  activeColor: AppColors.primary,
                  inactiveColor: theme.dividerColor.withAlpha(50),
                ),
                Text(
                  '${controller.workoutDays.value} days per week',
                  style: AppTextTheme.bodyMedium,
                ),
              ],
            )),
      ],
    );
  }
}
