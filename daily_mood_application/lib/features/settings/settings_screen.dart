import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/security/app_lock_cubit.dart';
import 'data/settings_preferences_repository.dart';
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
  }) : _preferencesRepository = preferencesRepository;

  final SettingsPreferencesRepository? _preferencesRepository;
  final VoidCallback? onLockNow;
  final VoidCallback? onExportData;
  final VoidCallback? onImportData;
  final VoidCallback? onDeleteData;

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
  });

  final VoidCallback? onLockNow;
  final VoidCallback? onExportData;
  final VoidCallback? onImportData;
  final VoidCallback? onDeleteData;

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
                    subtitle: 'Create a manual backup file when export lands.',
                    onTap:
                        onExportData ??
                        () => _showComingSoon(
                          context,
                          'Export data',
                          'Manual JSON/CSV export is scheduled for Phase 6.',
                        ),
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
                        onDeleteData ?? () => _showDeletePreviewDialog(context),
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

  Future<void> _showDeletePreviewDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete all local data'),
          content: const Text(
            'The permanent reset flow is scheduled for the next data-control slice.',
          ),
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
