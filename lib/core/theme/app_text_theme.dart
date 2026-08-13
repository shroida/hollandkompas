import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextTheme {
  static TextTheme get textTheme {
    return const TextTheme(
      headlineLarge: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.foreground,
      ),

      headlineMedium: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.foreground,
      ),

      bodyLarge: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: AppColors.foreground,
      ),

      bodyMedium: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.foreground,
      ),

      bodySmall: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.foreground,
      ),
    );
  }
}
