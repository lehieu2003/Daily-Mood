import 'backup_import_apply_service.dart';
import 'backup_import_parser.dart';
import 'backup_snapshot_service.dart';

final class BackupImportRestoreResult {
  const BackupImportRestoreResult({
    required this.snapshot,
    required this.applyResult,
  });

  final BackupSnapshot snapshot;
  final BackupImportApplyResult applyResult;
}

final class BackupImportRestoreService {
  const BackupImportRestoreService({
    required BackupSnapshotService snapshotService,
    required BackupImportApplier applyService,
  }) : _snapshotService = snapshotService,
       _applyService = applyService;

  final BackupSnapshotService _snapshotService;
  final BackupImportApplier _applyService;

  Future<BackupImportRestoreResult> restore(ParsedBackup backup) async {
    final snapshot = await _snapshotService.createPreImportSnapshot();
    final applyResult = await _applyService.apply(backup);
    return BackupImportRestoreResult(
      snapshot: snapshot,
      applyResult: applyResult,
    );
  }
}
