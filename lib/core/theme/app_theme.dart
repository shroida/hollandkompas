import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_theme.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Cairo',

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.card,
      error: AppColors.destructive,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.foreground,
      onError: Colors.white,
    ),

    scaffoldBackgroundColor: AppColors.background,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.foreground,
      elevation: 0,
      centerTitle: true,
    ),

    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),

    textTheme: AppTextTheme.textTheme,
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Cairo',

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.darkSecondary,
      surface: AppColors.darkCard,
      error: AppColors.destructive,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.darkForeground,
      onError: Colors.white,
    ),

    scaffoldBackgroundColor: AppColors.darkBackground,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.darkForeground,
      elevation: 0,
    ),

    cardTheme: CardThemeData(
      color: AppColors.darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),

    textTheme: AppTextTheme.textTheme.apply(
      bodyColor: AppColors.darkForeground,
      displayColor: AppColors.darkForeground,
    ),
  );
}