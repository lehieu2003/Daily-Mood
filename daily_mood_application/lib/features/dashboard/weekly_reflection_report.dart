import '../../domain/models/daily_reflection.dart';
import '../../domain/models/mood_entry.dart';

enum WeeklyReportTone { empty, sparse, reflected, steady }

final class WeeklyReflectionReport {
  const WeeklyReflectionReport({
    required this.weekStart,
    required this.weekEnd,
    required this.entryCount,
    required this.activeDayCount,
    required this.reflectionCount,
    required this.averageMood,
    required this.topActivity,
    required this.topEmotion,
    required this.tone,
  });

  final DateTime weekStart;
  final DateTime weekEnd;
  final int entryCount;
  final int activeDayCount;
  final int reflectionCount;
  final double? averageMood;
  final WeeklyReportHighlight? topActivity;
  final WeeklyReportHighlight? topEmotion;
  final WeeklyReportTone tone;

  bool get hasEnoughEntries => entryCount >= 2;
}

final class WeeklyReportHighlight {
  const WeeklyReportHighlight({
    required this.id,
    required this.name,
    required this.count,
  });

  final int id;
  final String name;
  final int count;
}

WeeklyReflectionReport buildWeeklyReflectionReport({
  required List<MoodEntryModel> entries,
  required List<DailyReflectionModel> reflections,
  required DateTime selectedDate,
}) {
  final weekStart = _startOfWeek(selectedDate);
  final weekEnd = weekStart.add(const Duration(days: 6));
  final weekEntries = entries
      .where((entry) => _isWithinWeek(entry.createdAt, weekStart, weekEnd))
      .toList(growable: false);
  final weekReflections = reflections
      .where((reflection) => _isWithinWeek(reflection.date, weekStart, weekEnd))
      .toList(growable: false);
  final activeDays = {
    for (final entry in weekEntries) _dateOnly(entry.createdAt),
  };
  final averageMood = weekEntries.isEmpty
      ? null
      : weekEntries.fold<int>(0, (sum, entry) => sum + entry.moodScore) /
            weekEntries.length;

  return WeeklyReflectionReport(
    weekStart: weekStart,
    weekEnd: weekEnd,
    entryCount: weekEntries.length,
    activeDayCount: activeDays.length,
    reflectionCount: weekReflections.length,
    averageMood: averageMood,
    topActivity: _topActivity(weekEntries),
    topEmotion: _topEmotion(weekEntries),
    tone: _toneFor(weekEntries.length, weekReflections.length),
  );
}

WeeklyReportTone _toneFor(int entryCount, int reflectionCount) {
  if (entryCount == 0) return WeeklyReportTone.empty;
  if (entryCount < 2) return WeeklyReportTone.sparse;
  if (reflectionCount >= 2) return WeeklyReportTone.reflected;
  return WeeklyReportTone.steady;
}

WeeklyReportHighlight? _topActivity(List<MoodEntryModel> entries) {
  final counts = <int, WeeklyReportHighlight>{};
  for (final entry in entries) {
    for (var index = 0; index < entry.activityIds.length; index++) {
      final id = entry.activityIds[index];
      final name = index < entry.activityNames.length
          ? entry.activityNames[index]
          : id.toString();
      counts.update(
        id,
        (count) => WeeklyReportHighlight(
          id: id,
          name: count.name,
          count: count.count + 1,
        ),
        ifAbsent: () => WeeklyReportHighlight(id: id, name: name, count: 1),
      );
    }
  }
  return _mostCommon(counts);
}

WeeklyReportHighlight? _topEmotion(List<MoodEntryModel> entries) {
  final counts = <int, WeeklyReportHighlight>{};
  for (final entry in entries) {
    for (var index = 0; index < entry.subEmotionIds.length; index++) {
      final id = entry.subEmotionIds[index];
      final name = index < entry.subEmotionNames.length
          ? entry.subEmotionNames[index]
          : id.toString();
      counts.update(
        id,
        (count) => WeeklyReportHighlight(
          id: id,
          name: count.name,
          count: count.count + 1,
        ),
        ifAbsent: () => WeeklyReportHighlight(id: id, name: name, count: 1),
      );
    }
  }
  return _mostCommon(counts);
}

WeeklyReportHighlight? _mostCommon(Map<int, WeeklyReportHighlight> counts) {
  if (counts.isEmpty) return null;
  return counts.entries.reduce((best, current) {
    if (current.value.count != best.value.count) {
      return current.value.count > best.value.count ? current : best;
    }
    return current.key < best.key ? current : best;
  }).value;
}

bool _isWithinWeek(DateTime date, DateTime weekStart, DateTime weekEnd) {
  final day = _dateOnly(date);
  return !day.isBefore(weekStart) && !day.isAfter(weekEnd);
}

DateTime _startOfWeek(DateTime date) {
  final local = _dateOnly(date);
  return local.subtract(Duration(days: local.weekday - DateTime.monday));
}

DateTime _dateOnly(DateTime date) {
  final local = date.toLocal();
  return DateTime(local.year, local.month, local.day);
}
