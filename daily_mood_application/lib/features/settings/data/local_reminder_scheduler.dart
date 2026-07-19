import 'settings_preferences_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

abstract interface class LocalReminderScheduler {
  Future<bool> scheduleDaily(
    DailyReminderTime time, {
    String languageCode = 'en',
  });
  Future<void> cancelDaily();
}

class NoopLocalReminderScheduler implements LocalReminderScheduler {
  const NoopLocalReminderScheduler();

  @override
  Future<bool> scheduleDaily(
    DailyReminderTime time, {
    String languageCode = 'en',
  }) async {
    return true;
  }

  @override
  Future<void> cancelDaily() async {}
}

class FlutterLocalReminderScheduler implements LocalReminderScheduler {
  FlutterLocalReminderScheduler({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const int dailyReminderNotificationId = 1001;
  static const String _channelId = 'daily_mood_daily_reminders';
  static const String _channelName = 'Daily mood reminders';
  static const String _channelDescription =
      'Gentle local reminders to log today mood.';

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  @override
  Future<bool> scheduleDaily(
    DailyReminderTime time, {
    String languageCode = 'en',
  }) async {
    if (!_supportsDailyNotifications) return false;
    await _ensureInitialized();

    final permitted = await _requestNotificationPermissions();
    if (!permitted) return false;

    await cancelDaily();
    final copy = DailyReminderNotificationCopy.forLanguage(languageCode);
    await _plugin.zonedSchedule(
      id: dailyReminderNotificationId,
      title: copy.title,
      body: copy.body,
      scheduledDate: nextDailyReminderDate(time),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'daily-reminder',
    );
    return true;
  }

  @override
  Future<void> cancelDaily() async {
    if (!_supportsDailyNotifications) return;
    await _ensureInitialized();
    await _plugin.cancel(id: dailyReminderNotificationId);
  }

  Future<void> _ensureInitialized() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();
    await _setDeviceTimezone();
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
    await _createAndroidChannel();
    _initialized = true;
  }

  Future<void> _setDeviceTimezone() async {
    try {
      final timezone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezone.identifier));
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }
  }

  Future<void> _createAndroidChannel() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.defaultImportance,
      ),
    );
  }

  Future<bool> _requestNotificationPermissions() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final androidGranted = await android?.requestNotificationsPermission();
    if (androidGranted == false) return false;

    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    final iosGranted = await ios?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    if (iosGranted == false) return false;

    return true;
  }

  bool get _supportsDailyNotifications {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }
}

tz.TZDateTime nextDailyReminderDate(
  DailyReminderTime time, {
  tz.Location? location,
  tz.TZDateTime? now,
}) {
  final reminderLocation = location ?? tz.local;
  final current = now ?? tz.TZDateTime.now(reminderLocation);
  var scheduled = tz.TZDateTime(
    reminderLocation,
    current.year,
    current.month,
    current.day,
    time.hour,
    time.minute,
  );
  if (!scheduled.isAfter(current)) {
    scheduled = scheduled.add(const Duration(days: 1));
  }
  return scheduled;
}

class DailyReminderNotificationCopy {
  const DailyReminderNotificationCopy({
    required this.title,
    required this.body,
  });

  factory DailyReminderNotificationCopy.forLanguage(String languageCode) {
    if (languageCode == 'vi') {
      return const DailyReminderNotificationCopy(
        title: 'Daily Mood',
        body: 'Den gio ghi lai tam trang hom nay.',
      );
    }
    return const DailyReminderNotificationCopy(
      title: 'Daily Mood',
      body: 'Time to check in with your mood today.',
    );
  }

  final String title;
  final String body;
}
