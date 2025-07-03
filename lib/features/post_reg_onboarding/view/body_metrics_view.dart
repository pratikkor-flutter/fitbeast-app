import 'package:fitbeast/core/theme/color_theme.dart';
import 'package:fitbeast/features/post_reg_onboarding/controller/post_reg_onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitbeast/core/theme/text_theme.dart';
import 'package:fitbeast/core/utils/custom_textfield.dart';

class BodyMetricsView extends GetView<PostRegOnboardingController> {
  const BodyMetricsView({super.key});

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

                // Age Input
                _buildAgeField(),
                const SizedBox(height: 20),

                // Gender Input
                _buildGoalSection(theme),
                const SizedBox(height: 20),

                // Height Input
                _buildHeightField(),
                const SizedBox(height: 20),

                // Weight Input
                _buildWeightField(),
                const SizedBox(height: 20),

                // Goal Weight (Optional)
                _buildGoalWeightField(),
                const SizedBox(height: 20),

                // Body Fat % (Optional)
                _buildBodyFatField(),
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
          'Body Metrics',
          style: AppTextTheme.displaySmall
              .copyWith(color: theme.textTheme.bodyLarge?.color),
        ),
        const SizedBox(height: 8),
        Text(
          'Let us know your physical stats for better recommendations',
          style: AppTextTheme.bodyMedium.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withAlpha(150),
          ),
        ),
      ],
    );
  }

  Widget _buildAgeField() {
    return Obx(() => buildFitTextField(
          context: Get.context!,
          controller: controller.ageController,
          labelText: 'Age (yrs)',
          prefixIcon: Icons.date_range_rounded,
          keyboardType: TextInputType.number,
          errorText: controller.ageError.value,
          onChanged: (value) => controller.validateBodyMetrics(),
        ));
  }

  Widget _buildGoalSection(ThemeData theme) {
    return Obx(() => SegmentedButton<String>(
          segments: const [
            ButtonSegment(
              value: 'Male',
              label: Text('Male'),
              icon: Icon(Icons.male),
              tooltip: 'Selected gender is Male',
            ),
            ButtonSegment(
              value: 'Female',
              label: Text('Female'),
              icon: Icon(Icons.female),
              tooltip: 'Selected gender is Female',
            ),
            ButtonSegment(
              value: 'other',
              label: Text('Other'),
              icon: Icon(Icons.all_inclusive),
              tooltip: 'Selected gender is Other',
            ),
          ],
          selected: {controller.gender.value},
          onSelectionChanged: (newSelection) {
            controller.gender.value = newSelection.first;
          },
          style: _segmentedButtonStyle(theme),
        ));
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

  Widget _buildHeightField() {
    return Obx(() => buildFitTextField(
          context: Get.context!,
          controller: controller.heightController,
          labelText: 'Height (cm)',
          prefixIcon: Icons.height,
          keyboardType: TextInputType.number,
          errorText: controller.heightError.value,
          onChanged: (value) => controller.validateBodyMetrics(),
        ));
  }

  Widget _buildWeightField() {
    return Obx(() => buildFitTextField(
          context: Get.context!,
          controller: controller.weightController,
          labelText: 'Weight (kg)',
          prefixIcon: Icons.monitor_weight,
          keyboardType: TextInputType.number,
          errorText: controller.weightError.value,
          onChanged: (value) => controller.validateBodyMetrics(),
        ));
  }

  Widget _buildGoalWeightField() {
    return buildFitTextField(
      context: Get.context!,
      controller: controller.goalWeightController,
      labelText: 'Goal Weight (kg) - Optional',
      prefixIcon: Icons.flag,
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildBodyFatField() {
    return buildFitTextField(
      context: Get.context!,
      controller: controller.bodyFatController,
      labelText: 'Body Fat % - Optional',
      prefixIcon: Icons.pie_chart,
      keyboardType: TextInputType.number,
    );
  }
}
