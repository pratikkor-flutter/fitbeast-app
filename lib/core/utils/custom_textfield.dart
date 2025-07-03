import 'package:flutter/material.dart';
import 'package:fitbeast/core/theme/color_theme.dart';
import 'package:fitbeast/core/theme/text_theme.dart';

TextField buildFitTextField({
  required TextEditingController controller,
  required String labelText,
  String? errorText,
  bool obscureText = false,
  TextInputType keyboardType = TextInputType.text,
  ValueChanged<String>? onChanged,
  IconData? prefixIcon,
  Widget? suffixIcon,
  Color? fillColor,
  Color? textColor,
  Color? labelColor,
  Color? iconColor,
  double borderRadius = 8.0,
  int maxlines = 1,
  required BuildContext context,
}) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  return TextField(
    controller: controller,
    obscureText: obscureText,
    style: AppTextTheme.bodyLarge.copyWith(
      color: textColor ?? theme.textTheme.bodyLarge?.color,
    ),
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: labelColor ?? theme.textTheme.bodyMedium?.color?.withAlpha(180),
      ),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: iconColor ?? theme.iconTheme.color)
          : null,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor:
          fillColor ?? (isDark ? Colors.white.withAlpha(14) : Colors.black12),
      errorText: errorText?.isEmpty ?? true ? null : errorText,
      errorStyle: AppTextTheme.bodySmall.copyWith(
        color: AppColors.error,
      ),
      border: _inputBorder(borderRadius),
      focusedBorder: _inputBorder(borderRadius, color: AppColors.primaryLight),
      enabledBorder: _inputBorder(borderRadius),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 12,
      ),
    ),
    onChanged: onChanged,
    keyboardType: keyboardType,
    maxLines: maxlines,
  );
}

InputBorder _inputBorder(double radius, {Color? color}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(radius),
    borderSide: BorderSide(
      color: color ?? Colors.transparent,
      width: 1.5,
    ),
  );
}
