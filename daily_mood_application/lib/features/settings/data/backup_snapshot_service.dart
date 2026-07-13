import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/database/app_database.dart';
import 'backup_export_service.dart';

final class BackupSnapshot {
  const BackupSnapshot({required this.filePath});

  final String filePath;
}

abstract interface class BackupSnapshotService {
  Future<BackupSnapshot> createPreImportSnapshot();
}

final class LocalBackupSnapshotService implements BackupSnapshotService {
  LocalBackupSnapshotService({
    required AppDatabase database,
    Directory? snapshotsDirectory,
    DateTime Function()? clock,
    int maxSnapshots = 3,
  }) : _database = database,
       _snapshotsDirectory = snapshotsDirectory,
       _clock = clock ?? DateTime.now,
       _maxSnapshots = maxSnapshots;

  final AppDatabase _database;
  final Directory? _snapshotsDirectory;
  final DateTime Function() _clock;
  final int _maxSnapshots;

  @override
  Future<BackupSnapshot> createPreImportSnapshot() async {
    final directory = await _resolveSnapshotsDirectory();
    await directory.create(recursive: true);

    final now = _clock().toUtc();
    final exportService = DriftBackupExportService(
      database: _database,
      clock: () => now,
    );
    final export = await exportService.buildExport(BackupExportFormat.json);
    final file = File(
      p.join(directory.path, 'pre_import_${_timestamp(now)}.json'),
    );
    await file.writeAsString(export.content, flush: true);
    await _pruneOldSnapshots(directory);

    return BackupSnapshot(filePath: file.path);
  }

  Future<Directory> _resolveSnapshotsDirectory() async {
    final provided = _snapshotsDirectory;
    if (provided != null) return provided;

    final supportDirectory = await getApplicationSupportDirectory();
    return Directory(p.join(supportDirectory.path, 'backup_snapshots'));
  }

  Future<void> _pruneOldSnapshots(Directory directory) async {
    final snapshots = await directory
        .list()
        .where((entity) => entity is File && p.extension(entity.path) == '.json')
        .cast<File>()
        .toList();
    snapshots.sort((a, b) {
      return p.basename(b.path).compareTo(p.basename(a.path));
    });

    for (final snapshot in snapshots.skip(_maxSnapshots)) {
      await snapshot.delete();
    }
  }

  String _timestamp(DateTime dateTime) {
    String two(int value) => value.toString().padLeft(2, '0');

    return '${dateTime.year}${two(dateTime.month)}${two(dateTime.day)}_'
        '${two(dateTime.hour)}${two(dateTime.minute)}${two(dateTime.second)}';
  }
}
