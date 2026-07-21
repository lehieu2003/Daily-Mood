import 'package:flutter/material.dart';

class QuickLogTheme {
  const QuickLogTheme._({
    required this.outerBackground,
    required this.panelGradient,
    required this.cardColor,
    required this.subtleCardColor,
    required this.primaryText,
    required this.secondaryText,
    required this.tertiaryText,
    required this.outline,
  });

  final Color outerBackground;
  final LinearGradient panelGradient;
  final Color cardColor;
  final Color subtleCardColor;
  final Color primaryText;
  final Color secondaryText;
  final Color tertiaryText;
  final Color outline;

  factory QuickLogTheme.of(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDark) {
      return QuickLogTheme._(
        outerBackground: colorScheme.surface,
        panelGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorScheme.surface, colorScheme.surfaceContainerHighest],
        ),
        cardColor: colorScheme.surfaceContainerHighest,
        subtleCardColor: colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.72,
        ),
        primaryText: colorScheme.onSurface,
        secondaryText: colorScheme.onSurfaceVariant,
        tertiaryText: colorScheme.onSurfaceVariant.withValues(alpha: 0.72),
        outline: colorScheme.outlineVariant.withValues(alpha: 0.56),
      );
    }

    return QuickLogTheme._(
      outerBackground: const Color(0xFF3F3F3F),
      panelGradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFEAF8FA), Color(0xFFFDF9FF)],
      ),
      cardColor: colorScheme.surface,
      subtleCardColor: colorScheme.surface.withValues(alpha: 0.82),
      primaryText: colorScheme.onSurface,
      secondaryText: colorScheme.onSurfaceVariant,
      tertiaryText: colorScheme.onSurfaceVariant.withValues(alpha: 0.76),
      outline: colorScheme.outlineVariant.withValues(alpha: 0.36),
    );
  }
}
