import 'package:equatable/equatable.dart';

enum SettingsPreferenceStatus { loading, ready }

class SettingsPreferencesState extends Equatable {
  const SettingsPreferencesState({
    required this.status,
    required this.hapticsEnabled,
    required this.languageCode,
    required this.themeModeName,
    required this.dailyReminderEnabled,
    required this.dailyReminderHour,
    required this.dailyReminderMinute,
  });

  const SettingsPreferencesState.loading()
    : this(
        status: SettingsPreferenceStatus.loading,
        hapticsEnabled: true,
        languageCode: 'en',
        themeModeName: 'system',
        dailyReminderEnabled: false,
        dailyReminderHour: 20,
        dailyReminderMinute: 0,
      );

  const SettingsPreferencesState.ready({
    required bool hapticsEnabled,
    required String languageCode,
    required String themeModeName,
    required bool dailyReminderEnabled,
    required int dailyReminderHour,
    required int dailyReminderMinute,
  }) : this(
         status: SettingsPreferenceStatus.ready,
         hapticsEnabled: hapticsEnabled,
         languageCode: languageCode,
         themeModeName: themeModeName,
         dailyReminderEnabled: dailyReminderEnabled,
         dailyReminderHour: dailyReminderHour,
         dailyReminderMinute: dailyReminderMinute,
       );

  final SettingsPreferenceStatus status;
  final bool hapticsEnabled;
  final String languageCode;
  final String themeModeName;
  final bool dailyReminderEnabled;
  final int dailyReminderHour;
  final int dailyReminderMinute;

  bool get isLoading => status == SettingsPreferenceStatus.loading;
  String get dailyReminderTimeLabel {
    final hour = dailyReminderHour.toString().padLeft(2, '0');
    final minute = dailyReminderMinute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  List<Object?> get props => [
    status,
    hapticsEnabled,
    languageCode,
    themeModeName,
    dailyReminderEnabled,
    dailyReminderHour,
    dailyReminderMinute,
  ];
}
