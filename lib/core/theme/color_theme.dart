import 'package:flutter/material.dart';

class AppColors {
  // common color
  static const Color accentBlue = Colors.blueAccent;
  static const Color accentPurple = Colors.deepPurple;
  static const Color accentGreen = Colors.greenAccent;

  static Color withAlpha(Color color, int alpha) => color.withAlpha(alpha);

  // Dark Theme Colors
  static const Color primary = Color(0xFFFFD600);
  static const Color secondary = Color(0xFF00C853);
  static const Color error = Color(0xFFFF5252);
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color onPrimary = Colors.black;
  static const Color onSurface = Colors.white;
  static const Color onSurfaceSmooth = Colors.white12;

  // Light Theme Colors
  static const Color primaryLight = Color(0xFFFFAB00);
  static const Color secondaryLight = Color(0xFF00B248);
  static const Color errorLight = Color(0xFFD32F2F);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color surfaceLight = Colors.white;
  static const Color onPrimaryLight = Colors.white;
  static const Color onSurfaceLight = Color(0xFF212121);
  static const Color onSurfaceLightSmooth = Colors.black26;

  static const Gradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFFD600), Color(0xFFFFAB00)],
    stops: [0, 1],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient dangerGradient = LinearGradient(
    colors: [Color(0xFFFF5252), Color(0xFFD32F2F)],
    stops: [0, 1],
  );
}

class DarkColorScheme {
  static const ColorScheme scheme = ColorScheme.dark(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    error: AppColors.error,
    surface: AppColors.surface,
    onPrimary: AppColors.onPrimary,
    onSurface: AppColors.onSurface,
  );
}

class LightColorScheme {
  static const ColorScheme scheme = ColorScheme.light(
    primary: AppColors.primaryLight,
    secondary: AppColors.secondaryLight,
    error: AppColors.errorLight,
    surface: AppColors.surfaceLight,
    onPrimary: AppColors.onPrimaryLight,
    onSurface: AppColors.onSurfaceLight,
  );
}
