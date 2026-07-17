import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/localization/app_locale_cubit.dart';
import '../../app/localization/app_localizations.dart';
import '../../app/theme/app_theme_mode_cubit.dart';
import '../../core/database/app_database.dart';
import '../../core/security/app_lock_cubit.dart';
import '../../data/repositories/activity_repository.dart';
import '../../domain/models/mood_activity.dart';
import 'data/backup_export_service.dart';
import 'data/backup_import_file_service.dart';
import 'data/backup_import_parser.dart';
import 'data/local_data_reset_service.dart';
import 'data/settings_preferences_repository.dart';
import 'state/delete_all_data_cubit.dart';
import 'state/settings_preferences_cubit.dart';
import 'state/settings_preferences_state.dart';
import 'widgets/delete_all_data_dialog.dart';
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
        return _CustomTagsSheet(repository: repository);
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

class _CustomTagsSheet extends StatelessWidget {
  const _CustomTagsSheet({required this.repository});

  final ActivityRepository repository;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.manageCustomTags, style: theme.textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(
              l10n.manageCustomTagsBody,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.55,
              ),
              child: StreamBuilder<List<MoodActivity>>(
                stream: repository.watchCustomActivities(),
                builder: (context, snapshot) {
                  final tags = snapshot.data ?? const <MoodActivity>[];
                  if (tags.isEmpty) {
                    return _CustomTagsEmptyState(message: l10n.noCustomTags);
                  }

                  return ListView.separated(
                    key: const ValueKey('custom_tags_list'),
                    shrinkWrap: true,
                    itemCount: tags.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final tag = tags[index];
                      return _CustomTagTile(
                        tag: tag,
                        repository: repository,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomTagsEmptyState extends StatelessWidget {
  const _CustomTagsEmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _CustomTagTile extends StatelessWidget {
  const _CustomTagTile({required this.tag, required this.repository});

  final MoodActivity tag;
  final ActivityRepository repository;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final status = tag.isArchived ? l10n.archivedTag : l10n.activeTag;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.55),
        ),
      ),
      child: ListTile(
        key: ValueKey('custom_tag_${tag.id}'),
        minVerticalPadding: 12,
        leading: Icon(
          tag.isArchived ? Icons.inventory_2_outlined : Icons.label_outline,
          color: tag.isArchived
              ? theme.colorScheme.onSurfaceVariant
              : theme.colorScheme.primary,
        ),
        title: Text(
          l10n.activityLabel(tag.name),
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text('${l10n.categoryLabel(tag.category)} • $status'),
        trailing: TextButton(
          key: ValueKey(
            tag.isArchived
                ? 'restore_custom_tag_${tag.id}'
                : 'archive_custom_tag_${tag.id}',
          ),
          onPressed: () => _toggleArchive(context),
          child: Text(tag.isArchived ? l10n.restore : l10n.archive),
        ),
      ),
    );
  }

  Future<void> _toggleArchive(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    try {
      if (tag.isArchived) {
        await repository.restoreCustomActivity(tag.id);
        messenger.hideCurrentSnackBar();
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.customTagRestored(tag.name))),
        );
      } else {
        await repository.archiveCustomActivity(tag.id);
        messenger.hideCurrentSnackBar();
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.customTagArchived(tag.name))),
        );
      }
    } catch (_) {
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.customTagUpdateFailed)),
      );
    }
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
