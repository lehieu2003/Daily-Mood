import 'package:daily_mood_application/features/settings/data/backup_export_service.dart';
import 'package:daily_mood_application/features/settings/data/backup_import_apply_service.dart';
import 'package:daily_mood_application/features/settings/data/backup_import_file_service.dart';
import 'package:daily_mood_application/features/settings/data/backup_import_restore_service.dart';
import 'package:daily_mood_application/features/settings/data/backup_snapshot_service.dart';
import 'package:daily_mood_application/features/settings/data/local_data_reset_service.dart';
import 'package:daily_mood_application/features/settings/data/settings_preferences_repository.dart';
import 'package:daily_mood_application/features/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders settings entry points for lock data and haptics', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        SettingsScreen(
          preferencesRepository: SettingsPreferencesRepository(
            store: InMemorySettingsPreferencesStore(),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Privacy lock'), findsOneWidget);
    expect(find.text('Lock now'), findsOneWidget);
    expect(find.text('PIN & biometrics'), findsOneWidget);
    expect(find.text('Data control'), findsOneWidget);
    expect(find.text('Export data'), findsOneWidget);
    expect(find.text('Import data'), findsOneWidget);
    expect(find.text('Delete all local data'), findsOneWidget);
    expect(find.text('Experience'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Tiếng Việt'), findsOneWidget);
    expect(find.text('Haptic feedback'), findsOneWidget);
    expect(find.textContaining('TODO'), findsNothing);
  });

  testWidgets('persists selected language', (tester) async {
    final store = InMemorySettingsPreferencesStore();
    final repository = SettingsPreferencesRepository(store: store);

    await tester.pumpWidget(
      _app(SettingsScreen(preferencesRepository: repository)),
    );
    await tester.pump();

    expect(await repository.readLanguageCode(), isNull);

    await tester.ensureVisible(
      find.byKey(const ValueKey('settings_language_segmented_button')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tiếng Việt'));
    await tester.pump();

    expect(await repository.readLanguageCode(), 'vi');
  });

  testWidgets('persists haptics toggle state', (tester) async {
    final store = InMemorySettingsPreferencesStore();
    final repository = SettingsPreferencesRepository(store: store);

    await tester.pumpWidget(
      _app(SettingsScreen(preferencesRepository: repository)),
    );
    await tester.pump();

    Switch adaptiveSwitch() {
      return tester.widget<Switch>(
        find.byKey(const ValueKey('settings_haptics_switch')),
      );
    }

    expect(adaptiveSwitch().value, isTrue);

    await tester.ensureVisible(
      find.byKey(const ValueKey('settings_haptics_switch')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('settings_haptics_switch')));
    await tester.pump();

    expect(adaptiveSwitch().value, isFalse);
    expect(await repository.readHapticsEnabled(), isFalse);
  });

  testWidgets('lock now tile calls lock action', (tester) async {
    var locked = false;

    await tester.pumpWidget(
      _app(
        SettingsScreen(
          preferencesRepository: SettingsPreferencesRepository(
            store: InMemorySettingsPreferencesStore(),
          ),
          onLockNow: () => locked = true,
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('settings_lock_now_tile')));
    await tester.pump();

    expect(locked, isTrue);
  });

  testWidgets('export data flow asks for format and shares JSON export', (
    tester,
  ) async {
    final exportService = _FakeBackupExportService();

    await tester.pumpWidget(
      _app(
        SettingsScreen(
          preferencesRepository: SettingsPreferencesRepository(
            store: InMemorySettingsPreferencesStore(),
          ),
          backupExportService: exportService,
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('settings_export_tile')));
    await tester.pumpAndSettle();

    expect(find.text('Export data'), findsWidgets);
    expect(find.text('JSON'), findsOneWidget);
    expect(find.text('CSV'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('export_json_button')));
    await tester.pumpAndSettle();

    expect(exportService.sharedFormats, [BackupExportFormat.json]);
    expect(
      find.text('Export file ready: daily_mood_export_test.json'),
      findsOneWidget,
    );
  });

  testWidgets('import data flow restores selected backup and shows summary', (
    tester,
  ) async {
    final importService = _FakeBackupImportFileService();

    await tester.pumpWidget(
      _app(
        SettingsScreen(
          preferencesRepository: SettingsPreferencesRepository(
            store: InMemorySettingsPreferencesStore(),
          ),
          backupImportService: importService,
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('settings_import_tile')));
    await tester.pumpAndSettle();

    expect(importService.importCount, 1);
    expect(
      find.text(
        'Imported daily_mood_export_test.json: 2 added, 1 updated, 3 skipped.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('delete data flow requires confirmation before reset', (
    tester,
  ) async {
    final resetService = _FakeLocalDataResetService();
    var deleted = false;

    await tester.pumpWidget(
      _app(
        SettingsScreen(
          preferencesRepository: SettingsPreferencesRepository(
            store: InMemorySettingsPreferencesStore(),
          ),
          dataResetService: resetService,
          onDataDeleted: () => deleted = true,
        ),
      ),
    );
    await tester.pump();

    await tester.ensureVisible(
      find.byKey(const ValueKey('settings_delete_data_tile')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('settings_delete_data_tile')));
    await tester.pumpAndSettle();

    expect(find.text('Delete all local data'), findsWidgets);
    expect(find.text('Type DELETE to confirm.'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(
            find.byKey(const ValueKey('delete_all_data_confirm_button')),
          )
          .onPressed,
      isNull,
    );

    await tester.enterText(
      find.byKey(const ValueKey('delete_all_data_confirmation_field')),
      'DELETE',
    );
    await tester.pump();
    await tester.tap(
      find.byKey(const ValueKey('delete_all_data_confirm_button')),
    );
    await tester.pumpAndSettle();

    expect(resetService.deleteCount, 1);
    expect(deleted, isTrue);
    expect(find.text('Local data deleted.'), findsOneWidget);
  });
}

Widget _app(Widget child) {
  return MaterialApp(home: child);
}

class _FakeLocalDataResetService implements LocalDataResetService {
  int deleteCount = 0;

  @override
  Future<void> deleteAllData() async {
    deleteCount++;
  }
}

class _FakeBackupExportService implements BackupExportService {
  final sharedFormats = <BackupExportFormat>[];

  @override
  Future<BackupExportFile> buildExport(BackupExportFormat format) async {
    return BackupExportFile(
      format: format,
      fileName: 'daily_mood_export_test.${format.extension}',
      content: '',
    );
  }

  @override
  Future<BackupExportFile> exportAndShare(BackupExportFormat format) async {
    sharedFormats.add(format);
    return buildExport(format);
  }
}

class _FakeBackupImportFileService implements BackupImportFileService {
  int importCount = 0;

  @override
  Future<BackupImportFileResult?> importFromFile() async {
    importCount++;
    return const BackupImportFileResult(
      fileName: 'daily_mood_export_test.json',
      restore: BackupImportRestoreResult(
        snapshot: BackupSnapshot(filePath: 'snapshot.json'),
        applyResult: BackupImportApplyResult(
          insertedActivities: 0,
          skippedActivities: 0,
          insertedEntries: 2,
          updatedEntries: 1,
          skippedEntries: 3,
          skippedEntryUuids: ['entry-1', 'entry-2', 'entry-3'],
        ),
      ),
    );
  }
}
