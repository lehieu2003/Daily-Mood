import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/localization/app_locale_cubit.dart';
import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/app_theme_mode_cubit.dart';
import '../data/settings_preferences_repository.dart';
import '../state/settings_preferences_cubit.dart';
import '../state/settings_preferences_state.dart';
import 'settings_divider.dart';
import 'settings_section.dart';
import 'settings_tile.dart';

typedef DailyReminderTimePicker =
    Future<DailyReminderTime?> Function(
      BuildContext context,
      SettingsPreferencesState state,
    );

class SettingsExperienceSection extends StatelessWidget {
  const SettingsExperienceSection({super.key, this.reminderTimePicker});

  final DailyReminderTimePicker? reminderTimePicker;

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: context.l10n.experience,
      children: [
        const _AppearanceTile(),
        const SettingsDivider(),
        const _LanguageTile(),
        const SettingsDivider(),
        _DailyReminderTile(reminderTimePicker: reminderTimePicker),
        const SettingsDivider(),
        const _HapticsTile(),
      ],
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

class _DailyReminderTile extends StatelessWidget {
  const _DailyReminderTile({this.reminderTimePicker});

  final DailyReminderTimePicker? reminderTimePicker;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsPreferencesCubit, SettingsPreferencesState>(
      builder: (context, state) {
        final l10n = context.l10n;
        return SettingsTile(
          key: const ValueKey('settings_daily_reminder_tile'),
          icon: Icons.notifications_none_rounded,
          title: l10n.dailyReminder,
          subtitle: state.dailyReminderEnabled
              ? l10n.dailyReminderOn(state.dailyReminderTimeLabel)
              : l10n.dailyReminderOff,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                key: const ValueKey('settings_daily_reminder_time_button'),
                onPressed: state.isLoading
                    ? null
                    : () => _pickReminderTime(context, state),
                child: Text(state.dailyReminderTimeLabel),
              ),
              Switch.adaptive(
                key: const ValueKey('settings_daily_reminder_switch'),
                value: state.dailyReminderEnabled,
                onChanged: state.isLoading
                    ? null
                    : (enabled) => _setReminderEnabled(
                        context,
                        state,
                        enabled,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _setReminderEnabled(
    BuildContext context,
    SettingsPreferencesState state,
    bool enabled,
  ) async {
    final cubit = context.read<SettingsPreferencesCubit>();
    if (!enabled) {
      await cubit.setDailyReminderEnabled(false);
      return;
    }

    final selected = await _selectReminderTime(context, state);
    if (selected == null || !context.mounted) return;

    await cubit.setDailyReminderTime(selected);
    if (!context.mounted) return;
    await cubit.setDailyReminderEnabled(true);
  }

  Future<void> _pickReminderTime(
    BuildContext context,
    SettingsPreferencesState state,
  ) async {
    final selected = await _selectReminderTime(context, state);
    if (selected == null || !context.mounted) return;

    await context.read<SettingsPreferencesCubit>().setDailyReminderTime(
      selected,
    );
  }

  Future<DailyReminderTime?> _selectReminderTime(
    BuildContext context,
    SettingsPreferencesState state,
  ) async {
    final customPicker = reminderTimePicker;
    if (customPicker != null) {
      return customPicker(context, state);
    }

    final selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: state.dailyReminderHour,
        minute: state.dailyReminderMinute,
      ),
    );
    if (selected == null) return null;
    return DailyReminderTime(hour: selected.hour, minute: selected.minute);
  }
}
