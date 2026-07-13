import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/database/app_database.dart';
import '../../core/security/app_lock_cubit.dart';
import 'data/backup_export_service.dart';
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
    this.onDataDeleted,
  }) : _preferencesRepository = preferencesRepository;

  final SettingsPreferencesRepository? _preferencesRepository;
  final VoidCallback? onLockNow;
  final VoidCallback? onExportData;
  final VoidCallback? onImportData;
  final VoidCallback? onDeleteData;
  final LocalDataResetService? dataResetService;
  final BackupExportService? backupExportService;
  final VoidCallback? onDataDeleted;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsPreferencesCubit(
        repository: _preferencesRepository ?? SettingsPreferencesRepository(),
      ),
      child: _SettingsView(
        onLockNow: onLockNow,
        onExportData: onExportData,
        onImportData: onImportData,
        onDeleteData: onDeleteData,
        dataResetService: dataResetService,
        backupExportService: backupExportService,
        onDataDeleted: onDataDeleted,
      ),
    );
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
    this.onDataDeleted,
  });

  final VoidCallback? onLockNow;
  final VoidCallback? onExportData;
  final VoidCallback? onImportData;
  final VoidCallback? onDeleteData;
  final LocalDataResetService? dataResetService;
  final BackupExportService? backupExportService;
  final VoidCallback? onDataDeleted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 112),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Settings', style: theme.textTheme.headlineLarge),
              const SizedBox(height: 6),
              Text(
                'Local privacy, data control, and app preferences.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              SettingsSection(
                title: 'Privacy lock',
                children: [
                  SettingsTile(
                    key: const ValueKey('settings_lock_now_tile'),
                    icon: Icons.lock_outline,
                    title: 'Lock now',
                    subtitle: 'Require PIN or biometrics before continuing.',
                    onTap: () => _lockNow(context),
                  ),
                  const SettingsDivider(),
                  const SettingsTile(
                    key: ValueKey('settings_pin_biometrics_tile'),
                    icon: Icons.fingerprint,
                    title: 'PIN & biometrics',
                    subtitle: 'PIN setup exists; change controls arrive next.',
                    enabled: false,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SettingsSection(
                title: 'Data control',
                children: [
                  SettingsTile(
                    key: const ValueKey('settings_export_tile'),
                    icon: Icons.ios_share_outlined,
                    title: 'Export data',
                    subtitle: 'Create a readable JSON or CSV backup file.',
                    onTap:
                        onExportData ??
                        () => _showExportFormatDialog(context),
                  ),
                  const SettingsDivider(),
                  SettingsTile(
                    key: const ValueKey('settings_import_tile'),
                    icon: Icons.file_upload_outlined,
                    title: 'Import data',
                    subtitle: 'Restore a backup without automatic cloud sync.',
                    onTap:
                        onImportData ??
                        () => _showComingSoon(
                          context,
                          'Import data',
                          'Backup import and conflict handling are scheduled for Phase 6.',
                        ),
                  ),
                  const SettingsDivider(),
                  SettingsTile(
                    key: const ValueKey('settings_delete_data_tile'),
                    icon: Icons.delete_outline,
                    title: 'Delete all local data',
                    subtitle:
                        'Permanent local reset will require confirmation.',
                    isDestructive: true,
                    onTap:
                        onDeleteData ?? () => _showDeleteAllDataDialog(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SettingsSection(
                title: 'Experience',
                children: const [_HapticsTile()],
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

  Future<void> _showComingSoon(
    BuildContext context,
    String title,
    String message,
  ) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showExportFormatDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Export data'),
          content: const Text(
            'Choose a readable backup format. Photos and voice files are exported as relative path references for now.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
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
    final service =
        backupExportService ??
        DriftBackupExportService(database: context.read<AppDatabase>());

    try {
      final file = await service.exportAndShare(format);
      messenger.showSnackBar(
        SnackBar(content: Text('Export file ready: ${file.fileName}')),
      );
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Export failed. Please try again.')),
      );
    }
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
                const SnackBar(content: Text('Local data deleted.')),
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

    return BlocConsumer<DeleteAllDataCubit, DeleteAllDataState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.isSuccess) {
          widget.onDeleted();
        }
      },
      builder: (context, state) {
        return AlertDialog(
          title: const Text('Delete all local data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'This permanently removes mood entries, notes, media links, and custom tags from this device.',
              ),
              const SizedBox(height: 12),
              Text(
                'Type DELETE to confirm.',
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
              child: const Text('Cancel'),
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
                  : const Text('Delete'),
            ),
          ],
        );
      },
    );
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
          title: 'Haptic feedback',
          subtitle: state.hapticsEnabled
              ? 'Light taps stay enabled for mood selection.'
              : 'Mood logging will stay quiet.',
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
