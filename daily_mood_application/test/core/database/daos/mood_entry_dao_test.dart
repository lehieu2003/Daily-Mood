import 'package:daily_mood_application/core/database/app_database.dart';
import 'package:daily_mood_application/core/database/daos/mood_entry_dao.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('creates a mood entry with activity and sub-emotion links', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final dao = MoodEntryDao(db);

    try {
      final workActivity = await (db.select(
        db.activities,
      )..where((activity) => activity.name.equals('Work'))).getSingle();
      final calmSubEmotion = await (db.select(
        db.subEmotions,
      )..where((subEmotion) => subEmotion.name.equals('Calm'))).getSingle();

      final entryId = await dao.createEntry(
        moodScore: 4,
        note: 'Had a steady day.',
        voiceNotePath: 'mood_voices/entry.m4a',
        photoRelativePath: 'mood_photos/entry.jpg',
        activityIds: [workActivity.id],
        subEmotionIds: [calmSubEmotion.id],
      );

      final entry = await (db.select(
        db.moodEntries,
      )..where((moodEntry) => moodEntry.id.equals(entryId))).getSingle();
      expect(entry.moodScore, 4);
      expect(entry.note, 'Had a steady day.');
      expect(entry.voiceNotePath, 'mood_voices/entry.m4a');
      expect(entry.uuid, isNotEmpty);
      expect(entry.updatedAt, entry.createdAt);

      final activityLinks = await db.select(db.moodEntryActivities).get();
      expect(activityLinks, hasLength(1));
      expect(activityLinks.single.moodEntryId, entryId);
      expect(activityLinks.single.activityId, workActivity.id);

      final subEmotionLinks = await db.select(db.moodEntrySubEmotions).get();
      expect(subEmotionLinks, hasLength(1));
      expect(subEmotionLinks.single.moodEntryId, entryId);
      expect(subEmotionLinks.single.subEmotionId, calmSubEmotion.id);

      final photos = await db.select(db.moodPhotos).get();
      expect(photos, hasLength(1));
      expect(photos.single.moodEntryId, entryId);
      expect(photos.single.relativePath, 'mood_photos/entry.jpg');
    } finally {
      await db.close();
    }
  });

  test('watches history rows with activity and sub-emotion names', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final dao = MoodEntryDao(db);

    try {
      final workActivity = await (db.select(
        db.activities,
      )..where((activity) => activity.name.equals('Work'))).getSingle();
      final calmSubEmotion = await (db.select(
        db.subEmotions,
      )..where((subEmotion) => subEmotion.name.equals('Calm'))).getSingle();

      final entryId = await dao.createEntry(
        moodScore: 4,
        note: 'Had a steady day.',
        activityIds: [workActivity.id],
        subEmotionIds: [calmSubEmotion.id],
      );
      final hiddenEntryId = await dao.createEntry(
        moodScore: 1,
        note: 'Hidden entry.',
        activityIds: [workActivity.id],
      );
      await dao.softDeleteEntry(hiddenEntryId);

      final rows = await dao.watchHistoryEntries().first;

      expect(rows, hasLength(1));
      expect(rows.single.entry.id, entryId);
      expect(rows.single.activityNames, ['Work']);
      expect(rows.single.subEmotionNames, ['Calm']);
    } finally {
      await db.close();
    }
  });
}
