import 'package:daily_mood_application/core/database/app_database.dart';
import 'package:daily_mood_application/core/database/daos/mood_entry_dao.dart';
import 'package:daily_mood_application/data/repositories/mood_analytics_repository.dart';
import 'package:daily_mood_application/data/services/mood_analytics_local_service.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('returns seven weekly trend points with sparse-day averages', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final dao = MoodEntryDao(db);
    final repository = MoodAnalyticsRepository(
      localService: MoodAnalyticsLocalService(moodEntryDao: dao),
    );
    final weekStart = DateTime(2026, 7, 6);

    try {
      await _insertEntry(
        db,
        id: 1,
        moodScore: 5,
        createdAt: DateTime(2026, 7, 6, 9),
      );
      await _insertEntry(
        db,
        id: 2,
        moodScore: 3,
        createdAt: DateTime(2026, 7, 6, 20),
      );
      await _insertEntry(
        db,
        id: 3,
        moodScore: 2,
        createdAt: DateTime(2026, 7, 8, 12),
      );
      await _insertEntry(
        db,
        id: 4,
        moodScore: 1,
        createdAt: DateTime(2026, 7, 10, 12),
        isDeleted: true,
      );
      await _insertEntry(
        db,
        id: 5,
        moodScore: 5,
        createdAt: DateTime(2026, 7, 13, 9),
      );

      final points = await repository.watchWeeklyMoodTrend(weekStart).first;

      expect(points, hasLength(7));
      expect(points.map((point) => point.date), [
        DateTime(2026, 7, 6),
        DateTime(2026, 7, 7),
        DateTime(2026, 7, 8),
        DateTime(2026, 7, 9),
        DateTime(2026, 7, 10),
        DateTime(2026, 7, 11),
        DateTime(2026, 7, 12),
      ]);
      expect(points[0].averageMood, 4);
      expect(points[0].entryCount, 2);
      expect(points[1].averageMood, isNull);
      expect(points[1].entryCount, 0);
      expect(points[2].averageMood, 2);
      expect(points[4].averageMood, isNull);
    } finally {
      await db.close();
    }
  });

  test('returns monthly heatmap points with sparse-day averages', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final dao = MoodEntryDao(db);
    final repository = MoodAnalyticsRepository(
      localService: MoodAnalyticsLocalService(moodEntryDao: dao),
    );
    final month = DateTime(2026, 7);

    try {
      await _insertEntry(
        db,
        id: 1,
        moodScore: 5,
        createdAt: DateTime(2026, 7, 1, 9),
      );
      await _insertEntry(
        db,
        id: 2,
        moodScore: 3,
        createdAt: DateTime(2026, 7, 1, 20),
      );
      await _insertEntry(
        db,
        id: 3,
        moodScore: 2,
        createdAt: DateTime(2026, 7, 15, 12),
      );
      await _insertEntry(
        db,
        id: 4,
        moodScore: 1,
        createdAt: DateTime(2026, 7, 20, 12),
        isDeleted: true,
      );
      await _insertEntry(
        db,
        id: 5,
        moodScore: 5,
        createdAt: DateTime(2026, 8, 1, 9),
      );

      final days = await repository.watchMonthlyMoodHeatmap(month).first;

      expect(days, hasLength(31));
      expect(days.first.date, DateTime(2026, 7, 1));
      expect(days.last.date, DateTime(2026, 7, 31));
      expect(days[0].averageMood, 4);
      expect(days[0].entryCount, 2);
      expect(days[1].averageMood, isNull);
      expect(days[14].averageMood, 2);
      expect(days[19].averageMood, isNull);
    } finally {
      await db.close();
    }
  });

  test('returns activity mood correlations ordered by usage', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final dao = MoodEntryDao(db);
    final repository = MoodAnalyticsRepository(
      localService: MoodAnalyticsLocalService(moodEntryDao: dao),
    );

    try {
      final work = await _activity(db, 'Work');
      final sleep = await _activity(db, 'Sleep');

      await dao.createEntry(
        moodScore: 5,
        note: 'Focused morning.',
        activityIds: [work.id],
      );
      await dao.createEntry(
        moodScore: 3,
        note: 'Steady afternoon.',
        activityIds: [work.id],
      );
      await dao.createEntry(
        moodScore: 2,
        note: 'Poor sleep.',
        activityIds: [sleep.id],
      );
      final deletedId = await dao.createEntry(
        moodScore: 1,
        note: 'Deleted work entry.',
        activityIds: [work.id],
      );
      await dao.softDeleteEntry(deletedId);

      final correlations = await repository
          .watchActivityMoodCorrelations()
          .first;

      expect(correlations, hasLength(2));
      expect(correlations[0].activityName, 'Work');
      expect(correlations[0].entryCount, 2);
      expect(correlations[0].averageMood, 4);
      expect(correlations[1].activityName, 'Sleep');
      expect(correlations[1].entryCount, 1);
      expect(correlations[1].averageMood, 2);
    } finally {
      await db.close();
    }
  });
}

Future<void> _insertEntry(
  AppDatabase db, {
  required int id,
  required int moodScore,
  required DateTime createdAt,
  bool isDeleted = false,
}) {
  return db
      .into(db.moodEntries)
      .insert(
        MoodEntriesCompanion.insert(
          id: Value(id),
          uuid: 'entry-$id',
          moodScore: moodScore,
          createdAt: createdAt,
          updatedAt: createdAt,
          isDeleted: Value(isDeleted),
        ),
      );
}

Future<Activity> _activity(AppDatabase db, String name) {
  return (db.select(
    db.activities,
  )..where((activity) => activity.name.equals(name))).getSingle();
}
