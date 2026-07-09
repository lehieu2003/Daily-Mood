import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Design tokens — Typography
/// Source: style_guide.md v1.1
///
/// Inter is the primary product typeface. Add bundled font assets under
/// pubspec.yaml -> flutter -> fonts before shipping if the app must render
/// exactly the same on every platform.
class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Inter';

  static const List<String> _fallback = [
    'Plus Jakarta Sans',
    'Roboto',
    'Helvetica Neue',
    'Arial',
  ];

  // ---------------------------------------------------------------------
  // 2.2 Headings
  // ---------------------------------------------------------------------
  static TextStyle get heading1 => TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: _fallback,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle get heading2 => TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: _fallback,
    fontSize: 18,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.textPrimary,
  );

  static TextStyle get heading3 => TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: _fallback,
    fontSize: 14,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.textPrimary,
  );

  // ---------------------------------------------------------------------
  // 2.3 Body text
  // Each size supports multiple weights per the guide — exposed here as
  // Regular/Medium/Bold variants where the guide lists them as available.
  // ---------------------------------------------------------------------

  // Sub text 1 — 16px — Regular, Medium, Bold
  static TextStyle get subText1Regular => TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: _fallback,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle get subText1Medium =>
      subText1Regular.copyWith(fontWeight: FontWeight.w500);

  static TextStyle get subText1Bold =>
      subText1Regular.copyWith(fontWeight: FontWeight.bold);

  // Sub text 2 — 14px — Regular, Medium
  static TextStyle get subText2Regular => TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: _fallback,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle get subText2Medium =>
      subText2Regular.copyWith(fontWeight: FontWeight.w500);

  // Sub text 3 — 12px — Regular only
  static TextStyle get subText3Regular => TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: _fallback,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
  );
}
