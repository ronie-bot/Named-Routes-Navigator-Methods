import 'package:flutter/material.dart';

/// Central color palette used throughout the app.
class AppColors {
  AppColors._();

  static const Color primaryBrown = Color(0xFF6F4E37);
  static const Color textDark = Color(0xFF2E2620);
  static const Color background = Color(0xFFFDFBF9);
}

/// App-wide ThemeData, built from AppColors.
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryBrown,
        primary: AppColors.primaryBrown,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: AppColors.textDark),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBrown,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.primaryBrown.withOpacity(0.04),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
