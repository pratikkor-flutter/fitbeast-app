import 'package:fitbeast/core/theme/text_theme.dart';
import 'package:fitbeast/core/utils/custom_textfield.dart';
import 'package:fitbeast/features/more/controller/more_controller.dart';
import 'package:fitbeast/widgets/button_variants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApplyAsTrainerView extends StatelessWidget {
  ApplyAsTrainerView({super.key});

  final MoreController controller = Get.put(MoreController());
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Apply"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(theme),
              const SizedBox(height: 40),
              Obx(() => _buildTrainerNameField()),
              const SizedBox(height: 20),
              Obx(() => _buildSpecialityField()),
              const SizedBox(height: 20),
              Obx(() => _buildGymExperienceField()),
              const SizedBox(height: 20),
              Obx(() => _buildExperienceField()),
              const SizedBox(height: 30),
              Obx(() => ButtonVariants.primary(
                    onPressed: controller.submitTrainerApplication,
                    text: 'Submit Application',
                    isLoading: controller.isSubmitting.value,
                    width: double.infinity,
                  )),
            ],
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
          'Apply as a Trainer',
          style: AppTextTheme.displaySmall
              .copyWith(color: theme.textTheme.bodyLarge?.color),
        ),
        const SizedBox(height: 8),
        Text(
          'Let us know your professional and physical details.',
          style: AppTextTheme.bodyMedium.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withAlpha(150),
          ),
        ),
      ],
    );
  }

  Widget _buildTrainerNameField() {
    return buildFitTextField(
      context: Get.context!,
      controller: TextEditingController(text: controller.name.value),
      labelText: 'Name',
      prefixIcon: Icons.person,
    );
  }

  Widget _buildSpecialityField() {
    return buildFitTextField(
      context: Get.context!,
      controller: controller.specialityController,
      labelText: 'Speciality (e.g., CrossFit, Yoga)',
      prefixIcon: Icons.star,
      errorText: controller.specialityError.value,
      onChanged: (value) => controller.validate(),
    );
  }

  Widget _buildGymExperienceField() {
    return buildFitTextField(
      context: Get.context!,
      controller: controller.gymController,
      labelText: 'Gyms Worked In',
      prefixIcon: Icons.fitness_center,
      errorText: controller.gymError.value,
      onChanged: (value) => controller.validate(),
    );
  }

  Widget _buildExperienceField() {
    return buildFitTextField(
      context: Get.context!,
      controller: controller.experienceController,
      labelText: 'Experience (in years)',
      prefixIcon: Icons.work,
      keyboardType: TextInputType.number,
      errorText: controller.experienceError.value,
      onChanged: (value) => controller.validate(),
    );
  }
}
