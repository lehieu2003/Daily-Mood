import 'package:daily_mood_application/core/database/app_database.dart';
import 'package:daily_mood_application/core/database/daos/activity_dao.dart';
import 'package:daily_mood_application/data/repositories/activity_repository.dart';
import 'package:daily_mood_application/data/services/activity_local_service.dart';
import 'package:daily_mood_application/features/settings/data/backup_export_service.dart';
import 'package:daily_mood_application/features/settings/data/backup_import_apply_service.dart';
import 'package:daily_mood_application/features/settings/data/backup_import_file_service.dart';
import 'package:daily_mood_application/features/settings/data/backup_import_restore_service.dart';
import 'package:daily_mood_application/features/settings/data/backup_snapshot_service.dart';
import 'package:daily_mood_application/features/settings/data/local_data_reset_service.dart';
import 'package:daily_mood_application/features/settings/data/local_reminder_scheduler.dart';
import 'package:daily_mood_application/features/settings/data/settings_preferences_repository.dart';
import 'package:daily_mood_application/features/settings/settings_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    expect(find.text('Manage custom tags'), findsOneWidget);
    expect(find.text('Delete all local data'), findsOneWidget);
    expect(find.text('Experience'), findsOneWidget);
    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('System'), findsOneWidget);
    expect(find.text('Light'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Tiếng Việt'), findsOneWidget);
    expect(find.text('Daily reminder'), findsOneWidget);
    expect(find.text('Haptic feedback'), findsOneWidget);
    expect(find.textContaining('TODO'), findsNothing);
  });

  testWidgets('persists selected appearance mode', (tester) async {
    final store = InMemorySettingsPreferencesStore();
    final repository = SettingsPreferencesRepository(store: store);

    await tester.pumpWidget(
      _app(SettingsScreen(preferencesRepository: repository)),
    );
    await tester.pump();

    expect(await repository.readThemeModeName(), 'system');

    await tester.ensureVisible(
      find.byKey(const ValueKey('settings_appearance_segmented_button')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark'));
    await tester.pump();

    expect(await repository.readThemeModeName(), 'dark');
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

  testWidgets('persists daily reminder opt-in and schedules locally', (
    tester,
  ) async {
    final store = InMemorySettingsPreferencesStore();
    final repository = SettingsPreferencesRepository(store: store);
    final scheduler = _FakeLocalReminderScheduler();

    await tester.pumpWidget(
      _app(
        SettingsScreen(
          preferencesRepository: repository,
          reminderScheduler: scheduler,
          reminderTimePicker: (_, _) async {
            return const DailyReminderTime(hour: 7, minute: 30);
          },
        ),
      ),
    );
    await tester.pump();

    Switch reminderSwitch() {
      return tester.widget<Switch>(
        find.byKey(const ValueKey('settings_daily_reminder_switch')),
      );
    }

    await tester.ensureVisible(
      find.byKey(const ValueKey('settings_daily_reminder_switch')),
    );
    await tester.pumpAndSettle();

    expect(reminderSwitch().value, isFalse);
    expect(await repository.readDailyReminderEnabled(), isFalse);

    await tester.tap(
      find.byKey(const ValueKey('settings_daily_reminder_switch')),
    );
    await tester.pump();

    expect(reminderSwitch().value, isTrue);
    expect(await repository.readDailyReminderEnabled(), isTrue);
    expect(
      await repository.readDailyReminderTime(),
      const DailyReminderTime(hour: 7, minute: 30),
    );
    expect(scheduler.scheduledTimes, const [
      DailyReminderTime(hour: 7, minute: 30),
    ]);

    await tester.tap(
      find.byKey(const ValueKey('settings_daily_reminder_switch')),
    );
    await tester.pump();

    expect(reminderSwitch().value, isFalse);
    expect(await repository.readDailyReminderEnabled(), isFalse);
    expect(scheduler.cancelCount, 1);
  });

  testWidgets(
    'keeps daily reminder off when notification permission is denied',
    (tester) async {
      final store = InMemorySettingsPreferencesStore();
      final repository = SettingsPreferencesRepository(store: store);
      final scheduler = _FakeLocalReminderScheduler(scheduleResult: false);

      await tester.pumpWidget(
        _app(
          SettingsScreen(
            preferencesRepository: repository,
            reminderScheduler: scheduler,
            reminderTimePicker: (_, _) async {
              return const DailyReminderTime(hour: 7, minute: 30);
            },
          ),
        ),
      );
      await tester.pump();

      await tester.ensureVisible(
        find.byKey(const ValueKey('settings_daily_reminder_switch')),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const ValueKey('settings_daily_reminder_switch')),
      );
      await tester.pump();

      final reminderSwitch = tester.widget<Switch>(
        find.byKey(const ValueKey('settings_daily_reminder_switch')),
      );
      expect(reminderSwitch.value, isFalse);
      expect(await repository.readDailyReminderEnabled(), isFalse);
      expect(scheduler.scheduledTimes, const [
        DailyReminderTime(hour: 7, minute: 30),
      ]);
    },
  );

  testWidgets('leaves daily reminder off when time selection is canceled', (
    tester,
  ) async {
    final store = InMemorySettingsPreferencesStore();
    final repository = SettingsPreferencesRepository(store: store);
    final scheduler = _FakeLocalReminderScheduler();

    await tester.pumpWidget(
      _app(
        SettingsScreen(
          preferencesRepository: repository,
          reminderScheduler: scheduler,
          reminderTimePicker: (_, _) async => null,
        ),
      ),
    );
    await tester.pump();

    await tester.ensureVisible(
      find.byKey(const ValueKey('settings_daily_reminder_switch')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('settings_daily_reminder_switch')),
    );
    await tester.pump();

    final reminderSwitch = tester.widget<Switch>(
      find.byKey(const ValueKey('settings_daily_reminder_switch')),
    );
    expect(reminderSwitch.value, isFalse);
    expect(await repository.readDailyReminderEnabled(), isFalse);
    expect(scheduler.scheduledTimes, isEmpty);
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

  testWidgets('manage custom tags sheet archives and restores tags', (
    tester,
  ) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final activityDao = ActivityDao(db);
    final repository = ActivityRepository(
      localService: ActivityLocalService(activityDao: activityDao),
    );

    try {
      final readingId = await activityDao.createCustomActivity(
        name: 'Reading',
        category: 'Other',
      );
      final sketchingId = await activityDao.createCustomActivity(
        name: 'Sketching',
        category: 'Other',
      );
      await activityDao.archiveActivity(sketchingId);

      await tester.pumpWidget(
        RepositoryProvider<ActivityRepository>.value(
          value: repository,
          child: _app(
            SettingsScreen(
              preferencesRepository: SettingsPreferencesRepository(
                store: InMemorySettingsPreferencesStore(),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(
        find.byKey(const ValueKey('settings_manage_custom_tags_tile')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Manage custom tags'), findsWidgets);
      expect(find.text('Reading'), findsOneWidget);
      expect(find.text('Sketching'), findsOneWidget);
      expect(find.text('Other • Active'), findsOneWidget);
      expect(find.text('Other • Archived'), findsOneWidget);

      await tester.tap(find.byKey(ValueKey('archive_custom_tag_$readingId')));
      await tester.pumpAndSettle();

      var reading = await (db.select(
        db.activities,
      )..where((row) => row.id.equals(readingId))).getSingle();
      expect(reading.isArchived, isTrue);
      expect(find.text('Archived Reading.'), findsOneWidget);
      expect(
        find.byKey(ValueKey('restore_custom_tag_$readingId')),
        findsOneWidget,
      );

      await tester.tap(find.byKey(ValueKey('restore_custom_tag_$sketchingId')));
      await tester.pumpAndSettle();

      final sketching = await (db.select(
        db.activities,
      )..where((row) => row.id.equals(sketchingId))).getSingle();
      expect(sketching.isArchived, isFalse);
      expect(find.text('Restored Sketching.'), findsOneWidget);
      reading = await (db.select(
        db.activities,
      )..where((row) => row.id.equals(readingId))).getSingle();
      expect(reading.isArchived, isTrue);
    } finally {
      await db.close();
    }
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

class _FakeLocalReminderScheduler implements LocalReminderScheduler {
  _FakeLocalReminderScheduler({this.scheduleResult = true});

  final bool scheduleResult;
  final scheduledTimes = <DailyReminderTime>[];
  int cancelCount = 0;

  @override
  Future<void> cancelDaily() async {
    cancelCount++;
  }

  @override
  Future<bool> scheduleDaily(
    DailyReminderTime time, {
    String languageCode = 'en',
  }) async {
    scheduledTimes.add(time);
    return scheduleResult;
  }
}
