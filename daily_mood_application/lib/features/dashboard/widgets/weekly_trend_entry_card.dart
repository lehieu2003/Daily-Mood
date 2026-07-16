import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../domain/models/mood_entry.dart';
import '../dashboard_formatters.dart';
import '../dashboard_palette.dart';

class WeeklyTrendEntryCard extends StatelessWidget {
  const WeeklyTrendEntryCard({
    required this.entries,
    required this.onOpenTrend,
    super.key,
  });

  final List<MoodEntryModel> entries;
  final VoidCallback onOpenTrend;

  @override
  Widget build(BuildContext context) {
    final average =
        entries
            .map((entry) => entry.moodScore)
            .fold<int>(0, (sum, score) => sum + score) /
        entries.length;
    final roundedAverage = average.round();
    final l10n = context.l10n;

    return Semantics(
      button: true,
      label: l10n.weeklyTrendUnlocked,
      hint: l10n.opensStatsTab,
      child: InkWell(
        key: const ValueKey('weekly_trend_entry_card'),
        borderRadius: BorderRadius.circular(18),
        onTap: onOpenTrend,
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: DashboardPalette.surface,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              _TrendMark(score: roundedAverage),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.weeklyTrend,
                      style: TextStyle(
                        color: DashboardPalette.deepText,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      l10n.weeklyTrendSummary(entries.length, average),
                      style: TextStyle(
                        color: DashboardPalette.mutedText,
                        fontSize: 12,
                        height: 1.25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: DashboardPalette.purple.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: DashboardPalette.purple,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrendMark extends StatelessWidget {
  const _TrendMark({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: moodColor(score).withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(Icons.insights_outlined, color: moodColor(score), size: 24),
    );
  }
}
