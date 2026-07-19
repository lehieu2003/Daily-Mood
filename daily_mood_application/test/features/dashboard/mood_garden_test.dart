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

  test('builds progression metadata with current and locked stages', () {
    final summary = buildMoodGardenSummary(
      entries: [
        _entry(1, DateTime(2026, 7, 18)),
        _entry(2, DateTime(2026, 7, 17)),
      ],
      reflections: [
        _reflection(1, DateTime(2026, 7, 18)),
        _reflection(2, DateTime(2026, 7, 16)),
      ],
      today: DateTime(2026, 7, 18),
    );

    final progression = summary.stageProgression;
    expect(progression.map((item) => item.stage), moodGardenStages);
    expect(
      progression
          .where((item) => item.isUnlocked)
          .map((item) => item.stage),
      [
        MoodGardenStage.seed,
        MoodGardenStage.sprout,
        MoodGardenStage.leafy,
      ],
    );
    expect(
      progression.singleWhere((item) => item.isCurrent).stage,
      MoodGardenStage.leafy,
    );
    expect(
      progression.singleWhere((item) => item.stage == MoodGardenStage.bloom)
          .requiredPoints,
      9,
    );
    expect(
      progression.singleWhere((item) => item.stage == MoodGardenStage.bloom)
          .isUnlocked,
      isFalse,
    );
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
    expect(
      afterGap.stageProgression
          .singleWhere((item) => item.stage == MoodGardenStage.leafy)
          .isUnlocked,
      isTrue,
    );
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
