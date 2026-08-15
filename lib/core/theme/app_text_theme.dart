import 'package:flutter/material.dart';

class AppTextTheme {
  static TextTheme textTheme(Color textColor) {
    return TextTheme(
      headlineLarge: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),

      headlineMedium: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),

      bodyLarge: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),

      bodyMedium: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),

      bodySmall: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
    );
  }
}
