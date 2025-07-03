import 'package:fitbeast/core/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showFitSnackbar(String message, {bool isError = false}) {
  Get.snackbar(
    isError ? 'Error..!' : 'Success...',
    message,
    colorText: AppColors.onPrimary,
    backgroundColor: isError ? AppColors.error : AppColors.primary,
    snackPosition: SnackPosition.TOP,
    margin: const EdgeInsets.all(16),
    borderRadius: 12,
  );
}
