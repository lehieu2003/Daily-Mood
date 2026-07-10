import 'package:flutter/material.dart';

import '../dashboard_palette.dart';

class WeekMoodSelector extends StatelessWidget {
  const WeekMoodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    const days = [
      _DayMood('Thu', '1', '😇'),
      _DayMood('Fri', '2', '😀'),
      _DayMood('Sat', '3', '😡'),
      _DayMood('Sun', '4', '😍', selected: true),
      _DayMood('Mon', '5', ''),
      _DayMood('Tue', '6', ''),
      _DayMood('Wed', '7', ''),
    ];

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => days[index],
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemCount: days.length,
      ),
    );
  }
}

class _DayMood extends StatelessWidget {
  const _DayMood(this.day, this.date, this.mood, {this.selected = false});

  final String day;
  final String date;
  final String mood;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 42,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 42,
            height: 64,
            decoration: BoxDecoration(
              color: selected ? DashboardPalette.purple : DashboardPalette.surface,
              borderRadius: BorderRadius.circular(21),
              boxShadow: [
                BoxShadow(
                  color: DashboardPalette.deepText.withValues(alpha: 0.05),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day,
                  style: TextStyle(
                    color: selected ? Colors.white70 : DashboardPalette.mutedText,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  date,
                  style: TextStyle(
                    color: selected ? Colors.white : DashboardPalette.deepText,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (mood.isEmpty)
            const SizedBox(height: 24)
          else
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: DashboardPalette.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: DashboardPalette.deepText.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(mood, style: const TextStyle(fontSize: 14)),
            ),
        ],
      ),
    );
  }
}
