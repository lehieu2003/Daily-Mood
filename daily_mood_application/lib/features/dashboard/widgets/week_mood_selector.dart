import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../domain/models/mood_entry.dart';
import '../dashboard_palette.dart';

class WeekMoodSelector extends StatelessWidget {
  const WeekMoodSelector({
    required this.entries,
    required this.selectedDate,
    required this.onDateSelected,
    super.key,
    this.today,
  });

  final List<MoodEntryModel> entries;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final DateTime? today;

  @override
  Widget build(BuildContext context) {
    final currentDay = _dateOnly(today ?? DateTime.now());
    final firstDay = currentDay.subtract(const Duration(days: 6));
    final latestEntriesByDay = _latestEntriesByDay(entries);
    final days = List.generate(7, (index) {
      final day = firstDay.add(Duration(days: index));
      final dateKey = _dateKey(day);
      final entry = latestEntriesByDay[dateKey];

      return _DayMood(
        context.l10n.weekdayShort(day.weekday),
        day.day.toString(),
        entry == null ? '' : _moodEmoji(entry.moodScore),
        dateKey: dateKey,
        selected: _isSameDay(day, selectedDate),
        onTap: () => onDateSelected(day),
      );
    });

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
  const _DayMood(
    this.day,
    this.date,
    this.mood, {
    required this.dateKey,
    required this.onTap,
    this.selected = false,
  });

  final String day;
  final String date;
  final String mood;
  final String dateKey;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      key: ValueKey('week_mood_day_$dateKey'),
      button: true,
      selected: selected,
      label: '$day $date',
      child: SizedBox(
        width: 44,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 44,
                height: 64,
                decoration: BoxDecoration(
                  color: selected
                      ? DashboardPalette.purple
                      : DashboardPalette.surface,
                  borderRadius: BorderRadius.circular(22),
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
                        color: selected
                            ? Colors.white70
                            : DashboardPalette.mutedText,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      date,
                      style: TextStyle(
                        color: selected
                            ? Colors.white
                            : DashboardPalette.deepText,
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
                        color: DashboardPalette.deepText.withValues(
                          alpha: 0.06,
                        ),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    mood,
                    key: ValueKey('week_mood_face_$dateKey'),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Map<String, MoodEntryModel> _latestEntriesByDay(List<MoodEntryModel> entries) {
  final entriesByDay = <String, MoodEntryModel>{};

  for (final entry in entries) {
    final day = _dateOnly(entry.createdAt);
    final dateKey = _dateKey(day);
    final currentEntry = entriesByDay[dateKey];

    if (currentEntry == null ||
        entry.createdAt.isAfter(currentEntry.createdAt)) {
      entriesByDay[dateKey] = entry;
    }
  }

  return entriesByDay;
}

DateTime _dateOnly(DateTime date) {
  final local = date.toLocal();
  return DateTime(local.year, local.month, local.day);
}

bool _isSameDay(DateTime first, DateTime second) {
  return first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}

String _dateKey(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}$month$day';
}

String _moodEmoji(int score) {
  return switch (score) {
    1 => '😢',
    2 => '😞',
    3 => '😐',
    4 => '🙂',
    _ => '😍',
  };
}
