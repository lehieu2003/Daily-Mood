import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../domain/models/mood_entry.dart';
import '../dashboard_palette.dart';

class DashboardMoodChart extends StatelessWidget {
  const DashboardMoodChart({required this.entries, super.key});

  final List<MoodEntryModel> entries;

  @override
  Widget build(BuildContext context) {
    final displayEntries = _displayEntries(entries);

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        color: DashboardPalette.lilacPanel,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.moodChart,
            style: TextStyle(
              color: DashboardPalette.deepText,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),
          if (displayEntries.isEmpty)
            const _EmptyMoodChart()
          else
            SizedBox(
              height: 172,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (final entry in displayEntries)
                    _MoodBar(
                      score: entry.moodScore,
                      label: _formatTime(entry.createdAt),
                      dateKey: _entryKey(entry),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _MoodBar extends StatelessWidget {
  const _MoodBar({
    required this.score,
    required this.label,
    required this.dateKey,
  });

  final int score;
  final String label;
  final String dateKey;

  @override
  Widget build(BuildContext context) {
    final height = switch (score) {
      5 => 118.0,
      4 => 100.0,
      3 => 78.0,
      2 => 54.0,
      _ => 34.0,
    };
    final color = switch (score) {
      5 => DashboardPalette.green,
      4 => DashboardPalette.green,
      3 => DashboardPalette.blue,
      2 => DashboardPalette.orange,
      _ => const Color(0xFFFF7065),
    };
    final face = switch (score) {
      5 => '😍',
      4 => '😊',
      3 => '😊',
      2 => '😞',
      _ => '😡',
    };

    return SizedBox(
      key: ValueKey('dashboard_mood_bar_$dateKey'),
      width: 36,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: 18,
                height: 118,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Container(
                width: 18,
                height: height,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Positioned(
                top: 8 + (118 - height).clamp(0, 102).toDouble(),
                child: Text(face, style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            label,
            key: ValueKey('dashboard_mood_bar_label_$dateKey'),
            style: TextStyle(
              color: DashboardPalette.mutedText,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyMoodChart extends StatelessWidget {
  const _EmptyMoodChart();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('dashboard_mood_chart_empty'),
      height: 172,
      alignment: Alignment.center,
      child: Text(
        context.l10n.noCheckInsToday,
        style: TextStyle(
          color: DashboardPalette.mutedText,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

List<MoodEntryModel> _displayEntries(List<MoodEntryModel> entries) {
  final sorted = [...entries]
    ..sort((first, second) => first.createdAt.compareTo(second.createdAt));

  if (sorted.length <= 5) return sorted;

  return sorted.sublist(sorted.length - 5);
}

String _formatTime(DateTime date) {
  final local = date.toLocal();
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

String _entryKey(MoodEntryModel entry) {
  final local = entry.createdAt.toLocal();
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '${local.year}$month${day}_$hour$minute';
}
