import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/database/app_database.dart';
import 'backup_import_parser.dart';

final class BackupImportApplyResult {
  const BackupImportApplyResult({
    required this.insertedActivities,
    required this.skippedActivities,
    required this.insertedEntries,
    required this.updatedEntries,
    required this.skippedEntries,
    required this.skippedEntryUuids,
  });

  final int insertedActivities;
  final int skippedActivities;
  final int insertedEntries;
  final int updatedEntries;
  final int skippedEntries;
  final List<String> skippedEntryUuids;
}

abstract interface class BackupImportApplier {
  Future<BackupImportApplyResult> apply(ParsedBackup backup);
}

final class BackupImportApplyService implements BackupImportApplier {
  BackupImportApplyService({
    required AppDatabase database,
    Future<Directory> Function()? documentsDirectoryProvider,
  }) : _database = database,
       _documentsDirectoryProvider =
           documentsDirectoryProvider ?? getApplicationDocumentsDirectory;

  final AppDatabase _database;
  final Future<Directory> Function() _documentsDirectoryProvider;

  @override
  Future<BackupImportApplyResult> apply(ParsedBackup backup) {
    return _database.transaction(() async {
      var insertedActivities = 0;
      var skippedActivities = 0;
      var insertedEntries = 0;
      var updatedEntries = 0;
      var skippedEntries = 0;
      final skippedEntryUuids = <String>[];

      final activityIdByImportedUuid = <String, int>{};
      for (final activity in backup.activities) {
        final resolved = await _resolveActivity(activity);
        activityIdByImportedUuid[activity.uuid] = resolved.id;
        if (resolved.wasInserted) {
          insertedActivities++;
        } else {
          skippedActivities++;
        }
      }

      final subEmotionIdByName = {
        for (final subEmotion
            in await _database.select(_database.subEmotions).get())
          subEmotion.name: subEmotion.id,
      };

      for (final entry in backup.entries) {
        final existing = await _entryByUuid(entry.uuid);
        if (existing == null) {
          final entryId = await _insertEntry(entry);
          await _replaceEntryLinks(
            entryId: entryId,
            entry: entry,
            activityIdByImportedUuid: activityIdByImportedUuid,
            subEmotionIdByName: subEmotionIdByName,
          );
          await _restoreEntryMedia(entry, backup.mediaFiles);
          insertedEntries++;
          continue;
        }

        if (!entry.updatedAt.isAfter(existing.updatedAt.toUtc())) {
          skippedEntries++;
          skippedEntryUuids.add(entry.uuid);
          continue;
        }

        await _updateEntry(existing.id, entry);
        await _replaceEntryLinks(
          entryId: existing.id,
          entry: entry,
          activityIdByImportedUuid: activityIdByImportedUuid,
          subEmotionIdByName: subEmotionIdByName,
        );
        await _restoreEntryMedia(entry, backup.mediaFiles);
        updatedEntries++;
      }

      return BackupImportApplyResult(
        insertedActivities: insertedActivities,
        skippedActivities: skippedActivities,
        insertedEntries: insertedEntries,
        updatedEntries: updatedEntries,
        skippedEntries: skippedEntries,
        skippedEntryUuids: List.unmodifiable(skippedEntryUuids),
      );
    });
  }

  Future<_ResolvedActivity> _resolveActivity(
    ParsedBackupActivity imported,
  ) async {
    final byUuid = await _activityByUuid(imported.uuid);
    if (byUuid != null) {
      return _ResolvedActivity(id: byUuid.id, wasInserted: false);
    }

    final byName = await _activityByName(imported.name);
    if (byName != null) {
      return _ResolvedActivity(id: byName.id, wasInserted: false);
    }

    final id = await _database
        .into(_database.activities)
        .insert(
          ActivitiesCompanion.insert(
            uuid: imported.uuid,
            name: imported.name,
            category: imported.category,
            isCustom: Value(imported.isCustom),
            isArchived: Value(imported.isArchived),
            createdAt: imported.createdAt,
          ),
        );
    return _ResolvedActivity(id: id, wasInserted: true);
  }

  Future<Activity?> _activityByUuid(String uuid) {
    return (_database.select(
      _database.activities,
    )..where((row) => row.uuid.equals(uuid))).getSingleOrNull();
  }

  Future<Activity?> _activityByName(String name) {
    return (_database.select(
      _database.activities,
    )..where((row) => row.name.equals(name))).getSingleOrNull();
  }

  Future<MoodEntry?> _entryByUuid(String uuid) {
    return (_database.select(
      _database.moodEntries,
    )..where((row) => row.uuid.equals(uuid))).getSingleOrNull();
  }

  Future<int> _insertEntry(ParsedBackupMoodEntry entry) {
    return _database
        .into(_database.moodEntries)
        .insert(
          MoodEntriesCompanion.insert(
            uuid: entry.uuid,
            moodScore: entry.moodScore,
            note: Value(entry.note),
            voiceNotePath: Value(entry.voiceNotePath),
            createdAt: entry.createdAt,
            updatedAt: entry.updatedAt,
            isDeleted: Value(entry.isDeleted),
          ),
        );
  }

  Future<void> _updateEntry(int id, ParsedBackupMoodEntry entry) {
    return (_database.update(
      _database.moodEntries,
    )..where((row) => row.id.equals(id))).write(
      MoodEntriesCompanion(
        moodScore: Value(entry.moodScore),
        note: Value(entry.note),
        voiceNotePath: Value(entry.voiceNotePath),
        createdAt: Value(entry.createdAt),
        updatedAt: Value(entry.updatedAt),
        isDeleted: Value(entry.isDeleted),
      ),
    );
  }

  Future<void> _replaceEntryLinks({
    required int entryId,
    required ParsedBackupMoodEntry entry,
    required Map<String, int> activityIdByImportedUuid,
    required Map<String, int> subEmotionIdByName,
  }) async {
    await (_database.delete(
      _database.moodEntryActivities,
    )..where((row) => row.moodEntryId.equals(entryId))).go();
    await (_database.delete(
      _database.moodEntrySubEmotions,
    )..where((row) => row.moodEntryId.equals(entryId))).go();
    await (_database.delete(
      _database.moodPhotos,
    )..where((row) => row.moodEntryId.equals(entryId))).go();

    final activityIds = await _resolveActivityIds(
      entry,
      activityIdByImportedUuid,
    );
    if (activityIds.isNotEmpty) {
      await _database.batch((batch) {
        batch.insertAll(
          _database.moodEntryActivities,
          activityIds
              .map(
                (activityId) => MoodEntryActivitiesCompanion.insert(
                  moodEntryId: entryId,
                  activityId: activityId,
                ),
              )
              .toList(growable: false),
        );
      });
    }

    final subEmotionIds = entry.subEmotionNames
        .map((name) => subEmotionIdByName[name])
        .whereType<int>()
        .toSet();
    if (subEmotionIds.isNotEmpty) {
      await _database.batch((batch) {
        batch.insertAll(
          _database.moodEntrySubEmotions,
          subEmotionIds
              .map(
                (subEmotionId) => MoodEntrySubEmotionsCompanion.insert(
                  moodEntryId: entryId,
                  subEmotionId: subEmotionId,
                ),
              )
              .toList(growable: false),
        );
      });
    }

    final photoPath = entry.photoRelativePath;
    if (photoPath != null) {
      await _database
          .into(_database.moodPhotos)
          .insert(
            MoodPhotosCompanion.insert(
              moodEntryId: entryId,
              relativePath: photoPath,
              createdAt: entry.createdAt,
            ),
          );
    }
  }

  Future<Set<int>> _resolveActivityIds(
    ParsedBackupMoodEntry entry,
    Map<String, int> activityIdByImportedUuid,
  ) async {
    final activityIds = <int>{};
    for (final uuid in entry.activityUuids) {
      final id =
          activityIdByImportedUuid[uuid] ?? (await _activityByUuid(uuid))?.id;
      if (id != null) {
        activityIds.add(id);
      }
    }

    for (final name in entry.activityNames) {
      final id = (await _activityByName(name))?.id;
      if (id != null) {
        activityIds.add(id);
      }
    }
    return activityIds;
  }

  Future<void> _restoreEntryMedia(
    ParsedBackupMoodEntry entry,
    List<ParsedBackupMediaFile> mediaFiles,
  ) async {
    if (mediaFiles.isEmpty) return;

    final referencedPaths = {
      if (entry.photoRelativePath != null) entry.photoRelativePath!,
      if (entry.voiceNotePath != null) entry.voiceNotePath!,
    };
    if (referencedPaths.isEmpty) return;

    final mediaByPath = {
      for (final mediaFile in mediaFiles) mediaFile.relativePath: mediaFile,
    };
    for (final relativePath in referencedPaths) {
      final mediaFile = mediaByPath[relativePath];
      if (mediaFile == null) continue;
      await _writeMediaFile(mediaFile);
    }
  }

  Future<void> _writeMediaFile(ParsedBackupMediaFile mediaFile) async {
    final documents = await _documentsDirectoryProvider();
    final relativePath = _normalizeMediaRelativePath(mediaFile.relativePath);
    final target = File(
      p.joinAll([documents.path, ...p.posix.split(relativePath)]),
    );
    await target.parent.create(recursive: true);

    final temp = File('${target.path}.importing');
    await temp.writeAsBytes(mediaFile.bytes, flush: true);
    if (await target.exists()) {
      await target.delete();
    }
    await temp.rename(target.path);
  }

  String _normalizeMediaRelativePath(String relativePath) {
    final path = relativePath.replaceAll('\\', '/');
    final normalizedPath = p.posix.normalize(path);
    final segments = p.posix.split(normalizedPath);
    if (p.posix.isAbsolute(path) ||
        normalizedPath == '.' ||
        normalizedPath == '..' ||
        normalizedPath.startsWith('../') ||
        segments.length < 2 ||
        (segments.first != 'mood_photos' && segments.first != 'mood_voices')) {
      throw ArgumentError.value(
        relativePath,
        'relativePath',
        'Must be a relative mood media path.',
      );
    }
    return normalizedPath;
  }
}

final class _ResolvedActivity {
  const _ResolvedActivity({required this.id, required this.wasInserted});

  final int id;
  final bool wasInserted;
}
