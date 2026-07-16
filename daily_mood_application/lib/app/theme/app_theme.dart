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
      scaffoldBackgroundColor: const Color(0xFFFAF5FF),

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryPurple,
        brightness: Brightness.light,
        primary: AppColors.primaryPurple,
        secondary: AppColors.lavender,
        tertiary: AppColors.pink,
        error: AppColors.accentRed,
        surface: Colors.white,
        surfaceContainerHighest: const Color(0xFFF7F3FD),
        outlineVariant: const Color(0xFFEFE7FC),
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

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTypography.fontFamily,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.darkPrimaryPurple,
        brightness: Brightness.dark,
        primary: AppColors.darkPrimaryPurple,
        secondary: AppColors.darkLavender,
        tertiary: AppColors.darkPink,
        error: const Color(0xFFFF8A8A),
        surface: AppColors.darkSurface,
        surfaceContainerHighest: AppColors.darkSurfaceVariant,
        outlineVariant: AppColors.darkDivider,
      ),
      textTheme: TextTheme(
        headlineLarge: AppTypography.heading1.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        headlineSmall: AppTypography.heading2.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        titleMedium: AppTypography.heading3.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        bodyLarge: AppTypography.subText1Regular.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        bodyMedium: AppTypography.subText2Regular.copyWith(
          color: AppColors.darkTextSecondary,
        ),
        bodySmall: AppTypography.subText3Regular.copyWith(
          color: AppColors.darkTextTertiary,
        ),
        labelLarge: AppTypography.subText1Medium.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        labelMedium: AppTypography.subText2Medium.copyWith(
          color: AppColors.darkTextSecondary,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        foregroundColor: AppColors.darkTextPrimary,
        titleTextStyle: AppTypography.heading2.copyWith(
          color: AppColors.darkTextPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimaryPurple,
          foregroundColor: AppColors.darkBackground,
          textStyle: AppTypography.subText1Medium,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.darkPrimaryPurple,
          textStyle: AppTypography.subText1Medium,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceVariant,
        hintStyle: AppTypography.subText2Regular.copyWith(
          color: AppColors.darkTextTertiary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkDivider,
        thickness: 1,
      ),
    );
  }
}
