import 'package:fitbeast/core/theme/text_theme.dart';
import 'package:fitbeast/core/utils/custom_textfield.dart';
import 'package:fitbeast/features/auth/controller/auth_controller.dart';
import 'package:fitbeast/features/auth/widgets/social_auth_button.dart';
import 'package:fitbeast/routes/app_routes.dart';
import 'package:fitbeast/widgets/button_variants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  final AuthController controller = Get.find<AuthController>();

  LoginView({super.key});

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

                // Email Field
                _buildEmailField(),
                const SizedBox(height: 20),

                // Password Field
                _buildPasswordField(),
                const SizedBox(height: 10),

                // Forgot Password
                _buildForgotPassword(),
                const SizedBox(height: 30),

                // Login Button
                _buildLoginButton(),
                const SizedBox(height: 30),

                // // Divider
                // _buildDivider(),
                // const SizedBox(height: 30),

                // // Social Auth
                // _buildSocialAuth(),
                // const SizedBox(height: 20),

                // Signup Redirect
                _buildSignupRedirect(),
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
          'Welcome Back',
          style: AppTextTheme.displaySmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Log in to continue your fitness journey',
          style: AppTextTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Obx(() => buildFitTextField(
          context: Get.context!,
          controller: controller.emailController,
          labelText: 'Email',
          errorText: controller.emailError.value,
          prefixIcon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) => controller.validateInputs(),
        ));
  }

  Widget _buildPasswordField() {
    return Obx(() => buildFitTextField(
          context: Get.context!,
          controller: controller.passwordController,
          labelText: 'Password',
          errorText: controller.passwordError.value,
          prefixIcon: Icons.lock,
          obscureText: !controller.showPassword.value,
          suffixIcon: IconButton(
            icon: Icon(
              controller.showPassword.value
                  ? Icons.visibility
                  : Icons.visibility_off,
            ),
            onPressed: controller.togglePasswordVisibility,
          ),
          onChanged: (value) => controller.validateInputs(),
          keyboardType: TextInputType.visiblePassword,
        ));
  }

  Widget _buildForgotPassword() {
    final contextTheme = Theme.of(Get.context!);
    final primaryColor = contextTheme.colorScheme.primary;

    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        // TODO: replace this route by forgot password view
        onPressed: () => Get.toNamed(Routes.login),
        child: Text(
          'Forgot Password?',
          style: contextTheme.textTheme.labelMedium?.copyWith(
            color: primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Obx(
      () => ButtonVariants.primary(
        onPressed: () => controller.isLoading.value ? null : controller.login(),
        text: 'Log In',
        width: double.infinity,
        isLoading: controller.isLoading.value,
      ),
    );
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

  Widget _buildSignupRedirect() {
    final contextTheme = Theme.of(Get.context!);
    final textColor = contextTheme.textTheme.bodyMedium?.color?.withAlpha(180);
    final primaryColor = contextTheme.colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'New to FitBeast? ',
          style: contextTheme.textTheme.bodyMedium?.copyWith(color: textColor),
        ),
        TextButton(
          onPressed: () {
            controller.clearLoginController();
            Get.toNamed(Routes.register);
          },
          child: Text(
            'Create Account',
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
