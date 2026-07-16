import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/localization/app_locale_cubit.dart';
import '../../app/localization/app_localizations.dart';
import '../../app/theme/app_theme_mode_cubit.dart';
import '../../core/database/app_database.dart';
import '../../core/security/app_lock_cubit.dart';
import 'data/backup_export_service.dart';
import 'data/backup_import_file_service.dart';
import 'data/backup_import_parser.dart';
import 'data/local_data_reset_service.dart';
import 'data/settings_preferences_repository.dart';
import 'state/delete_all_data_cubit.dart';
import 'state/delete_all_data_state.dart';
import 'state/settings_preferences_cubit.dart';
import 'state/settings_preferences_state.dart';
import 'widgets/settings_divider.dart';
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

  @override
  Widget build(BuildContext context) {
    final repository =
        _preferencesRepository ??
        _repositoryFromContext(context) ??
        SettingsPreferencesRepository();

    return BlocProvider(
      create: (_) => SettingsPreferencesCubit(repository: repository),
      child: _SettingsView(
        onLockNow: onLockNow,
        onExportData: onExportData,
        onImportData: onImportData,
        onDeleteData: onDeleteData,
        dataResetService: dataResetService,
        backupExportService: backupExportService,
        backupImportService: backupImportService,
        onDataDeleted: onDataDeleted,
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
  });

  final VoidCallback? onLockNow;
  final VoidCallback? onExportData;
  final VoidCallback? onImportData;
  final VoidCallback? onDeleteData;
  final LocalDataResetService? dataResetService;
  final BackupExportService? backupExportService;
  final BackupImportFileService? backupImportService;
  final VoidCallback? onDataDeleted;

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
              SettingsSection(
                title: l10n.experience,
                children: const [
                  _AppearanceTile(),
                  SettingsDivider(),
                  _LanguageTile(),
                  SettingsDivider(),
                  _HapticsTile(),
                ],
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
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.exportFailed)),
      );
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
        SnackBar(
          content: Text(l10n.importFailedWithMessage(error.message)),
        ),
      );
    } catch (_) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.importFailed)),
      );
    }
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
          child: _DeleteAllDataDialog(
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

class _DeleteAllDataDialog extends StatefulWidget {
  const _DeleteAllDataDialog({required this.onDeleted});

  final VoidCallback onDeleted;

  @override
  State<_DeleteAllDataDialog> createState() => _DeleteAllDataDialogState();
}

class _DeleteAllDataDialogState extends State<_DeleteAllDataDialog> {
  static const _confirmationText = 'DELETE';

  final _controller = TextEditingController();
  bool _canDelete = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onConfirmationChanged(String value) {
    setState(() => _canDelete = value.trim() == _confirmationText);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return BlocConsumer<DeleteAllDataCubit, DeleteAllDataState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.isSuccess) {
          widget.onDeleted();
        }
      },
      builder: (context, state) {
        return AlertDialog(
          title: Text(l10n.deleteAllLocalData),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.deleteAllLocalDataBody),
              const SizedBox(height: 12),
              Text(
                l10n.typeDeleteToConfirm,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                key: const ValueKey('delete_all_data_confirmation_field'),
                controller: _controller,
                enabled: !state.isDeleting,
                textCapitalization: TextCapitalization.characters,
                onChanged: _onConfirmationChanged,
                decoration: const InputDecoration(hintText: 'DELETE'),
              ),
              if (state.errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  state.errorMessage!,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: state.isDeleting
                  ? null
                  : () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              key: const ValueKey('delete_all_data_confirm_button'),
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
              ),
              onPressed: !_canDelete || state.isDeleting
                  ? null
                  : context.read<DeleteAllDataCubit>().deleteAllData,
              child: state.isDeleting
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.delete),
            ),
          ],
        );
      },
    );
  }
}

class _AppearanceTile extends StatelessWidget {
  const _AppearanceTile();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsPreferencesCubit, SettingsPreferencesState>(
      builder: (context, state) {
        return SettingsTile(
          key: const ValueKey('settings_appearance_tile'),
          icon: Icons.contrast_rounded,
          title: context.l10n.appearance,
          subtitle: context.l10n.appearanceSubtitle,
          trailing: SegmentedButton<String>(
            key: const ValueKey('settings_appearance_segmented_button'),
            segments: [
              ButtonSegment(
                value: 'system',
                label: Text(context.l10n.systemMode),
              ),
              ButtonSegment(
                value: 'light',
                label: Text(context.l10n.lightMode),
              ),
              ButtonSegment(value: 'dark', label: Text(context.l10n.darkMode)),
            ],
            selected: {state.themeModeName},
            showSelectedIcon: false,
            onSelectionChanged: state.isLoading
                ? null
                : (selection) => _setThemeMode(context, selection.single),
          ),
        );
      },
    );
  }

  Future<void> _setThemeMode(BuildContext context, String themeModeName) async {
    final settingsCubit = context.read<SettingsPreferencesCubit>();
    AppThemeModeCubit? appThemeModeCubit;
    try {
      appThemeModeCubit = context.read<AppThemeModeCubit>();
    } catch (_) {
      // Feature-level widget tests pump Settings without the app root Cubit.
    }

    await settingsCubit.setThemeModeName(themeModeName);
    await appThemeModeCubit?.setThemeModeName(themeModeName);
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsPreferencesCubit, SettingsPreferencesState>(
      builder: (context, state) {
        return SettingsTile(
          key: const ValueKey('settings_language_tile'),
          icon: Icons.language_rounded,
          title: context.l10n.language,
          subtitle: context.l10n.languageSubtitle,
          trailing: SegmentedButton<String>(
            key: const ValueKey('settings_language_segmented_button'),
            segments: [
              ButtonSegment(value: 'en', label: Text(context.l10n.english)),
              ButtonSegment(value: 'vi', label: Text(context.l10n.vietnamese)),
            ],
            selected: {state.languageCode},
            showSelectedIcon: false,
            onSelectionChanged: state.isLoading
                ? null
                : (selection) => _setLanguage(context, selection.single),
          ),
        );
      },
    );
  }

  Future<void> _setLanguage(BuildContext context, String languageCode) async {
    final settingsCubit = context.read<SettingsPreferencesCubit>();
    AppLocaleCubit? appLocaleCubit;
    try {
      appLocaleCubit = context.read<AppLocaleCubit>();
    } catch (_) {
      // Feature-level widget tests pump Settings without the app root Cubit.
    }

    await settingsCubit.setLanguageCode(languageCode);
    await appLocaleCubit?.setLanguageCode(languageCode);
  }
}

class _HapticsTile extends StatelessWidget {
  const _HapticsTile();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsPreferencesCubit, SettingsPreferencesState>(
      builder: (context, state) {
        return SettingsTile(
          key: const ValueKey('settings_haptics_tile'),
          icon: Icons.vibration,
          title: context.l10n.hapticFeedback,
          subtitle: state.hapticsEnabled
              ? context.l10n.hapticsOn
              : context.l10n.hapticsOff,
          trailing: Switch.adaptive(
            key: const ValueKey('settings_haptics_switch'),
            value: state.hapticsEnabled,
            onChanged: state.isLoading
                ? null
                : context.read<SettingsPreferencesCubit>().setHapticsEnabled,
          ),
        );
      },
    );
  }
}
