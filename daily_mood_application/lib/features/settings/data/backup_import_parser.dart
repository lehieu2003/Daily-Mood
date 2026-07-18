import 'dart:convert';

enum BackupImportFormat { json, csv }

final class BackupImportParseException implements Exception {
  const BackupImportParseException(this.message);

  final String message;

  @override
  String toString() => 'BackupImportParseException: $message';
}

final class ParsedBackup {
  const ParsedBackup({
    required this.exportVersion,
    required this.schemaVersion,
    required this.exportedAt,
    required this.mediaPackaging,
    required this.mediaFiles,
    required this.activities,
    required this.subEmotions,
    required this.entries,
    this.dailyReflections = const [],
  });

  final int exportVersion;
  final int schemaVersion;
  final DateTime? exportedAt;
  final String? mediaPackaging;
  final List<ParsedBackupMediaFile> mediaFiles;
  final List<ParsedBackupActivity> activities;
  final List<ParsedBackupSubEmotion> subEmotions;
  final List<ParsedBackupMoodEntry> entries;
  final List<ParsedBackupDailyReflection> dailyReflections;
}

final class ParsedBackupMediaFile {
  const ParsedBackupMediaFile({
    required this.relativePath,
    required this.bytes,
  });

  final String relativePath;
  final List<int> bytes;
}

final class ParsedBackupActivity {
  const ParsedBackupActivity({
    required this.uuid,
    required this.name,
    required this.category,
    required this.isCustom,
    required this.isArchived,
    required this.createdAt,
  });

  final String uuid;
  final String name;
  final String category;
  final bool isCustom;
  final bool isArchived;
  final DateTime createdAt;
}

final class ParsedBackupSubEmotion {
  const ParsedBackupSubEmotion({
    required this.name,
    required this.emoji,
    required this.parentMoodScore,
  });

  final String name;
  final String emoji;
  final int parentMoodScore;
}

final class ParsedBackupMoodEntry {
  const ParsedBackupMoodEntry({
    required this.uuid,
    required this.moodScore,
    required this.note,
    required this.voiceNotePath,
    required this.photoRelativePath,
    required this.activityUuids,
    required this.activityNames,
    required this.subEmotionNames,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
  });

  final String uuid;
  final int moodScore;
  final String? note;
  final String? voiceNotePath;
  final String? photoRelativePath;
  final List<String> activityUuids;
  final List<String> activityNames;
  final List<String> subEmotionNames;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
}

final class ParsedBackupDailyReflection {
  const ParsedBackupDailyReflection({
    required this.uuid,
    required this.dateKey,
    required this.prompt,
    required this.response,
    required this.createdAt,
    required this.updatedAt,
  });

  final String uuid;
  final String dateKey;
  final String prompt;
  final String response;
  final DateTime createdAt;
  final DateTime updatedAt;
}

final class BackupImportParser {
  const BackupImportParser();

  ParsedBackup parse(String content, BackupImportFormat format) {
    return switch (format) {
      BackupImportFormat.json => parseJson(content),
      BackupImportFormat.csv => parseCsv(content),
    };
  }

  ParsedBackup parseJson(String content) {
    final Object? decoded;
    try {
      decoded = jsonDecode(content);
    } on FormatException catch (_) {
      throw const BackupImportParseException('Backup file is not valid JSON.');
    }

    final root = _asMap(decoded, 'backup');
    final exportVersion = _requiredInt(root, 'exportVersion', 'backup');
    if (exportVersion != 1) {
      throw BackupImportParseException(
        'Unsupported backup export version: $exportVersion.',
      );
    }

    final schemaVersion = _requiredInt(root, 'schemaVersion', 'backup');
    final entries = _requiredList(root, 'moodEntries', 'backup')
        .asMap()
        .entries
        .map((entry) {
          final path = 'moodEntries[${entry.key}]';
          return _parseMoodEntryJson(_asMap(entry.value, path), path);
        })
        .toList(growable: false);
    final dailyReflections = _optionalList(root, 'dailyReflections', 'backup')
        .asMap()
        .entries
        .map((entry) {
          final path = 'dailyReflections[${entry.key}]';
          return _parseDailyReflectionJson(_asMap(entry.value, path), path);
        })
        .toList(growable: false);

    _rejectDuplicateEntryUuids(entries);
    _rejectDuplicateDailyReflections(dailyReflections);

    return ParsedBackup(
      exportVersion: exportVersion,
      schemaVersion: schemaVersion,
      exportedAt: _optionalDateTime(root, 'exportedAt', 'backup'),
      mediaPackaging: _optionalString(root, 'mediaPackaging', 'backup'),
      mediaFiles: _optionalList(root, 'mediaFiles', 'backup')
          .asMap()
          .entries
          .map((entry) {
            final path = 'mediaFiles[${entry.key}]';
            return _parseMediaFileJson(_asMap(entry.value, path), path);
          })
          .toList(growable: false),
      activities: _optionalList(root, 'activities', 'backup')
          .asMap()
          .entries
          .map((entry) {
            final path = 'activities[${entry.key}]';
            return _parseActivityJson(_asMap(entry.value, path), path);
          })
          .toList(growable: false),
      subEmotions: _optionalList(root, 'subEmotions', 'backup')
          .asMap()
          .entries
          .map((entry) {
            final path = 'subEmotions[${entry.key}]';
            return _parseSubEmotionJson(_asMap(entry.value, path), path);
          })
          .toList(growable: false),
      entries: entries,
      dailyReflections: dailyReflections,
    );
  }

  ParsedBackup parseCsv(String content) {
    final rows = _parseCsvRows(content);
    if (rows.isEmpty) {
      throw const BackupImportParseException('CSV backup is empty.');
    }

    const expectedHeader = [
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
    ];
    final header = rows.first;
    if (!_listEquals(header, expectedHeader)) {
      throw const BackupImportParseException(
        'CSV backup header is not supported.',
      );
    }

    final entries = <ParsedBackupMoodEntry>[];
    for (var index = 1; index < rows.length; index++) {
      final row = rows[index];
      if (row.length == 1 && row.single.trim().isEmpty) continue;
      if (row.length != expectedHeader.length) {
        throw BackupImportParseException(
          'CSV row ${index + 1} has ${row.length} fields; expected '
          '${expectedHeader.length}.',
        );
      }
      entries.add(_parseMoodEntryCsv(row, index + 1));
    }

    _rejectDuplicateEntryUuids(entries);

    return ParsedBackup(
      exportVersion: 1,
      schemaVersion: 0,
      exportedAt: null,
      mediaPackaging: 'relative_paths_only',
      mediaFiles: const [],
      activities: const [],
      subEmotions: const [],
      entries: entries,
      dailyReflections: const [],
    );
  }

  ParsedBackupMoodEntry _parseMoodEntryJson(
    Map<String, Object?> value,
    String path,
  ) {
    return ParsedBackupMoodEntry(
      uuid: _requiredNonEmptyString(value, 'uuid', path),
      moodScore: _requiredMoodScore(value, 'moodScore', path),
      note: _optionalString(value, 'note', path),
      voiceNotePath: _optionalRelativePath(value, 'voiceNotePath', path),
      photoRelativePath: _optionalRelativePath(
        value,
        'photoRelativePath',
        path,
      ),
      activityUuids: _optionalStringList(value, 'activityUuids', path),
      activityNames: _optionalStringList(value, 'activities', path),
      subEmotionNames: _optionalStringList(value, 'subEmotions', path),
      createdAt: _requiredDateTime(value, 'createdAt', path),
      updatedAt: _requiredDateTime(value, 'updatedAt', path),
      isDeleted: _optionalBool(value, 'isDeleted', path) ?? false,
    );
  }

  ParsedBackupMediaFile _parseMediaFileJson(
    Map<String, Object?> value,
    String path,
  ) {
    final encoded = _requiredNonEmptyString(value, 'contentBase64', path);
    final bytes = _parseBase64Bytes(encoded, '$path.contentBase64');
    return ParsedBackupMediaFile(
      relativePath: _requiredMediaRelativePath(value, 'relativePath', path),
      bytes: bytes,
    );
  }

  ParsedBackupActivity _parseActivityJson(
    Map<String, Object?> value,
    String path,
  ) {
    return ParsedBackupActivity(
      uuid: _requiredNonEmptyString(value, 'uuid', path),
      name: _requiredNonEmptyString(value, 'name', path),
      category: _requiredNonEmptyString(value, 'category', path),
      isCustom: _optionalBool(value, 'isCustom', path) ?? false,
      isArchived: _optionalBool(value, 'isArchived', path) ?? false,
      createdAt: _requiredDateTime(value, 'createdAt', path),
    );
  }

  ParsedBackupSubEmotion _parseSubEmotionJson(
    Map<String, Object?> value,
    String path,
  ) {
    return ParsedBackupSubEmotion(
      name: _requiredNonEmptyString(value, 'name', path),
      emoji: _requiredNonEmptyString(value, 'emoji', path),
      parentMoodScore: _requiredMoodScore(value, 'parentMoodScore', path),
    );
  }

  ParsedBackupDailyReflection _parseDailyReflectionJson(
    Map<String, Object?> value,
    String path,
  ) {
    return ParsedBackupDailyReflection(
      uuid: _requiredNonEmptyString(value, 'uuid', path),
      dateKey: _requiredDateKey(value, 'dateKey', path),
      prompt: _requiredNonEmptyString(value, 'prompt', path),
      response: _requiredMaxLengthText(value, 'response', path, 280),
      createdAt: _requiredDateTime(value, 'createdAt', path),
      updatedAt: _requiredDateTime(value, 'updatedAt', path),
    );
  }

  ParsedBackupMoodEntry _parseMoodEntryCsv(List<String> row, int rowNumber) {
    final path = 'CSV row $rowNumber';
    return ParsedBackupMoodEntry(
      uuid: _nonEmptyText(row[0], '$path uuid'),
      moodScore: _parseMoodScoreText(row[1], '$path moodScore'),
      note: _nullableText(row[2]),
      voiceNotePath: _relativePathText(row[3], '$path voiceNotePath'),
      photoRelativePath: _relativePathText(row[4], '$path photoRelativePath'),
      activityUuids: const [],
      activityNames: _splitNameList(row[5]),
      subEmotionNames: _splitNameList(row[6]),
      createdAt: _parseDateTimeText(row[7], '$path createdAt'),
      updatedAt: _parseDateTimeText(row[8], '$path updatedAt'),
      isDeleted: _parseBoolText(row[9], '$path isDeleted'),
    );
  }

  Map<String, Object?> _asMap(Object? value, String path) {
    if (value is Map) {
      try {
        return value.cast<String, Object?>();
      } on TypeError catch (_) {
        throw BackupImportParseException('$path must be an object.');
      }
    }
    throw BackupImportParseException('$path must be an object.');
  }

  List<Object?> _requiredList(
    Map<String, Object?> source,
    String key,
    String path,
  ) {
    final value = source[key];
    if (value is List) return value.cast<Object?>();
    throw BackupImportParseException('$path.$key must be a list.');
  }

  List<Object?> _optionalList(
    Map<String, Object?> source,
    String key,
    String path,
  ) {
    final value = source[key];
    if (value == null) return const [];
    if (value is List) return value.cast<Object?>();
    throw BackupImportParseException('$path.$key must be a list.');
  }

  int _requiredInt(Map<String, Object?> source, String key, String path) {
    final value = source[key];
    if (value is int) return value;
    throw BackupImportParseException('$path.$key must be an integer.');
  }

  int _requiredMoodScore(Map<String, Object?> source, String key, String path) {
    return _validateMoodScore(_requiredInt(source, key, path), '$path.$key');
  }

  String _requiredNonEmptyString(
    Map<String, Object?> source,
    String key,
    String path,
  ) {
    final value = source[key];
    if (value is String) return _nonEmptyText(value, '$path.$key');
    throw BackupImportParseException('$path.$key must be text.');
  }

  String _requiredMaxLengthText(
    Map<String, Object?> source,
    String key,
    String path,
    int maxLength,
  ) {
    final text = _requiredNonEmptyString(source, key, path);
    if (text.length > maxLength) {
      throw BackupImportParseException(
        '$path.$key must be $maxLength characters or fewer.',
      );
    }
    return text;
  }

  String _requiredDateKey(
    Map<String, Object?> source,
    String key,
    String path,
  ) {
    final value = _requiredNonEmptyString(source, key, path);
    final match = RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value);
    final parsed = DateTime.tryParse(value);
    if (!match ||
        parsed == null ||
        parsed.toIso8601String().substring(0, 10) != value) {
      throw BackupImportParseException(
        '$path.$key must use yyyy-MM-dd format.',
      );
    }
    return value;
  }

  String _requiredMediaRelativePath(
    Map<String, Object?> source,
    String key,
    String path,
  ) {
    final relativePath = _optionalRelativePath(source, key, path);
    if (relativePath == null) {
      throw BackupImportParseException('$path.$key must not be empty.');
    }
    final segments = relativePath.split('/');
    if (segments.length < 2 ||
        (segments.first != 'mood_photos' && segments.first != 'mood_voices')) {
      throw BackupImportParseException('$path.$key must be a mood media path.');
    }
    return relativePath;
  }

  String? _optionalString(
    Map<String, Object?> source,
    String key,
    String path,
  ) {
    final value = source[key];
    if (value == null) return null;
    if (value is String) return value;
    throw BackupImportParseException('$path.$key must be text.');
  }

  String? _optionalRelativePath(
    Map<String, Object?> source,
    String key,
    String path,
  ) {
    return _relativePathText(_optionalString(source, key, path), '$path.$key');
  }

  List<String> _optionalStringList(
    Map<String, Object?> source,
    String key,
    String path,
  ) {
    final value = source[key];
    if (value == null) return const [];
    if (value is! List) {
      throw BackupImportParseException('$path.$key must be a list.');
    }
    return value
        .cast<Object?>()
        .asMap()
        .entries
        .map((entry) {
          final item = entry.value;
          if (item is String) {
            return item;
          }
          throw BackupImportParseException(
            '$path.$key[${entry.key}] must be text.',
          );
        })
        .toList(growable: false);
  }

  bool? _optionalBool(Map<String, Object?> source, String key, String path) {
    final value = source[key];
    if (value == null) return null;
    if (value is bool) return value;
    throw BackupImportParseException('$path.$key must be true or false.');
  }

  DateTime _requiredDateTime(
    Map<String, Object?> source,
    String key,
    String path,
  ) {
    final value = _optionalDateTime(source, key, path);
    if (value != null) return value;
    throw BackupImportParseException('$path.$key must be a timestamp.');
  }

  DateTime? _optionalDateTime(
    Map<String, Object?> source,
    String key,
    String path,
  ) {
    final value = source[key];
    if (value == null) return null;
    if (value is! String) {
      throw BackupImportParseException('$path.$key must be a timestamp.');
    }
    return _parseDateTimeText(value, '$path.$key');
  }

  String _nonEmptyText(String value, String path) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw BackupImportParseException('$path must not be empty.');
    }
    return trimmed;
  }

  String? _nullableText(String? value) {
    if (value == null || value.isEmpty) return null;
    return value;
  }

  String? _relativePathText(String? value, String path) {
    final text = _nullableText(value);
    if (text == null) return null;
    final normalized = text.replaceAll('\\', '/');
    if (normalized.startsWith('/') ||
        normalized.startsWith('../') ||
        normalized.contains('/../') ||
        RegExp(r'^[A-Za-z]:').hasMatch(normalized)) {
      throw BackupImportParseException('$path must be a relative path.');
    }
    return normalized;
  }

  List<int> _parseBase64Bytes(String value, String path) {
    try {
      return base64Decode(value);
    } on FormatException catch (_) {
      throw BackupImportParseException('$path must be valid base64.');
    }
  }

  int _parseMoodScoreText(String value, String path) {
    final parsed = int.tryParse(value);
    if (parsed == null) {
      throw BackupImportParseException('$path must be an integer.');
    }
    return _validateMoodScore(parsed, path);
  }

  int _validateMoodScore(int value, String path) {
    if (value < 1 || value > 5) {
      throw BackupImportParseException('$path must be between 1 and 5.');
    }
    return value;
  }

  DateTime _parseDateTimeText(String value, String path) {
    final parsed = DateTime.tryParse(value);
    if (parsed == null) {
      throw BackupImportParseException('$path must be a valid timestamp.');
    }
    return parsed.toUtc();
  }

  bool _parseBoolText(String value, String path) {
    return switch (value.trim().toLowerCase()) {
      'true' => true,
      'false' => false,
      '1' => true,
      '0' => false,
      _ => throw BackupImportParseException(
        '$path must be true, false, 1, or 0.',
      ),
    };
  }

  List<String> _splitNameList(String value) {
    if (value.trim().isEmpty) return const [];
    return value
        .split(';')
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList(growable: false);
  }

  void _rejectDuplicateEntryUuids(List<ParsedBackupMoodEntry> entries) {
    final seen = <String>{};
    for (final entry in entries) {
      if (!seen.add(entry.uuid)) {
        throw BackupImportParseException(
          'Backup contains duplicate mood entry uuid: ${entry.uuid}.',
        );
      }
    }
  }

  void _rejectDuplicateDailyReflections(
    List<ParsedBackupDailyReflection> reflections,
  ) {
    final seenUuids = <String>{};
    final seenDateKeys = <String>{};
    for (final reflection in reflections) {
      if (!seenUuids.add(reflection.uuid)) {
        throw BackupImportParseException(
          'Backup contains duplicate daily reflection uuid: '
          '${reflection.uuid}.',
        );
      }
      if (!seenDateKeys.add(reflection.dateKey)) {
        throw BackupImportParseException(
          'Backup contains duplicate daily reflection date: '
          '${reflection.dateKey}.',
        );
      }
    }
  }

  List<List<String>> _parseCsvRows(String content) {
    final rows = <List<String>>[];
    var currentRow = <String>[];
    final currentCell = StringBuffer();
    var inQuotes = false;

    for (var index = 0; index < content.length; index++) {
      final char = content[index];
      if (inQuotes) {
        if (char == '"') {
          final nextIndex = index + 1;
          if (nextIndex < content.length && content[nextIndex] == '"') {
            currentCell.write('"');
            index++;
          } else {
            inQuotes = false;
          }
        } else {
          currentCell.write(char);
        }
        continue;
      }

      switch (char) {
        case '"':
          if (currentCell.length > 0) {
            throw const BackupImportParseException(
              'CSV contains an unexpected quote.',
            );
          }
          inQuotes = true;
          break;
        case ',':
          currentRow.add(currentCell.toString());
          currentCell.clear();
          break;
        case '\n':
          currentRow.add(currentCell.toString());
          rows.add(currentRow);
          currentRow = <String>[];
          currentCell.clear();
          break;
        case '\r':
          break;
        default:
          currentCell.write(char);
      }
    }

    if (inQuotes) {
      throw const BackupImportParseException(
        'CSV contains an unterminated quoted field.',
      );
    }
    currentRow.add(currentCell.toString());
    if (currentRow.length > 1 || currentRow.single.isNotEmpty) {
      rows.add(currentRow);
    }
    return rows;
  }

  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var index = 0; index < a.length; index++) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }
}
