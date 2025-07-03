import 'package:fitbeast/features/post_reg_onboarding/controller/post_reg_onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitbeast/core/theme/color_theme.dart';
import 'package:fitbeast/core/theme/text_theme.dart';
import 'package:fitbeast/core/utils/custom_textfield.dart';

class HealthProfileView extends GetView<PostRegOnboardingController> {
  const HealthProfileView({super.key});

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

                // Medical Conditions
                _buildConditionsSection(theme),
                const SizedBox(height: 24),

                // Medications
                _buildMedicationsField(),
                const SizedBox(height: 20),

                // Injuries
                _buildInjuriesField(),
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
          'Health Profile',
          style: AppTextTheme.displaySmall
              .copyWith(color: theme.textTheme.bodyLarge?.color),
        ),
        const SizedBox(height: 8),
        Text(
          'Help us customize your experience safely',
          style: AppTextTheme.bodyMedium.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withAlpha(150),
          ),
        ),
      ],
    );
  }

  Widget _buildConditionsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Any medical conditions?',
          style: AppTextTheme.titleMedium
              .copyWith(color: theme.textTheme.bodyLarge?.color),
        ),
        const SizedBox(height: 12),
        Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.medicalConditions.map((condition) {
                return ChoiceChip(
                  label: Text(condition),
                  selected: controller.selectedConditions.contains(condition),
                  onSelected: (selected) =>
                      controller.toggleCondition(condition),
                  selectedColor: AppColors.primary,
                  labelStyle: AppTextTheme.labelMedium.copyWith(
                    color: controller.selectedConditions.contains(condition)
                        ? Colors.black
                        : theme.textTheme.bodyMedium?.color,
                  ),
                  backgroundColor: theme.cardColor.withAlpha(25),
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: theme.dividerColor.withAlpha(130),
                    ),
                  ),
                );
              }).toList(),
            )),
      ],
    );
  }

  Widget _buildMedicationsField() {
    return buildFitTextField(
      context: Get.context!,
      controller: controller.medicationsController,
      labelText: 'Medications affecting fitness (optional)',
      prefixIcon: Icons.medication,
    );
  }

  Widget _buildInjuriesField() {
    return buildFitTextField(
      context: Get.context!,
      controller: controller.injuriesController,
      labelText: 'Previous injuries (optional)',
      prefixIcon: Icons.healing,
    );
  }
}
