import '../../core/database/daos/mood_entry_dao.dart';
import '../../domain/models/activity_mood_correlation.dart';
import '../../domain/models/monthly_mood_day.dart';
import '../../domain/models/weekly_mood_point.dart';

final class MoodAnalyticsLocalService {
  MoodAnalyticsLocalService({required MoodEntryDao moodEntryDao})
    : _moodEntryDao = moodEntryDao;

  final MoodEntryDao _moodEntryDao;

  Stream<List<WeeklyMoodPoint>> watchWeeklyMoodTrend(DateTime weekStart) {
    final start = _startOfDay(weekStart);
    final end = start.add(const Duration(days: 7));

    return _moodEntryDao.watchEntriesBetween(start, end).map((entries) {
      final scoresByDay = <DateTime, List<int>>{
        for (var offset = 0; offset < 7; offset++)
          start.add(Duration(days: offset)): <int>[],
      };

      for (final entry in entries) {
        final created = entry.createdAt.toLocal();
        final day = DateTime(created.year, created.month, created.day);
        scoresByDay[day]?.add(entry.moodScore);
      }

      return [
        for (final day in scoresByDay.entries)
          WeeklyMoodPoint(
            date: day.key,
            averageMood: day.value.isEmpty ? null : _average(day.value),
            entryCount: day.value.length,
          ),
      ];
    });
  }

  Stream<List<MonthlyMoodDay>> watchMonthlyMoodHeatmap(DateTime month) {
    final localMonth = month.toLocal();
    final start = DateTime(localMonth.year, localMonth.month);
    final end = DateTime(localMonth.year, localMonth.month + 1);
    final dayCount = end.difference(start).inDays;

    return _moodEntryDao.watchEntriesBetween(start, end).map((entries) {
      final scoresByDay = <DateTime, List<int>>{
        for (var offset = 0; offset < dayCount; offset++)
          start.add(Duration(days: offset)): <int>[],
      };

      for (final entry in entries) {
        final created = entry.createdAt.toLocal();
        final day = DateTime(created.year, created.month, created.day);
        scoresByDay[day]?.add(entry.moodScore);
      }

      return [
        for (final day in scoresByDay.entries)
          MonthlyMoodDay(
            date: day.key,
            averageMood: day.value.isEmpty ? null : _average(day.value),
            entryCount: day.value.length,
          ),
      ];
    });
  }

  Stream<List<ActivityMoodCorrelation>> watchActivityMoodCorrelations({
    int limit = 6,
  }) {
    return _moodEntryDao.watchActivityMoodCorrelationRows(limit: limit).map((
      rows,
    ) {
      return [
        for (final row in rows)
          ActivityMoodCorrelation(
            activityId: row.read<int>('activity_id'),
            activityName: row.read<String>('activity_name'),
            entryCount: row.read<int>('entry_count'),
            averageMood: row.read<double>('average_mood'),
          ),
      ];
    });
  }

  DateTime _startOfDay(DateTime date) {
    final local = date.toLocal();
    return DateTime(local.year, local.month, local.day);
  }

  double _average(List<int> scores) {
    final total = scores.fold<int>(0, (sum, score) => sum + score);
    return total / scores.length;
  }
}
