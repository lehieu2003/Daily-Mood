import 'package:daily_mood_application/features/settings/data/backup_import_apply_service.dart';
import 'package:daily_mood_application/features/settings/data/backup_import_parser.dart';
import 'package:daily_mood_application/features/settings/data/backup_import_restore_service.dart';
import 'package:daily_mood_application/features/settings/data/backup_snapshot_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('creates rollback snapshot before applying imported records', () async {
    final events = <String>[];
    final snapshotService = _FakeSnapshotService(events: events);
    final applyService = _FakeApplyService(events: events);
    final restoreService = BackupImportRestoreService(
      snapshotService: snapshotService,
      applyService: applyService,
    );

    final result = await restoreService.restore(_backup());

    expect(events, ['snapshot', 'apply']);
    expect(result.snapshot.filePath, 'snapshot.json');
    expect(result.applyResult.insertedEntries, 1);
  });

  test('does not apply import when rollback snapshot fails', () async {
    final events = <String>[];
    final snapshotService = _FakeSnapshotService(
      events: events,
      shouldThrow: true,
    );
    final applyService = _FakeApplyService(events: events);
    final restoreService = BackupImportRestoreService(
      snapshotService: snapshotService,
      applyService: applyService,
    );

    await expectLater(
      restoreService.restore(_backup()),
      throwsA(isA<StateError>()),
    );

    expect(events, ['snapshot']);
    expect(applyService.applyCount, 0);
  });
}

ParsedBackup _backup() {
  return ParsedBackup(
    exportVersion: 1,
    schemaVersion: 2,
    exportedAt: DateTime.utc(2026, 7, 13),
    mediaPackaging: 'relative_paths_only',
    mediaFiles: const [],
    activities: const [],
    subEmotions: const [],
    entries: const [],
  );
}

final class _FakeSnapshotService implements BackupSnapshotService {
  _FakeSnapshotService({required this.events, this.shouldThrow = false});

  final List<String> events;
  final bool shouldThrow;

  @override
  Future<BackupSnapshot> createPreImportSnapshot() async {
    events.add('snapshot');
    if (shouldThrow) {
      throw StateError('snapshot failed');
    }
    return const BackupSnapshot(filePath: 'snapshot.json');
  }
}

final class _FakeApplyService implements BackupImportApplier {
  _FakeApplyService({required this.events});

  final List<String> events;
  int applyCount = 0;

  @override
  Future<BackupImportApplyResult> apply(ParsedBackup backup) async {
    events.add('apply');
    applyCount++;
    return const BackupImportApplyResult(
      insertedActivities: 0,
      skippedActivities: 0,
      insertedEntries: 1,
      updatedEntries: 0,
      skippedEntries: 0,
      skippedEntryUuids: [],
    );
  }
}
