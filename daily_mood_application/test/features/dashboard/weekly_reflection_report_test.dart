import 'package:daily_mood_application/domain/models/daily_reflection.dart';
import 'package:daily_mood_application/domain/models/mood_entry.dart';
import 'package:daily_mood_application/features/dashboard/weekly_reflection_report.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('returns calm empty state for a week without entries', () {
    final report = buildWeeklyReflectionReport(
      entries: const [],
      reflections: const [],
      selectedDate: DateTime(2026, 7, 19),
    );

    expect(report.weekStart, DateTime(2026, 7, 13));
    expect(report.weekEnd, DateTime(2026, 7, 19));
    expect(report.entryCount, 0);
    expect(report.averageMood, isNull);
    expect(report.tone, WeeklyReportTone.empty);
  });

  test('handles sparse week without diagnostic language', () {
    final report = buildWeeklyReflectionReport(
      entries: [_entry(id: 1, moodScore: 3, createdAt: DateTime(2026, 7, 16))],
      reflections: const [],
      selectedDate: DateTime(2026, 7, 19),
    );

    expect(report.entryCount, 1);
    expect(report.activeDayCount, 1);
    expect(report.averageMood, 3);
    expect(report.hasEnoughEntries, isFalse);
    expect(report.tone, WeeklyReportTone.sparse);
  });

  test('summarizes average mood top reason emotion and reflections', () {
    final report = buildWeeklyReflectionReport(
      entries: [
        _entry(
          id: 1,
          moodScore: 4,
          createdAt: DateTime(2026, 7, 13),
          activityIds: const [1],
          activityNames: const ['Work'],
          subEmotionIds: const [10],
          subEmotionNames: const ['Calm'],
        ),
        _entry(
          id: 2,
          moodScore: 2,
          createdAt: DateTime(2026, 7, 15),
          activityIds: const [1],
          activityNames: const ['Work'],
          subEmotionIds: const [7],
          subEmotionNames: const ['Neutral'],
        ),
        _entry(
          id: 3,
          moodScore: 5,
          createdAt: DateTime(2026, 7, 20),
          activityIds: const [2],
          activityNames: const ['Food'],
          subEmotionIds: const [11],
          subEmotionNames: const ['Satisfied'],
        ),
      ],
      reflections: [
        _reflection(id: 1, date: DateTime(2026, 7, 13)),
        _reflection(id: 2, date: DateTime(2026, 7, 16)),
        _reflection(id: 3, date: DateTime(2026, 7, 20)),
      ],
      selectedDate: DateTime(2026, 7, 19),
    );

    expect(report.entryCount, 2);
    expect(report.activeDayCount, 2);
    expect(report.reflectionCount, 2);
    expect(report.averageMood, 3);
    expect(report.topActivity!.name, 'Work');
    expect(report.topActivity!.count, 2);
    expect(report.topEmotion!.name, 'Neutral');
    expect(report.topEmotion!.count, 1);
    expect(report.tone, WeeklyReportTone.reflected);
  });
}

MoodEntryModel _entry({
  required int id,
  required int moodScore,
  required DateTime createdAt,
  List<int> activityIds = const [],
  List<String> activityNames = const [],
  List<int> subEmotionIds = const [],
  List<String> subEmotionNames = const [],
}) {
  return MoodEntryModel(
    id: id,
    uuid: 'entry-$id',
    moodScore: moodScore,
    note: 'Note',
    createdAt: createdAt,
    updatedAt: createdAt,
    activityIds: activityIds,
    activityNames: activityNames,
    subEmotionIds: subEmotionIds,
    subEmotionNames: subEmotionNames,
  );
}

DailyReflectionModel _reflection({required int id, required DateTime date}) {
  return DailyReflectionModel(
    id: id,
    uuid: 'reflection-$id',
    date: date,
    prompt: 'What made today better?',
    response: 'A quiet moment.',
    createdAt: date,
    updatedAt: date,
  );
}
