import 'package:daily_mood_application/core/database/app_database.dart';
import 'package:daily_mood_application/core/database/daos/mood_entry_dao.dart';
import 'package:drift/drift.dart';
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
      expect(rows.single.activityIds, [workActivity.id]);
      expect(rows.single.activityNames, ['Work']);
      expect(rows.single.subEmotionIds, [calmSubEmotion.id]);
      expect(rows.single.subEmotionNames, ['Calm']);
    } finally {
      await db.close();
    }
  });

  test('watches on this day rows from prior years only', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final dao = MoodEntryDao(db);

    try {
      final priorEntryId = await dao.createEntry(
        moodScore: 4,
        note: 'Same date last year.',
        photoRelativePath: 'mood_photos/memory.jpg',
        activityIds: const [],
      );
      await _moveEntryTo(db, priorEntryId, DateTime(2025, 7, 20, 8, 30));

      final currentYearEntryId = await dao.createEntry(
        moodScore: 5,
        note: 'Same date this year.',
        activityIds: const [],
      );
      await _moveEntryTo(db, currentYearEntryId, DateTime(2026, 7, 20, 9));

      final differentDayEntryId = await dao.createEntry(
        moodScore: 2,
        note: 'Different day last year.',
        activityIds: const [],
      );
      await _moveEntryTo(db, differentDayEntryId, DateTime(2025, 7, 21, 9));

      final deletedEntryId = await dao.createEntry(
        moodScore: 1,
        note: 'Deleted same date.',
        activityIds: const [],
      );
      await _moveEntryTo(db, deletedEntryId, DateTime(2024, 7, 20, 9));
      await dao.softDeleteEntry(deletedEntryId);

      final rows = await dao
          .watchOnThisDayEntries(day: DateTime(2026, 7, 20))
          .first;

      expect(rows, hasLength(1));
      expect(rows.single.entry.id, priorEntryId);
      expect(rows.single.entry.note, 'Same date last year.');
      expect(rows.single.photoRelativePath, 'mood_photos/memory.jpg');
    } finally {
      await db.close();
    }
  });

  test('updates entry details and replaces links transactionally', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final dao = MoodEntryDao(db);

    try {
      final workActivity = await (db.select(
        db.activities,
      )..where((activity) => activity.name.equals('Work'))).getSingle();
      final sleepActivity = await (db.select(
        db.activities,
      )..where((activity) => activity.name.equals('Sleep'))).getSingle();
      final calmSubEmotion = await (db.select(
        db.subEmotions,
      )..where((subEmotion) => subEmotion.name.equals('Calm'))).getSingle();
      final energizedSubEmotion =
          await (db.select(db.subEmotions)
                ..where((subEmotion) => subEmotion.name.equals('Energized')))
              .getSingle();

      final entryId = await dao.createEntry(
        moodScore: 4,
        note: 'Original note.',
        photoRelativePath: 'mood_photos/original.jpg',
        activityIds: [workActivity.id],
        subEmotionIds: [calmSubEmotion.id],
      );

      await dao.updateEntry(
        id: entryId,
        moodScore: 5,
        note: 'Edited note.',
        voiceNotePath: 'mood_voices/edited.m4a',
        photoRelativePath: 'mood_photos/edited.jpg',
        activityIds: [sleepActivity.id],
        subEmotionIds: [energizedSubEmotion.id],
      );

      final rows = await dao.watchHistoryEntries().first;

      expect(rows.single.entry.moodScore, 5);
      expect(rows.single.entry.note, 'Edited note.');
      expect(rows.single.entry.voiceNotePath, 'mood_voices/edited.m4a');
      expect(rows.single.photoRelativePath, 'mood_photos/edited.jpg');
      expect(rows.single.activityIds, [sleepActivity.id]);
      expect(rows.single.activityNames, ['Sleep']);
      expect(rows.single.subEmotionIds, [energizedSubEmotion.id]);
      expect(rows.single.subEmotionNames, ['Energized']);
    } finally {
      await db.close();
    }
  });
}

Future<void> _moveEntryTo(
  AppDatabase db,
  int entryId,
  DateTime createdAt,
) async {
  await (db.update(
    db.moodEntries,
  )..where((entry) => entry.id.equals(entryId))).write(
    MoodEntriesCompanion(
      createdAt: Value(createdAt),
      updatedAt: Value(createdAt),
    ),
  );
}
