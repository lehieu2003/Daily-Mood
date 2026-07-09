import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// App-wide ThemeData built from the design tokens in
/// app_colors.dart and app_typography.dart (style_guide.md v1.1).
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTypography.fontFamily,
      scaffoldBackgroundColor: Colors.white,

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryPurple,
        brightness: Brightness.light,
        primary: AppColors.primaryPurple,
        secondary: AppColors.lavender,
        tertiary: AppColors.pink,
        error: AppColors.accentRed,
        surface: Colors.white,
      ),

      // ---------------------------------------------------------------
      // Text theme — mapped from the heading / sub text scale.
      // Material's naming doesn't line up 1:1 with the guide's
      // Heading 1-3 / Sub text 1-3, so the mapping below is the closest
      // semantic fit; prefer using AppTypography.* directly wherever a
      // token match matters more than Material conventions.
      // ---------------------------------------------------------------
      textTheme: TextTheme(
        headlineLarge: AppTypography.heading1, // 24 / Bold
        headlineSmall: AppTypography.heading2, // 18 / Medium
        titleMedium: AppTypography.heading3, // 14 / Medium

        bodyLarge: AppTypography.subText1Regular, // 16 / Regular
        bodyMedium: AppTypography.subText2Regular, // 14 / Regular
        bodySmall: AppTypography.subText3Regular, // 12 / Regular

        labelLarge: AppTypography.subText1Medium, // 16 / Medium
        labelMedium: AppTypography.subText2Medium, // 14 / Medium
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        titleTextStyle: AppTypography.heading2,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryPurple,
          foregroundColor: Colors.white,
          textStyle: AppTypography.subText1Medium,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryPurple,
          textStyle: AppTypography.subText1Medium,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lavender.withValues(alpha: 0.3),
        hintStyle: AppTypography.subText2Regular.copyWith(
          color: AppColors.textTertiary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),

      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      dividerTheme: DividerThemeData(
        color: AppColors.textTertiary.withValues(alpha: 0.15),
        thickness: 1,
      ),
    );
  }

  // No dark theme is defined in the source style guide — add one here
  // if/when design provides dark-mode tokens.
}
