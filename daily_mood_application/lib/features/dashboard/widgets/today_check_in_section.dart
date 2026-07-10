import 'package:flutter/material.dart';

import '../../../domain/models/mood_entry.dart';
import '../dashboard_palette.dart';
import 'dashboard_mood_chart.dart';

class TodayCheckInSection extends StatelessWidget {
  const TodayCheckInSection({
    required this.entries,
    required this.onLogMood,
    super.key,
  });

  final List<MoodEntryModel> entries;
  final VoidCallback onLogMood;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                "Today's check-in",
                style: TextStyle(
                  color: DashboardPalette.deepText,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                border: Border.all(color: DashboardPalette.deepText),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.expand_less, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 12),
        InkWell(
          key: const ValueKey('dashboard_check_in_card'),
          onTap: onLogMood,
          borderRadius: BorderRadius.circular(24),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: DashboardPalette.pinkPanel,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Text('✨', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Check-in',
                    style: TextStyle(
                      color: DashboardPalette.deepText,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  '${entries.length.clamp(0, 3)}/3',
                  style: const TextStyle(
                    color: DashboardPalette.deepText,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: DashboardPalette.hotPink,
                    shape: BoxShape.circle,
                  ),
                  child: const Text('🔥', style: TextStyle(fontSize: 17)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        DashboardMoodChart(
          scores: entries.map((entry) => entry.moodScore).toList(),
        ),
      ],
    );
  }
}
