import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/database/app_database.dart';

enum BackupExportFormat {
  json(extension: 'json', label: 'JSON'),
  csv(extension: 'csv', label: 'CSV');

  const BackupExportFormat({required this.extension, required this.label});

  final String extension;
  final String label;
}

final class BackupExportFile {
  const BackupExportFile({
    required this.format,
    required this.fileName,
    required this.content,
  });

  final BackupExportFormat format;
  final String fileName;
  final String content;
}

abstract interface class BackupExportService {
  Future<BackupExportFile> buildExport(BackupExportFormat format);

  Future<BackupExportFile> exportAndShare(BackupExportFormat format);
}

final class DriftBackupExportService implements BackupExportService {
  DriftBackupExportService({
    required AppDatabase database,
    BackupFileSharer? fileSharer,
    DateTime Function()? clock,
    Future<Directory> Function()? documentsDirectoryProvider,
  }) : _database = database,
       _fileSharer = fileSharer ?? const BackupFileSharer(),
       _clock = clock ?? DateTime.now,
       _documentsDirectoryProvider =
           documentsDirectoryProvider ?? getApplicationDocumentsDirectory;

  final AppDatabase _database;
  final BackupFileSharer _fileSharer;
  final DateTime Function() _clock;
  final Future<Directory> Function() _documentsDirectoryProvider;

  @override
  Future<BackupExportFile> buildExport(BackupExportFormat format) async {
    final exportedAt = _clock().toUtc();
    final snapshot = await _BackupSnapshot.fromDatabase(
      _database,
      exportedAt: exportedAt,
      documentsDirectoryProvider: _documentsDirectoryProvider,
    );
    final content = switch (format) {
      BackupExportFormat.json => const JsonEncoder.withIndent(
        '  ',
      ).convert(snapshot.toJson()),
      BackupExportFormat.csv => snapshot.toCsv(),
    };

    return BackupExportFile(
      format: format,
      fileName:
          'daily_mood_export_${_timestamp(exportedAt)}.'
          '${format.extension}',
      content: content,
    );
  }

  @override
  Future<BackupExportFile> exportAndShare(BackupExportFormat format) async {
    final file = await buildExport(format);
    await _fileSharer.share(file);
    return file;
  }

  String _timestamp(DateTime dateTime) {
    String two(int value) => value.toString().padLeft(2, '0');

    return '${dateTime.year}${two(dateTime.month)}${two(dateTime.day)}_'
        '${two(dateTime.hour)}${two(dateTime.minute)}${two(dateTime.second)}';
  }
}

final class BackupFileSharer {
  const BackupFileSharer();

  Future<void> share(BackupExportFile file) async {
    final tempDirectory = await getTemporaryDirectory();
    final exportFile = File(p.join(tempDirectory.path, file.fileName));
    await exportFile.writeAsString(file.content, flush: true);

    await SharePlus.instance.share(
      ShareParams(
        subject: 'Daily Mood ${file.format.label} export',
        text: 'Daily Mood ${file.format.label} export',
        files: [XFile(exportFile.path)],
      ),
    );
  }
}

final class _BackupSnapshot {
  const _BackupSnapshot({
    required this.exportedAt,
    required this.schemaVersion,
    required this.activities,
    required this.subEmotions,
    required this.entries,
    required this.mediaFiles,
  });

  final DateTime exportedAt;
  final int schemaVersion;
  final List<Activity> activities;
  final List<SubEmotion> subEmotions;
  final List<_ExportMoodEntry> entries;
  final List<_ExportMediaFile> mediaFiles;

  static Future<_BackupSnapshot> fromDatabase(
    AppDatabase database, {
    required DateTime exportedAt,
    required Future<Directory> Function() documentsDirectoryProvider,
  }) async {
    final entries = await (database.select(
      database.moodEntries,
    )..orderBy([(row) => OrderingTerm.asc(row.createdAt)])).get();
    final activities = await (database.select(
      database.activities,
    )..orderBy([(row) => OrderingTerm.asc(row.name)])).get();
    final subEmotions = await (database.select(
      database.subEmotions,
    )..orderBy([(row) => OrderingTerm.asc(row.id)])).get();
    final entryActivities = await database
        .select(database.moodEntryActivities)
        .get();
    final entrySubEmotions = await database
        .select(database.moodEntrySubEmotions)
        .get();
    final photos = await database.select(database.moodPhotos).get();

    final activitiesById = {
      for (final activity in activities) activity.id: activity,
    };
    final subEmotionsById = {
      for (final subEmotion in subEmotions) subEmotion.id: subEmotion,
    };
    final activitiesByEntryId = <int, List<Activity>>{};
    for (final link in entryActivities) {
      final activity = activitiesById[link.activityId];
      if (activity == null) continue;
      activitiesByEntryId.putIfAbsent(link.moodEntryId, () => []).add(activity);
    }
    final subEmotionsByEntryId = <int, List<SubEmotion>>{};
    for (final link in entrySubEmotions) {
      final subEmotion = subEmotionsById[link.subEmotionId];
      if (subEmotion == null) continue;
      subEmotionsByEntryId
          .putIfAbsent(link.moodEntryId, () => [])
          .add(subEmotion);
    }
    final photosByEntryId = {
      for (final photo in photos) photo.moodEntryId: photo,
    };
    final mediaPaths = <String>{
      for (final entry in entries)
        if (entry.voiceNotePath != null) entry.voiceNotePath!,
      for (final photo in photos) photo.relativePath,
    };

    return _BackupSnapshot(
      exportedAt: exportedAt,
      schemaVersion: database.schemaVersion,
      activities: activities,
      subEmotions: subEmotions,
      mediaFiles: await _ExportMediaFile.fromRelativePaths(
        mediaPaths,
        documentsDirectoryProvider: documentsDirectoryProvider,
      ),
      entries: entries
          .map(
            (entry) => _ExportMoodEntry(
              entry: entry,
              activities: activitiesByEntryId[entry.id] ?? const [],
              subEmotions: subEmotionsByEntryId[entry.id] ?? const [],
              photo: photosByEntryId[entry.id],
            ),
          )
          .toList(growable: false),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'exportVersion': 1,
      'schemaVersion': schemaVersion,
      'exportedAt': exportedAt.toIso8601String(),
      'mediaPackaging': 'embedded_base64',
      'mediaFiles': mediaFiles.map((file) => file.toJson()).toList(
        growable: false,
      ),
      'activities': activities.map(_activityToJson).toList(growable: false),
      'subEmotions': subEmotions.map(_subEmotionToJson).toList(growable: false),
      'moodEntries': entries
          .map((entry) => entry.toJson())
          .toList(growable: false),
    };
  }

  String toCsv() {
    final rows = <List<Object?>>[
      [
        'uuid',
        'moodScore',
        'note',
        'voiceNotePath',
        'photoRelativePath',
        'activities',
        'subEmotions',
        'createdAt',
        'updatedAt',
        'isDeleted',
      ],
      ...entries.map((entry) => entry.toCsvRow()),
    ];

    return rows.map(_csvRow).join('\n');
  }

  Map<String, Object?> _activityToJson(Activity activity) {
    return {
      'uuid': activity.uuid,
      'name': activity.name,
      'category': activity.category,
      'isCustom': activity.isCustom,
      'isArchived': activity.isArchived,
      'createdAt': activity.createdAt.toUtc().toIso8601String(),
    };
  }

  Map<String, Object?> _subEmotionToJson(SubEmotion subEmotion) {
    return {
      'name': subEmotion.name,
      'emoji': subEmotion.emoji,
      'parentMoodScore': subEmotion.parentMoodScore,
    };
  }

  String _csvRow(List<Object?> values) {
    return values.map(_csvCell).join(',');
  }

  String _csvCell(Object? value) {
    final text = value?.toString() ?? '';
    final escaped = text.replaceAll('"', '""');
    return '"$escaped"';
  }
}

final class _ExportMediaFile {
  const _ExportMediaFile({required this.relativePath, required this.bytes});

  final String relativePath;
  final List<int> bytes;

  static Future<List<_ExportMediaFile>> fromRelativePaths(
    Set<String> relativePaths, {
    required Future<Directory> Function() documentsDirectoryProvider,
  }) async {
    if (relativePaths.isEmpty) return const [];

    final documents = await documentsDirectoryProvider();
    final files = <_ExportMediaFile>[];
    for (final relativePath in relativePaths) {
      final normalizedPath = _normalizeMediaRelativePath(relativePath);
      if (normalizedPath == null) continue;

      final file = File(
        p.joinAll([documents.path, ...p.posix.split(normalizedPath)]),
      );
      if (!await file.exists()) continue;

      files.add(
        _ExportMediaFile(
          relativePath: normalizedPath,
          bytes: await file.readAsBytes(),
        ),
      );
    }
    return files;
  }

  Map<String, Object?> toJson() {
    return {
      'relativePath': relativePath,
      'contentBase64': base64Encode(bytes),
    };
  }

  static String? _normalizeMediaRelativePath(String relativePath) {
    final path = relativePath.replaceAll('\\', '/');
    final normalizedPath = p.posix.normalize(path);
    final segments = p.posix.split(normalizedPath);
    if (p.posix.isAbsolute(path) ||
        normalizedPath == '.' ||
        normalizedPath == '..' ||
        normalizedPath.startsWith('../') ||
        segments.length < 2 ||
        (segments.first != 'mood_photos' && segments.first != 'mood_voices')) {
      return null;
    }
    return normalizedPath;
  }
}

final class _ExportMoodEntry {
  const _ExportMoodEntry({
    required this.entry,
    required this.activities,
    required this.subEmotions,
    required this.photo,
  });

  final MoodEntry entry;
  final List<Activity> activities;
  final List<SubEmotion> subEmotions;
  final MoodPhoto? photo;

  Map<String, Object?> toJson() {
    return {
      'uuid': entry.uuid,
      'moodScore': entry.moodScore,
      'note': entry.note,
      'voiceNotePath': entry.voiceNotePath,
      'photoRelativePath': photo?.relativePath,
      'activityUuids': activities
          .map((activity) => activity.uuid)
          .toList(growable: false),
      'activities': activities
          .map((activity) => activity.name)
          .toList(growable: false),
      'subEmotions': subEmotions
          .map((subEmotion) => subEmotion.name)
          .toList(growable: false),
      'createdAt': entry.createdAt.toUtc().toIso8601String(),
      'updatedAt': entry.updatedAt.toUtc().toIso8601String(),
      'isDeleted': entry.isDeleted,
    };
  }

  List<Object?> toCsvRow() {
    return [
      entry.uuid,
      entry.moodScore,
      entry.note,
      entry.voiceNotePath,
      photo?.relativePath,
      activities.map((activity) => activity.name).join('; '),
      subEmotions.map((subEmotion) => subEmotion.name).join('; '),
      entry.createdAt.toUtc().toIso8601String(),
      entry.updatedAt.toUtc().toIso8601String(),
      entry.isDeleted,
    ];
  }
}
