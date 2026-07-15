import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../dashboard_palette.dart';

class DashboardEmptyState extends StatelessWidget {
  const DashboardEmptyState({required this.onLogMood, super.key});

  final VoidCallback onLogMood;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      key: const ValueKey('dashboard_empty_state'),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      decoration: BoxDecoration(
        color: DashboardPalette.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primaryPurple.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.gradient2,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryPurple.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: const ExcludeSemantics(
              child: Icon(
                Icons.self_improvement,
                size: 44,
                color: AppColors.primaryPurple,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(l10n.noMoodEntriesYet, style: AppTypography.heading1),
          const SizedBox(height: 8),
          Text(
            l10n.dashboardEmptyBody,
            textAlign: TextAlign.center,
            style: AppTypography.subText1Regular.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onLogMood,
            icon: const Icon(Icons.add),
            label: Text(l10n.addFirstMood),
          ),
        ],
      ),
    );
  }
}
