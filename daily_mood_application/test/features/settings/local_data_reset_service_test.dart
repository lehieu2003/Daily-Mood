import 'package:daily_mood_application/core/database/app_database.dart';
import 'package:daily_mood_application/core/database/daos/activity_dao.dart';
import 'package:daily_mood_application/core/database/daos/mood_entry_dao.dart';
import 'package:daily_mood_application/features/settings/data/local_data_reset_service.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('deletes local user data, reseeds defaults, and rotates key', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final activityDao = ActivityDao(db);
    final moodEntryDao = MoodEntryDao(db);
    final keyResetter = _FakeDatabaseKeyResetter();
    final mediaResetter = _FakeLocalMediaResetter();
    final resetService = DriftLocalDataResetService(
      database: db,
      keyResetter: keyResetter,
      mediaResetter: mediaResetter,
    );

    try {
      final customActivityId = await activityDao.createCustomActivity(
        name: 'Reading',
        category: 'Other',
      );
      final calmSubEmotion = await (db.select(
        db.subEmotions,
      )..where((row) => row.name.equals('Calm'))).getSingle();
      final entryId = await moodEntryDao.createEntry(
        moodScore: 4,
        note: 'Private note',
        photoRelativePath: 'mood_photos/private.jpg',
        activityIds: [customActivityId],
        subEmotionIds: [calmSubEmotion.id],
      );

      expect(entryId, greaterThan(0));
      expect(await db.select(db.moodEntries).get(), hasLength(1));
      expect(await db.select(db.moodPhotos).get(), hasLength(1));

      await resetService.deleteAllData();

      expect(await db.select(db.moodEntries).get(), isEmpty);
      expect(await db.select(db.moodPhotos).get(), isEmpty);
      expect(await db.select(db.moodEntryActivities).get(), isEmpty);
      expect(await db.select(db.moodEntrySubEmotions).get(), isEmpty);
      expect(
        await (db.select(
          db.activities,
        )..where((row) => row.name.equals('Reading'))).get(),
        isEmpty,
      );
      expect(
        await (db.select(
          db.activities,
        )..where((row) => row.name.equals('Work'))).get(),
        hasLength(1),
      );
      expect(await db.select(db.subEmotions).get(), hasLength(15));
      expect(mediaResetter.deleteCount, 1);
      expect(keyResetter.rotateCount, 1);
    } finally {
      await db.close();
    }
  });
}

class _FakeLocalMediaResetter implements LocalMediaResetter {
  int deleteCount = 0;

  @override
  Future<void> deleteMoodMedia() async {
    deleteCount++;
  }
}

class _FakeDatabaseKeyResetter implements DatabaseKeyResetter {
  int rotateCount = 0;

  @override
  Future<void> rotateOpenDatabaseKey(AppDatabase database) async {
    rotateCount++;
  }
}
