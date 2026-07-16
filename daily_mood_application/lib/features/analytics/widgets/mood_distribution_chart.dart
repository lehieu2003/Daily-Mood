import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../domain/models/mood_distribution_item.dart';
import '../../dashboard/dashboard_formatters.dart';

class MoodDistributionChart extends StatelessWidget {
  const MoodDistributionChart({required this.items, super.key});

  final List<MoodDistributionItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

    return Container(
      key: const ValueKey('mood_distribution_chart'),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.moodStatistics,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 18),
          if (items.isEmpty)
            _EmptyMoodDistribution(label: l10n.moodDistributionEmpty)
          else ...[
            SizedBox(
              height: 220,
              child: PieChart(
                key: const ValueKey('mood_distribution_donut_chart'),
                PieChartData(
                  centerSpaceRadius: 58,
                  sectionsSpace: 4,
                  sections: [
                    for (final item in items)
                      PieChartSectionData(
                        value: item.entryCount.toDouble(),
                        color: moodColor(item.moodScore),
                        radius: 58,
                        title: l10n.moodLabel(item.moodScore),
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            for (final item in items) ...[
              _MoodDistributionRow(item: item),
              if (item != items.last) const SizedBox(height: 10),
            ],
          ],
        ],
      ),
    );
  }
}

class _MoodDistributionRow extends StatelessWidget {
  const _MoodDistributionRow({required this.item});

  final MoodDistributionItem item;

  @override
  Widget build(BuildContext context) {
    final color = moodColor(item.moodScore);
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.moodLabel(item.moodScore),
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${(item.percentage * 100).round()}%',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Text(
          l10n.entryMultiplier(item.entryCount),
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _EmptyMoodDistribution extends StatelessWidget {
  const _EmptyMoodDistribution({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 148,
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
