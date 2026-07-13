import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

import '../../../core/database/app_database.dart';
import 'backup_import_apply_service.dart';
import 'backup_import_parser.dart';
import 'backup_import_restore_service.dart';
import 'backup_snapshot_service.dart';

final class BackupImportFileResult {
  const BackupImportFileResult({required this.fileName, required this.restore});

  final String fileName;
  final BackupImportRestoreResult restore;
}

abstract interface class BackupImportFileService {
  Future<BackupImportFileResult?> importFromFile();
}

abstract interface class BackupFilePicker {
  Future<FilePickerResult?> pickBackupFile();
}

final class PlatformBackupFilePicker implements BackupFilePicker {
  const PlatformBackupFilePicker();

  @override
  Future<FilePickerResult?> pickBackupFile() {
    return FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['json', 'csv'],
      withData: false,
    );
  }
}

final class LocalBackupImportFileService implements BackupImportFileService {
  LocalBackupImportFileService({
    required AppDatabase database,
    BackupImportParser parser = const BackupImportParser(),
    BackupFilePicker? filePicker,
    BackupImportRestoreService? restoreService,
  }) : _database = database,
       _parser = parser,
       _filePicker = filePicker ?? const PlatformBackupFilePicker(),
       _restoreService = restoreService;

  final AppDatabase _database;
  final BackupImportParser _parser;
  final BackupFilePicker _filePicker;
  final BackupImportRestoreService? _restoreService;

  @override
  Future<BackupImportFileResult?> importFromFile() async {
    final picked = await _filePicker.pickBackupFile();
    final files = picked?.files;
    final file = files == null || files.isEmpty ? null : files.single;
    final path = file?.path;
    if (file == null || path == null) return null;

    final format = _formatForPath(path);
    final content = await File(path).readAsString();
    final backup = _parser.parse(content, format);
    final restore = await (_restoreService ?? _defaultRestoreService()).restore(
      backup,
    );

    return BackupImportFileResult(fileName: file.name, restore: restore);
  }

  BackupImportRestoreService _defaultRestoreService() {
    return BackupImportRestoreService(
      snapshotService: LocalBackupSnapshotService(database: _database),
      applyService: BackupImportApplyService(database: _database),
    );
  }

  BackupImportFormat _formatForPath(String path) {
    return switch (p.extension(path).toLowerCase()) {
      '.json' => BackupImportFormat.json,
      '.csv' => BackupImportFormat.csv,
      _ => throw const BackupImportParseException(
        'Backup file must be a JSON or CSV file.',
      ),
    };
  }
}
