import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/app_typography.dart';
import '../../../domain/models/mood_entry.dart';
import '../dashboard_formatters.dart';
import 'dashboard_card_decoration.dart';
import 'soft_icon.dart';

class DashboardSummary extends StatelessWidget {
  const DashboardSummary({required this.entries, super.key});

  final List<MoodEntryModel> entries;

  @override
  Widget build(BuildContext context) {
    final average =
        entries
            .map((entry) => entry.moodScore)
            .fold<int>(0, (sum, score) => sum + score) /
        entries.length;
    final latest = entries.first;
    final l10n = context.l10n;

    return LayoutBuilder(
      builder: (context, constraints) {
        final useRow = constraints.maxWidth >= 620;
        final cards = [
          _MetricCard(
            label: l10n.recentAverage,
            value: average.toStringAsFixed(1),
            helper: localizedMoodLabel(average.round(), l10n),
            icon: Icons.insights_outlined,
          ),
          _MetricCard(
            label: l10n.lastCheckIn,
            value: localizedMoodLabel(latest.moodScore, l10n),
            helper: formatLocalizedEntryDate(latest.createdAt, l10n),
            icon: Icons.favorite_border,
          ),
        ];

        if (!useRow) {
          return Column(
            children: [cards[0], const SizedBox(height: 12), cards[1]],
          );
        }

        return Row(
          children: [
            Expanded(child: cards[0]),
            const SizedBox(width: 12),
            Expanded(child: cards[1]),
          ],
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.helper,
    required this.icon,
  });

  final String label;
  final String value;
  final String helper;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: dashboardCardDecoration(context),
      child: Row(
        children: [
          SoftIcon(icon: icon),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTypography.subText3Regular),
                const SizedBox(height: 6),
                Text(value, style: AppTypography.heading1),
                const SizedBox(height: 4),
                Text(helper, style: AppTypography.subText2Regular),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
