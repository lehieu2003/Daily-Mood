import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/localization/app_localizations.dart';
import '../../core/database/app_database.dart';
import '../../core/security/app_lock_cubit.dart';
import '../../data/repositories/activity_repository.dart';
import 'data/backup_export_service.dart';
import 'data/backup_import_file_service.dart';
import 'data/backup_import_parser.dart';
import 'data/local_data_reset_service.dart';
import 'data/local_reminder_scheduler.dart';
import 'data/settings_preferences_repository.dart';
import 'state/delete_all_data_cubit.dart';
import 'state/settings_preferences_cubit.dart';
import 'widgets/custom_tags_sheet.dart';
import 'widgets/delete_all_data_dialog.dart';
import 'widgets/settings_divider.dart';
import 'widgets/settings_experience_section.dart';
import 'widgets/settings_section.dart';
import 'widgets/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    SettingsPreferencesRepository? preferencesRepository,
    this.onLockNow,
    this.onExportData,
    this.onImportData,
    this.onDeleteData,
    this.dataResetService,
    this.backupExportService,
    this.backupImportService,
    this.onDataDeleted,
    this.reminderScheduler,
    this.reminderTimePicker,
  }) : _preferencesRepository = preferencesRepository;

  final SettingsPreferencesRepository? _preferencesRepository;
  final VoidCallback? onLockNow;
  final VoidCallback? onExportData;
  final VoidCallback? onImportData;
  final VoidCallback? onDeleteData;
  final LocalDataResetService? dataResetService;
  final BackupExportService? backupExportService;
  final BackupImportFileService? backupImportService;
  final VoidCallback? onDataDeleted;
  final LocalReminderScheduler? reminderScheduler;
  final DailyReminderTimePicker? reminderTimePicker;

  @override
  Widget build(BuildContext context) {
    final repository =
        _preferencesRepository ??
        _repositoryFromContext(context) ??
        SettingsPreferencesRepository();
    final scheduler =
        reminderScheduler ??
        _reminderSchedulerFromContext(context) ??
        const NoopLocalReminderScheduler();

    return BlocProvider(
      create: (_) => SettingsPreferencesCubit(
        repository: repository,
        reminderScheduler: scheduler,
      ),
      child: _SettingsView(
        onLockNow: onLockNow,
        onExportData: onExportData,
        onImportData: onImportData,
        onDeleteData: onDeleteData,
        dataResetService: dataResetService,
        backupExportService: backupExportService,
        backupImportService: backupImportService,
        onDataDeleted: onDataDeleted,
        reminderTimePicker: reminderTimePicker,
      ),
    );
  }

  SettingsPreferencesRepository? _repositoryFromContext(BuildContext context) {
    try {
      return context.read<SettingsPreferencesRepository>();
    } catch (_) {
      return null;
    }
  }

  LocalReminderScheduler? _reminderSchedulerFromContext(BuildContext context) {
    try {
      return context.read<LocalReminderScheduler>();
    } catch (_) {
      return null;
    }
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView({
    this.onLockNow,
    this.onExportData,
    this.onImportData,
    this.onDeleteData,
    this.dataResetService,
    this.backupExportService,
    this.backupImportService,
    this.onDataDeleted,
    this.reminderTimePicker,
  });

  final VoidCallback? onLockNow;
  final VoidCallback? onExportData;
  final VoidCallback? onImportData;
  final VoidCallback? onDeleteData;
  final LocalDataResetService? dataResetService;
  final BackupExportService? backupExportService;
  final BackupImportFileService? backupImportService;
  final VoidCallback? onDataDeleted;
  final DailyReminderTimePicker? reminderTimePicker;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 112),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.settings, style: theme.textTheme.headlineLarge),
              const SizedBox(height: 6),
              Text(
                l10n.settingsSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              SettingsSection(
                title: l10n.privacyLock,
                children: [
                  SettingsTile(
                    key: const ValueKey('settings_lock_now_tile'),
                    icon: Icons.lock_outline,
                    title: l10n.lockNow,
                    subtitle: l10n.lockNowSubtitle,
                    onTap: () => _lockNow(context),
                  ),
                  const SettingsDivider(),
                  SettingsTile(
                    key: const ValueKey('settings_pin_biometrics_tile'),
                    icon: Icons.fingerprint,
                    title: l10n.pinAndBiometrics,
                    subtitle: l10n.pinAndBiometricsSubtitle,
                    enabled: false,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SettingsSection(
                title: l10n.dataControl,
                children: [
                  SettingsTile(
                    key: const ValueKey('settings_export_tile'),
                    icon: Icons.ios_share_outlined,
                    title: l10n.exportData,
                    subtitle: l10n.exportDataSubtitle,
                    onTap:
                        onExportData ?? () => _showExportFormatDialog(context),
                  ),
                  const SettingsDivider(),
                  SettingsTile(
                    key: const ValueKey('settings_import_tile'),
                    icon: Icons.file_upload_outlined,
                    title: l10n.importData,
                    subtitle: l10n.importDataSubtitle,
                    onTap: onImportData ?? () => _importData(context),
                  ),
                  const SettingsDivider(),
                  SettingsTile(
                    key: const ValueKey('settings_manage_custom_tags_tile'),
                    icon: Icons.label_outline,
                    title: l10n.manageCustomTags,
                    subtitle: l10n.manageCustomTagsSubtitle,
                    onTap: () => _showCustomTagsSheet(context),
                  ),
                  const SettingsDivider(),
                  SettingsTile(
                    key: const ValueKey('settings_delete_data_tile'),
                    icon: Icons.delete_outline,
                    title: l10n.deleteAllLocalData,
                    subtitle: l10n.deleteAllLocalDataSubtitle,
                    isDestructive: true,
                    onTap:
                        onDeleteData ?? () => _showDeleteAllDataDialog(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SettingsExperienceSection(
                reminderTimePicker: reminderTimePicker,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _lockNow(BuildContext context) {
    final callback = onLockNow;
    if (callback != null) {
      callback();
      return;
    }
    context.read<AppLockCubit>().lockManually();
  }

  Future<void> _showExportFormatDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final l10n = context.l10n;
        return AlertDialog(
          title: Text(l10n.exportData),
          content: Text(l10n.exportDataBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.cancel),
            ),
            TextButton(
              key: const ValueKey('export_csv_button'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _exportData(context, BackupExportFormat.csv);
              },
              child: const Text('CSV'),
            ),
            FilledButton(
              key: const ValueKey('export_json_button'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _exportData(context, BackupExportFormat.json);
              },
              child: const Text('JSON'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _exportData(
    BuildContext context,
    BackupExportFormat format,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final service =
        backupExportService ??
        DriftBackupExportService(database: context.read<AppDatabase>());

    try {
      final file = await service.exportAndShare(format);
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.exportReady(file.fileName))),
      );
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.exportFailed)));
    }
  }

  Future<void> _importData(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final service =
        backupImportService ??
        LocalBackupImportFileService(database: context.read<AppDatabase>());

    try {
      final result = await service.importFromFile();
      if (result == null) return;

      messenger.showSnackBar(
        SnackBar(content: Text(_importSummary(l10n, result))),
      );
    } on BackupImportParseException catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.importFailedWithMessage(error.message))),
      );
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.importFailed)));
    }
  }

  Future<void> _showCustomTagsSheet(BuildContext context) {
    final repository = context.read<ActivityRepository>();
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return CustomTagsSheet(repository: repository);
      },
    );
  }

  String _importSummary(AppLocalizations l10n, BackupImportFileResult result) {
    final apply = result.restore.applyResult;
    return l10n.importSummary(
      fileName: result.fileName,
      added: apply.insertedEntries,
      updated: apply.updatedEntries,
      skipped: apply.skippedEntries,
    );
  }

  Future<void> _showDeleteAllDataDialog(BuildContext context) {
    final settingsContext = context;
    final resetService =
        dataResetService ??
        DriftLocalDataResetService(
          database: settingsContext.read<AppDatabase>(),
        );

    return showDialog<void>(
      context: settingsContext,
      builder: (dialogContext) {
        return BlocProvider(
          create: (_) => DeleteAllDataCubit(resetService: resetService),
          child: DeleteAllDataDialog(
            onDeleted: () {
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(settingsContext).showSnackBar(
                SnackBar(content: Text(settingsContext.l10n.localDataDeleted)),
              );
              final deletedCallback = onDataDeleted;
              if (deletedCallback != null) {
                deletedCallback();
              } else {
                settingsContext.read<AppLockCubit>().lockManually();
              }
            },
          ),
        );
      },
    );
  }
}
