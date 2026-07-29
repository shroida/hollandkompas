import 'package:flutter/material.dart';

class AppTextTheme {
  static TextTheme get textTheme {
    return const TextTheme(
      headlineLarge: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 32,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}