import 'package:flutter/material.dart';

import '../../../domain/models/mood_entry.dart';
import '../dashboard_palette.dart';
import 'dashboard_mood_chart.dart';

class TodayCheckInSection extends StatelessWidget {
  const TodayCheckInSection({
    required this.entries,
    required this.selectedDate,
    required this.today,
    required this.onLogMood,
    super.key,
  });

  final List<MoodEntryModel> entries;
  final DateTime selectedDate;
  final DateTime today;
  final VoidCallback onLogMood;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                _titleForDate(selectedDate, today),
                style: const TextStyle(
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
          entries: entries,
        ),
      ],
    );
  }
}

String _titleForDate(DateTime selectedDate, DateTime today) {
  final selected = DateTime(
    selectedDate.year,
    selectedDate.month,
    selectedDate.day,
  );
  final current = DateTime(today.year, today.month, today.day);

  if (selected == current) return "Today's check-in";
  if (selected == current.subtract(const Duration(days: 1))) {
    return "Yesterday's check-in";
  }

  return '${_shortMonth(selected.month)} ${selected.day} check-in';
}

String _shortMonth(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return months[month - 1];
}
