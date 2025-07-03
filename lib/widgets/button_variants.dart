import 'package:fitbeast/core/theme/color_theme.dart';
import 'package:fitbeast/widgets/custom_button.dart';
import 'package:flutter/material.dart';

extension ButtonVariants on CustomButton {
  static CustomButton primary({
    required VoidCallback onPressed,
    required String text,
    double? width,
    bool isLoading = false,
    bool isDisabled = false,
  }) {
    return CustomButton(
      onPressed: onPressed,
      text: text,
      gradient: AppColors.primaryGradient,
      width: width,
      isLoading: isLoading,
      isDisabled: isDisabled,
    );
  }

  static CustomButton secondary({
    required VoidCallback onPressed,
    required String text,
    double? width,
    bool isLoading = false,
    bool isDisabled = false,
  }) {
    return CustomButton(
      onPressed: onPressed,
      text: text,
      color: Colors.transparent,
      textColor: AppColors.primary,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      showShadow: false,
      isLoading: isLoading,
      isDisabled: isDisabled,
    );
  }
}
