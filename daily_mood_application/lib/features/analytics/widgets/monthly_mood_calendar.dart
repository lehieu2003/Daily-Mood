import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/app_colors.dart';
import '../../../domain/models/monthly_mood_day.dart';
import '../../dashboard/dashboard_formatters.dart';
import 'monthly_heatmap_empty_state.dart';

class MonthlyMoodCalendar extends StatelessWidget {
  const MonthlyMoodCalendar({
    required this.days,
    required this.focusedMonth,
    super.key,
  });

  final List<MonthlyMoodDay> days;
  final DateTime focusedMonth;

  @override
  Widget build(BuildContext context) {
    final moodDays = {
      for (final day in days)
        DateTime(day.date.year, day.date.month, day.date.day): day,
    };
    final entryCount = days.fold<int>(
      0,
      (total, day) => total + day.entryCount,
    );

    if (entryCount == 0) {
      return const MonthlyHeatmapEmptyState();
    }
    final l10n = context.l10n;

    return Container(
      key: const ValueKey('monthly_mood_calendar'),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.moodCalendar,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Text(
                  l10n.entryCount(entryCount),
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          TableCalendar<MonthlyMoodDay>(
            firstDay: DateTime(focusedMonth.year, focusedMonth.month),
            lastDay: DateTime(focusedMonth.year, focusedMonth.month + 1, 0),
            focusedDay: focusedMonth,
            headerVisible: false,
            daysOfWeekHeight: 28,
            rowHeight: 50,
            availableGestures: AvailableGestures.none,
            calendarStyle: const CalendarStyle(
              outsideDaysVisible: false,
              cellMargin: EdgeInsets.all(3),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                color: AppColors.textTertiary,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
              weekendStyle: TextStyle(
                color: AppColors.textTertiary,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                return _MoodDayCell(day: day, moodDay: moodDays[_dayKey(day)]);
              },
              todayBuilder: (context, day, focusedDay) {
                return _MoodDayCell(
                  day: day,
                  moodDay: moodDays[_dayKey(day)],
                  isToday: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  DateTime _dayKey(DateTime day) {
    return DateTime(day.year, day.month, day.day);
  }
}

class _MoodDayCell extends StatelessWidget {
  const _MoodDayCell({
    required this.day,
    required this.moodDay,
    this.isToday = false,
  });

  final DateTime day;
  final MonthlyMoodDay? moodDay;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final averageMood = moodDay?.averageMood;
    final score = averageMood?.round().clamp(1, 5);
    final color = score == null ? Colors.transparent : moodColor(score);
    final hasMood = moodDay?.hasEntries ?? false;

    return Container(
      key: ValueKey('monthly_heatmap_day_${day.year}-${day.month}-${day.day}'),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: hasMood
            ? color.withValues(alpha: 0.18 + (score! * 0.08))
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isToday
              ? AppColors.primaryPurple
              : hasMood
              ? color.withValues(alpha: 0.72)
              : Colors.transparent,
          width: isToday ? 1.6 : 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            day.day.toString(),
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
          if (hasMood) ...[
            const SizedBox(height: 1),
            Text(
              averageMood!.toStringAsFixed(1),
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 9,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
