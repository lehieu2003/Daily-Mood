import 'package:flutter/material.dart';

/// Design tokens — Colors
/// Source: style_guide.md v1.1
///
/// NOTE: A few values in the source guide are flagged as unconfirmed.
/// They are implemented here exactly as written, with TODOs so the
/// discrepancy isn't lost once it's wired into code.
class AppColors {
  AppColors._();

  // ---------------------------------------------------------------------
  // 1.1 UI Colors
  // ---------------------------------------------------------------------
  static const Color primaryPurple = Color(0xFF8B4CFC); // 100%
  static const Color pink = Color(0xFFFAD9E6); // 100%
  static const Color lavender = Color(0xFFDED7FA); // 100%

  // ---------------------------------------------------------------------
  // 1.2 Chart Colors — always used at 75% opacity per the guide.
  // ---------------------------------------------------------------------
  // TODO: #22C55E is the proposed replacement for the original export,
  // where "Green" incorrectly duplicated primaryPurple (#8B4CFC).
  // Confirm the final chart green with design before shipping analytics.
  static const Color chartGreen = Color(
    0xFF22C55E,
  ); // 75% — pending design confirmation
  static const Color chartRed = Color(0xFFFF1F11); // 75%
  static const Color chartBlue = Color(0xFF3686FF); // 75%
  static const Color chartOrange = Color(0xFFFF5C00); // 75%

  static const double chartOpacity = 0.75;

  /// Convenience list for iterating chart colors (already at 75% opacity).
  static List<Color> get chartPalette => [
    chartGreen.withValues(alpha: chartOpacity),
    chartRed.withValues(alpha: chartOpacity),
    chartBlue.withValues(alpha: chartOpacity),
    chartOrange.withValues(alpha: chartOpacity),
  ];

  // ---------------------------------------------------------------------
  // 1.3 Text Colors
  // All three text levels derive from the same base (#100F11) at
  // different opacities — per the guide, don't invent separate greys.
  // ---------------------------------------------------------------------
  static const Color _textBase = Color(0xFF100F11);

  static Color get textPrimary => _textBase.withValues(alpha: 1.0); // 100%
  static Color get textSecondary => _textBase.withValues(alpha: 0.74); // 74%
  static Color get textTertiary => _textBase.withValues(alpha: 0.64); // 64%
  // TODO: WCAG AA contrast for textTertiary (64%) against real
  // backgrounds is flagged as unverified in the guide — check before
  // using it for anything except placeholders/captions on light bg.

  static const Color accentYellow = Color(0xFFE8B50E); // 100%
  static const Color accentRed = Color(0xFFFC4C4C); // 100%

  static const Color navSurface = Color(0xFFF9FCFF);
  static const Color navActiveSurface = Color(0xFF005A76);
  static const Color navActiveItem = primaryPurple;
  static const Color navInactiveItem = Color(0xFF5F646B);

  // ---------------------------------------------------------------------
  // 1.4 Gradients
  // Intended for decorative surfaces (cards, hero sections) only —
  // per the guide, avoid using gradients as a background behind text.
  // ---------------------------------------------------------------------

  // TODO: Gradient 1 has two identical stops (#EED3F2 100% -> #EED3F2
  // 100%) in the source guide. Confirm with design whether this is
  // intentionally a "solid color stored as a 2-stop gradient" or a
  // stop was lost on export. Implemented as-is below.
  static const LinearGradient gradient1 = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFEED3F2), // 100%
      Color(0xFFEED3F2), // 100%
    ],
  );

  static const LinearGradient gradient2 = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFC3FFD4), // 100%
      Color(0xFFCFCCFB), // 100%
      Color(0xFFEFF9F2), // 100%
    ],
  );

  static final LinearGradient gradient3 = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      const Color(0xFFBACFFF).withValues(alpha: 0.67),
      const Color(0xFFFFCEB7).withValues(alpha: 1.0),
    ],
  );

  static final LinearGradient gradient4 = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      const Color(0xFFD0CFE9).withValues(alpha: 0.34),
      const Color(0xFFFFCEB7).withValues(alpha: 1.0),
      const Color(0xFFDF2771).withValues(alpha: 0.55),
      const Color(0xFFBAE6FF).withValues(alpha: 0.67),
    ],
  );
}
