import 'package:flutter/material.dart';
import 'color_theme.dart';
import 'text_theme.dart';

class AppTheme {
  static ThemeData darkTheme() {
    return ThemeData.dark().copyWith(
      colorScheme: DarkColorScheme.scheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: AppTextTheme.textTheme.apply(
        displayColor: AppColors.onSurface,
        bodyColor: AppColors.onSurface,
      ),
      dividerColor: AppColors.onSurfaceSmooth,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.background,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  static ThemeData lightTheme() {
    return ThemeData.light().copyWith(
      colorScheme: LightColorScheme.scheme,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      textTheme: AppTextTheme.textTheme.apply(
        displayColor: AppColors.onSurfaceLight,
        bodyColor: AppColors.onSurfaceLight,
      ),
      dividerColor: AppColors.onSurfaceLightSmooth,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.backgroundLight,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurfaceLight,
        ),
      ),
    );
  }
}
