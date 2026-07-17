import 'package:daily_mood_application/core/database/app_database.dart';
import 'package:daily_mood_application/features/settings/data/backup_import_apply_service.dart';
import 'package:daily_mood_application/features/settings/data/backup_import_parser.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('inserts new activities entries links and photo references', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final service = BackupImportApplyService(database: db);

    try {
      final result = await service.apply(
        _backup(
          activities: [_activity(uuid: 'activity-reading', name: 'Reading')],
          entries: [
            _entry(
              uuid: 'entry-1',
              moodScore: 4,
              activityUuids: ['activity-reading'],
              activityNames: ['Reading'],
              subEmotionNames: ['Calm'],
              photoRelativePath: 'mood_photos/photo-1.jpg',
            ),
          ],
        ),
      );

      expect(result.insertedActivities, 1);
      expect(result.insertedEntries, 1);
      expect(result.updatedEntries, 0);
      expect(result.skippedEntries, 0);

      final entries = await db.select(db.moodEntries).get();
      expect(entries.single.uuid, 'entry-1');
      expect(entries.single.moodScore, 4);
      expect(await db.select(db.moodEntryActivities).get(), hasLength(1));
      expect(await db.select(db.moodEntrySubEmotions).get(), hasLength(1));
      expect(await db.select(db.moodPhotos).get(), hasLength(1));
    } finally {
      await db.close();
    }
  });

  test('updates existing entry when imported updatedAt is newer', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final service = BackupImportApplyService(database: db);

    try {
      await service.apply(
        _backup(
          entries: [_entry(uuid: 'entry-1', note: 'Old note')],
        ),
      );

      final result = await service.apply(
        _backup(
          entries: [
            _entry(
              uuid: 'entry-1',
              moodScore: 5,
              note: 'New note',
              updatedAt: DateTime.utc(2026, 7, 14),
            ),
          ],
        ),
      );

      final entry = await (db.select(
        db.moodEntries,
      )..where((row) => row.uuid.equals('entry-1'))).getSingle();

      expect(result.insertedEntries, 0);
      expect(result.updatedEntries, 1);
      expect(result.skippedEntries, 0);
      expect(entry.moodScore, 5);
      expect(entry.note, 'New note');
      expect(entry.updatedAt.toUtc(), DateTime.utc(2026, 7, 14));
    } finally {
      await db.close();
    }
  });

  test(
    'skips existing entry when imported updatedAt is older or equal',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final service = BackupImportApplyService(database: db);

      try {
        await service.apply(
          _backup(
            entries: [
              _entry(
                uuid: 'entry-1',
                moodScore: 4,
                note: 'Local value',
                updatedAt: DateTime.utc(2026, 7, 14),
              ),
            ],
          ),
        );

        final result = await service.apply(
          _backup(
            entries: [
              _entry(
                uuid: 'entry-1',
                moodScore: 1,
                note: 'Older import',
                updatedAt: DateTime.utc(2026, 7, 13),
              ),
            ],
          ),
        );

        final entry = await (db.select(
          db.moodEntries,
        )..where((row) => row.uuid.equals('entry-1'))).getSingle();

        expect(result.insertedEntries, 0);
        expect(result.updatedEntries, 0);
        expect(result.skippedEntries, 1);
        expect(result.skippedEntryUuids, ['entry-1']);
        expect(entry.moodScore, 4);
        expect(entry.note, 'Local value');
      } finally {
        await db.close();
      }
    },
  );

  test('newer imported entry replaces old links and photo reference', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final service = BackupImportApplyService(database: db);

    try {
      await service.apply(
        _backup(
          activities: [_activity(uuid: 'activity-old', name: 'Reading')],
          entries: [
            _entry(
              uuid: 'entry-1',
              activityUuids: ['activity-old'],
              activityNames: ['Reading'],
              subEmotionNames: ['Calm'],
              photoRelativePath: 'mood_photos/old.jpg',
            ),
          ],
        ),
      );

      await service.apply(
        _backup(
          activities: [_activity(uuid: 'activity-new', name: 'Walking')],
          entries: [
            _entry(
              uuid: 'entry-1',
              activityUuids: ['activity-new'],
              activityNames: ['Walking'],
              subEmotionNames: ['Excited'],
              photoRelativePath: 'mood_photos/new.jpg',
              updatedAt: DateTime.utc(2026, 7, 14),
            ),
          ],
        ),
      );

      final photos = await db.select(db.moodPhotos).get();
      final linkedActivities = await db.select(db.moodEntryActivities).get();
      final linkedSubEmotions = await db.select(db.moodEntrySubEmotions).get();
      final walking = await (db.select(
        db.activities,
      )..where((row) => row.name.equals('Walking'))).getSingle();
      final excited = await (db.select(
        db.subEmotions,
      )..where((row) => row.name.equals('Excited'))).getSingle();

      expect(photos, hasLength(1));
      expect(photos.single.relativePath, 'mood_photos/new.jpg');
      expect(linkedActivities.single.activityId, walking.id);
      expect(linkedSubEmotions.single.subEmotionId, excited.id);
    } finally {
      await db.close();
    }
  });
}

ParsedBackup _backup({
  List<ParsedBackupActivity> activities = const [],
  List<ParsedBackupMoodEntry> entries = const [],
}) {
  return ParsedBackup(
    exportVersion: 1,
    schemaVersion: 2,
    exportedAt: DateTime.utc(2026, 7, 13),
    mediaPackaging: 'relative_paths_only',
    mediaFiles: const [],
    activities: activities,
    subEmotions: const [],
    entries: entries,
  );
}

ParsedBackupActivity _activity({required String uuid, required String name}) {
  return ParsedBackupActivity(
    uuid: uuid,
    name: name,
    category: 'Other',
    isCustom: true,
    isArchived: false,
    createdAt: DateTime.utc(2026, 7, 13),
  );
}

ParsedBackupMoodEntry _entry({
  required String uuid,
  int moodScore = 4,
  String? note,
  List<String> activityUuids = const [],
  List<String> activityNames = const [],
  List<String> subEmotionNames = const [],
  String? photoRelativePath,
  DateTime? updatedAt,
}) {
  return ParsedBackupMoodEntry(
    uuid: uuid,
    moodScore: moodScore,
    note: note,
    voiceNotePath: null,
    photoRelativePath: photoRelativePath,
    activityUuids: activityUuids,
    activityNames: activityNames,
    subEmotionNames: subEmotionNames,
    createdAt: DateTime.utc(2026, 7, 13),
    updatedAt: updatedAt ?? DateTime.utc(2026, 7, 13, 1),
    isDeleted: false,
  );
}
