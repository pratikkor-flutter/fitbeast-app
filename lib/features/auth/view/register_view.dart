import 'package:fitbeast/core/theme/color_theme.dart';
import 'package:fitbeast/core/theme/text_theme.dart';
import 'package:fitbeast/core/utils/custom_textfield.dart';
import 'package:fitbeast/features/auth/controller/auth_controller.dart';
import 'package:fitbeast/features/auth/widgets/social_auth_button.dart';
import 'package:fitbeast/routes/app_routes.dart';
import 'package:fitbeast/widgets/button_variants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterView extends StatelessWidget {
  final AuthController controller = Get.find();

  RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(),
                const SizedBox(height: 40),

                // Full Name
                _buildDisplayNameField(),
                const SizedBox(height: 20),

                // Username
                _buildUsernameField(),
                const SizedBox(height: 20),

                // Email Field
                _buildEmailField(),
                const SizedBox(height: 20),

                // Password Field
                _buildPasswordField(),
                const SizedBox(height: 20),

                // Confirm Password
                _buildConfirmPasswordField(),
                const SizedBox(height: 30),

                // Terms Checkbox
                _buildTermsCheckbox(),
                const SizedBox(height: 30),

                // Register Button
                _buildRegisterButton(),
                const SizedBox(height: 30),

                // // Divider
                // _buildDivider(),
                // const SizedBox(height: 30),

                // // Social Auth
                // _buildSocialAuth(),
                // const SizedBox(height: 20),

                // Login Redirect
                _buildLoginRedirect(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create Account',
          style: AppTextTheme.displaySmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Start your fitness journey with us',
          style: AppTextTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildDisplayNameField() {
    return Obx(() => buildFitTextField(
          context: Get.context!,
          controller: controller.nameController,
          labelText: 'Your Name',
          prefixIcon: Icons.person,
          errorText: controller.nameError.value,
          onChanged: (value) => controller.validateInputs(isLogin: false),
        ));
  }

  Widget _buildUsernameField() {
    return Obx(() => buildFitTextField(
          context: Get.context!,
          controller: controller.usernameController,
          labelText: 'Username',
          prefixIcon: Icons.person_search_rounded,
          errorText: controller.usernameError.value,
          onChanged: (value) => controller.validateInputs(isLogin: false),
        ));
  }

  Widget _buildEmailField() {
    return Obx(() => buildFitTextField(
          context: Get.context!,
          controller: controller.emailController,
          labelText: 'Email',
          prefixIcon: Icons.email,
          errorText: controller.emailError.value,
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) => controller.validateInputs(isLogin: false),
        ));
  }

  Widget _buildPasswordField() {
    return Obx(() => buildFitTextField(
          context: Get.context!,
          controller: controller.passwordController,
          labelText: 'Password',
          prefixIcon: Icons.lock,
          errorText: controller.passwordError.value,
          obscureText: !controller.showPassword.value,
          suffixIcon: IconButton(
            icon: Icon(
              controller.showPassword.value
                  ? Icons.visibility
                  : Icons.visibility_off,
            ),
            onPressed: controller.togglePasswordVisibility,
          ),
          onChanged: (value) => controller.validateInputs(isLogin: false),
        ));
  }

  Widget _buildConfirmPasswordField() {
    return Obx(() => buildFitTextField(
          context: Get.context!,
          controller: controller.confirmPasswordController,
          labelText: 'Confirm Password',
          prefixIcon: Icons.lock_outline,
          errorText: controller.confirmPasswordError.value,
          obscureText: !controller.showConfirmPassword.value,
          suffixIcon: IconButton(
            icon: Icon(
              controller.showConfirmPassword.value
                  ? Icons.visibility
                  : Icons.visibility_off,
            ),
            onPressed: controller.toggleConfirmPasswordVisibility,
          ),
          onChanged: (value) => controller.validateInputs(isLogin: false),
        ));
  }

  Widget _buildTermsCheckbox() {
    final labelColor =
        Theme.of(Get.context!).textTheme.bodyMedium?.color?.withAlpha(150);
    return Obx(() => Row(
          children: [
            Checkbox(
              value: controller.acceptTerms.value,
              onChanged: (value) {
                controller.acceptTerms.value = value ?? false;
                controller.validateInputs(isLogin: false);
              },
              fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.primary;
                }
                return Colors.transparent;
              }),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: BorderSide(
                  color: controller.termsError.value.isNotEmpty
                      ? AppColors.error
                      : labelColor!,
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                // TODO: to develop terms & conditions view
                onTap: () => Get.toNamed(Routes.termsAndConditions),
                child: Text(
                  'I agree to Terms & Conditions',
                  style: AppTextTheme.bodyMedium.copyWith(
                    color: controller.termsError.value.isNotEmpty
                        ? AppColors.error
                        : labelColor!,
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildRegisterButton() {
    return Obx(() => ButtonVariants.primary(
          onPressed: () =>
              controller.isLoading.value ? null : controller.register(),
          text: 'Create Account',
          width: double.infinity,
          isLoading: controller.isLoading.value,
        ));
  }

  Widget _buildDivider() {
    final dividerColor = Theme.of(Get.context!).dividerColor;
    final labelStyle = Theme.of(Get.context!).textTheme.labelMedium?.copyWith(
          color: Theme.of(Get.context!)
              .textTheme
              .bodyMedium
              ?.color
              ?.withAlpha(100),
        );

    return Row(
      children: [
        Expanded(child: Divider(color: dividerColor)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text('OR', style: labelStyle),
        ),
        Expanded(child: Divider(color: dividerColor)),
      ],
    );
  }

  Widget _buildSocialAuth() {
    final labelColor =
        Theme.of(Get.context!).textTheme.bodyMedium?.color?.withAlpha(150);
    return Column(
      children: [
        Text(
          'Continue with social',
          style: Theme.of(Get.context!)
              .textTheme
              .labelMedium
              ?.copyWith(color: labelColor),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialAuthButton(
              icon: Icons.g_translate,
              onPressed: controller.signInWithGoogle,
            ),
            const SizedBox(width: 20),
            SocialAuthButton(
              icon: Icons.camera_alt,
              onPressed: controller.signInWithInstagram,
            ),
            const SizedBox(width: 20),
            SocialAuthButton(
              icon: Icons.chat,
              onPressed: controller.signInWithTwitter,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoginRedirect() {
    final contextTheme = Theme.of(Get.context!);
    final textColor = contextTheme.textTheme.bodyMedium?.color?.withAlpha(180);
    final primaryColor = contextTheme.colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: contextTheme.textTheme.bodyMedium?.copyWith(color: textColor),
        ),
        TextButton(
          onPressed: () => {
            controller.clearRegisterController(),
            Get.back(),
          },
          child: Text(
            'Log In',
            style: contextTheme.textTheme.labelMedium?.copyWith(
              color: primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
