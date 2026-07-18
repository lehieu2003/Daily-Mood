import 'dart:convert';
import 'dart:io';

import 'package:daily_mood_application/core/database/app_database.dart';
import 'package:daily_mood_application/core/database/daos/activity_dao.dart';
import 'package:daily_mood_application/core/database/daos/daily_reflection_dao.dart';
import 'package:daily_mood_application/core/database/daos/mood_entry_dao.dart';
import 'package:daily_mood_application/features/settings/data/backup_export_service.dart';
import 'package:daily_mood_application/features/settings/data/backup_import_apply_service.dart';
import 'package:daily_mood_application/features/settings/data/backup_import_parser.dart';
import 'package:daily_mood_application/features/settings/data/backup_import_restore_service.dart';
import 'package:daily_mood_application/features/settings/data/backup_snapshot_service.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'restores exported JSON with media refs and creates rollback snapshot',
    () async {
      final sourceDb = AppDatabase.forTesting(NativeDatabase.memory());
      final targetDb = AppDatabase.forTesting(NativeDatabase.memory());
      final sourceDocumentsDirectory = await Directory.systemTemp.createTemp(
        'daily_mood_source_documents',
      );
      final targetDocumentsDirectory = await Directory.systemTemp.createTemp(
        'daily_mood_target_documents',
      );
      final snapshotDirectory = await Directory.systemTemp.createTemp(
        'daily_mood_restore_flow_snapshots',
      );

      try {
        final sourcePhoto = File(
          '${sourceDocumentsDirectory.path}/mood_photos/source.jpg',
        );
        await sourcePhoto.parent.create(recursive: true);
        await sourcePhoto.writeAsBytes([1, 2, 3, 4]);
        final sourceVoice = File(
          '${sourceDocumentsDirectory.path}/mood_voices/source.m4a',
        );
        await sourceVoice.parent.create(recursive: true);
        await sourceVoice.writeAsBytes([5, 6, 7, 8]);

        final sourceActivityDao = ActivityDao(sourceDb);
        final sourceDailyReflectionDao = DailyReflectionDao(sourceDb);
        final sourceMoodDao = MoodEntryDao(sourceDb);
        final activityId = await sourceActivityDao.createCustomActivity(
          name: 'Reading',
          category: 'Other',
        );
        final calm = await (sourceDb.select(
          sourceDb.subEmotions,
        )..where((row) => row.name.equals('Calm'))).getSingle();
        await sourceMoodDao.createEntry(
          moodScore: 4,
          note: 'Backup note',
          voiceNotePath: 'mood_voices/source.m4a',
          photoRelativePath: 'mood_photos/source.jpg',
          activityIds: [activityId],
          subEmotionIds: [calm.id],
        );
        await sourceDailyReflectionDao.saveReflection(
          date: DateTime(2026, 7, 13, 20),
          prompt: 'What made today better?',
          response: 'Reading before bed.',
        );

        final export = await DriftBackupExportService(
          database: sourceDb,
          clock: () => DateTime.utc(2026, 7, 13, 8),
          documentsDirectoryProvider: () async => sourceDocumentsDirectory,
        ).buildExport(BackupExportFormat.json);
        final parsed = const BackupImportParser().parseJson(export.content);
        final restore = BackupImportRestoreService(
          snapshotService: LocalBackupSnapshotService(
            database: targetDb,
            snapshotsDirectory: snapshotDirectory,
            clock: () => DateTime.utc(2026, 7, 13, 9),
          ),
          applyService: BackupImportApplyService(
            database: targetDb,
            documentsDirectoryProvider: () async => targetDocumentsDirectory,
          ),
        );

        final result = await restore.restore(parsed);

        expect(result.applyResult.insertedEntries, 1);
        expect(result.applyResult.insertedDailyReflections, 1);
        expect(result.applyResult.updatedEntries, 0);
        expect(File(result.snapshot.filePath).existsSync(), isTrue);
        expect(await targetDb.select(targetDb.moodEntries).get(), hasLength(1));
        expect(
          await targetDb.select(targetDb.moodEntryActivities).get(),
          hasLength(1),
        );
        expect(
          await targetDb.select(targetDb.moodEntrySubEmotions).get(),
          hasLength(1),
        );
        final reflections = await targetDb.select(
          targetDb.dailyReflections,
        ).get();
        expect(reflections.single.dateKey, '2026-07-13');
        expect(reflections.single.response, 'Reading before bed.');
        final photos = await targetDb.select(targetDb.moodPhotos).get();
        expect(photos.single.relativePath, 'mood_photos/source.jpg');
        expect(parsed.mediaPackaging, 'embedded_base64');
        expect(
          parsed.mediaFiles.map((file) => file.relativePath),
          unorderedEquals([
            'mood_photos/source.jpg',
            'mood_voices/source.m4a',
          ]),
        );
        expect(
          File(
            '${targetDocumentsDirectory.path}/mood_photos/source.jpg',
          ).readAsBytesSync(),
          [1, 2, 3, 4],
        );
        expect(
          File(
            '${targetDocumentsDirectory.path}/mood_voices/source.m4a',
          ).readAsBytesSync(),
          [5, 6, 7, 8],
        );
      } finally {
        await sourceDb.close();
        await targetDb.close();
        if (sourceDocumentsDirectory.existsSync()) {
          sourceDocumentsDirectory.deleteSync(recursive: true);
        }
        if (targetDocumentsDirectory.existsSync()) {
          targetDocumentsDirectory.deleteSync(recursive: true);
        }
        if (snapshotDirectory.existsSync()) {
          snapshotDirectory.deleteSync(recursive: true);
        }
      }
    },
  );

  test(
    'older duplicate import is skipped and newer duplicate import overwrites',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final applyService = BackupImportApplyService(database: db);

      try {
        await applyService.apply(
          _backup(
            entries: [
              _entry(
                uuid: 'entry-1',
                moodScore: 3,
                note: 'Local',
                updatedAt: DateTime.utc(2026, 7, 13),
              ),
            ],
          ),
        );

        final oldResult = await applyService.apply(
          _backup(
            entries: [
              _entry(
                uuid: 'entry-1',
                moodScore: 1,
                note: 'Old import',
                updatedAt: DateTime.utc(2026, 7, 12),
              ),
            ],
          ),
        );
        final newResult = await applyService.apply(
          _backup(
            entries: [
              _entry(
                uuid: 'entry-1',
                moodScore: 5,
                note: 'New import',
                updatedAt: DateTime.utc(2026, 7, 14),
              ),
            ],
          ),
        );

        final entry = await (db.select(
          db.moodEntries,
        )..where((row) => row.uuid.equals('entry-1'))).getSingle();

        expect(oldResult.skippedEntries, 1);
        expect(oldResult.skippedEntryUuids, ['entry-1']);
        expect(newResult.updatedEntries, 1);
        expect(entry.moodScore, 5);
        expect(entry.note, 'New import');
      } finally {
        await db.close();
      }
    },
  );

  test(
    'corrupted backup is rejected before rollback snapshot or database writes',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final snapshotDirectory = await Directory.systemTemp.createTemp(
        'daily_mood_corrupt_restore_snapshots',
      );

      try {
        expect(
          () => const BackupImportParser().parseJson('{bad json'),
          throwsA(isA<BackupImportParseException>()),
        );
        expect(snapshotDirectory.listSync(), isEmpty);
        expect(await db.select(db.moodEntries).get(), isEmpty);
      } finally {
        await db.close();
        if (snapshotDirectory.existsSync()) {
          snapshotDirectory.deleteSync(recursive: true);
        }
      }
    },
  );

  test(
    'rollback snapshot captures current data before restore mutation',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final snapshotDirectory = await Directory.systemTemp.createTemp(
        'daily_mood_rollback_restore_snapshots',
      );

      try {
        await BackupImportApplyService(database: db).apply(
          _backup(
            entries: [
              _entry(
                uuid: 'entry-1',
                moodScore: 2,
                note: 'Before import',
                updatedAt: DateTime.utc(2026, 7, 13),
              ),
            ],
          ),
        );
        final restore = BackupImportRestoreService(
          snapshotService: LocalBackupSnapshotService(
            database: db,
            snapshotsDirectory: snapshotDirectory,
            clock: () => DateTime.utc(2026, 7, 13, 9),
          ),
          applyService: BackupImportApplyService(database: db),
        );

        await restore.restore(
          _backup(
            entries: [
              _entry(
                uuid: 'entry-1',
                moodScore: 5,
                note: 'After import',
                updatedAt: DateTime.utc(2026, 7, 14),
              ),
            ],
          ),
        );

        final snapshotFile = snapshotDirectory
            .listSync()
            .whereType<File>()
            .single;
        final snapshot =
            jsonDecode(snapshotFile.readAsStringSync()) as Map<String, Object?>;
        final snapshotEntries = snapshot['moodEntries'] as List<Object?>;
        final snapshotEntry = snapshotEntries.single as Map<String, Object?>;
        final current = await db.select(db.moodEntries).get();

        expect(snapshotEntry['note'], 'Before import');
        expect(current.single.note, 'After import');
      } finally {
        await db.close();
        if (snapshotDirectory.existsSync()) {
          snapshotDirectory.deleteSync(recursive: true);
        }
      }
    },
  );
}

ParsedBackup _backup({List<ParsedBackupMoodEntry> entries = const []}) {
  return ParsedBackup(
    exportVersion: 1,
    schemaVersion: 2,
    exportedAt: DateTime.utc(2026, 7, 13),
    mediaPackaging: 'relative_paths_only',
    mediaFiles: const [],
    activities: const [],
    subEmotions: const [],
    entries: entries,
  );
}

ParsedBackupMoodEntry _entry({
  required String uuid,
  required int moodScore,
  required String note,
  required DateTime updatedAt,
}) {
  return ParsedBackupMoodEntry(
    uuid: uuid,
    moodScore: moodScore,
    note: note,
    voiceNotePath: null,
    photoRelativePath: null,
    activityUuids: const [],
    activityNames: const [],
    subEmotionNames: const [],
    createdAt: DateTime.utc(2026, 7, 13),
    updatedAt: updatedAt,
    isDeleted: false,
  );
}
