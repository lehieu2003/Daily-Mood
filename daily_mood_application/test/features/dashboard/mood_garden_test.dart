import 'package:daily_mood_application/domain/models/daily_reflection.dart';
import 'package:daily_mood_application/domain/models/mood_entry.dart';
import 'package:daily_mood_application/features/dashboard/mood_garden.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('grows from active days and reflections', () {
    final summary = buildMoodGardenSummary(
      entries: [
        _entry(1, DateTime(2026, 7, 18)),
        _entry(2, DateTime(2026, 7, 17)),
        _entry(3, DateTime(2026, 7, 17, 20)),
      ],
      reflections: [
        _reflection(1, DateTime(2026, 7, 18)),
        _reflection(2, DateTime(2026, 7, 16)),
      ],
      today: DateTime(2026, 7, 18),
    );

    expect(summary.activeDayCount, 2);
    expect(summary.reflectionCount, 2);
    expect(summary.growthPoints, 6);
    expect(summary.stage, MoodGardenStage.leafy);
    expect(summary.recentActiveDays, 3);
  });

  test('missed days do not shrink lifetime garden stage', () {
    final entries = [
      _entry(1, DateTime(2026, 7, 1)),
      _entry(2, DateTime(2026, 7, 2)),
      _entry(3, DateTime(2026, 7, 3)),
      _entry(4, DateTime(2026, 7, 4)),
    ];
    final reflections = [_reflection(1, DateTime(2026, 7, 1))];

    final beforeGap = buildMoodGardenSummary(
      entries: entries,
      reflections: reflections,
      today: DateTime(2026, 7, 5),
    );
    final afterGap = buildMoodGardenSummary(
      entries: entries,
      reflections: reflections,
      today: DateTime(2026, 7, 18),
    );

    expect(beforeGap.stage, MoodGardenStage.leafy);
    expect(afterGap.stage, MoodGardenStage.leafy);
    expect(afterGap.growthPoints, beforeGap.growthPoints);
    expect(afterGap.recentActiveDays, lessThan(beforeGap.recentActiveDays));
  });
}

MoodEntryModel _entry(int id, DateTime createdAt) {
  return MoodEntryModel(
    id: id,
    uuid: 'entry-$id',
    moodScore: 4,
    note: 'Note',
    createdAt: createdAt,
    updatedAt: createdAt,
  );
}

DailyReflectionModel _reflection(int id, DateTime date) {
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
