import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import '../core/database/app_database.dart';
import '../core/database/daos/activity_dao.dart';
import '../core/database/daos/daily_reflection_dao.dart';
import '../core/database/daos/mood_entry_dao.dart';
import '../data/repositories/daily_reflection_repository.dart';
import '../core/security/app_lock_cubit.dart';
import '../core/security/pin_repository.dart';
import '../data/repositories/activity_repository.dart';
import '../data/repositories/mood_analytics_repository.dart';
import '../data/repositories/mood_entry_repository.dart';
import '../data/services/activity_local_service.dart';
import '../data/services/daily_reflection_local_service.dart';
import '../data/services/mood_analytics_local_service.dart';
import '../data/services/mood_entry_local_service.dart';
import '../features/settings/data/settings_preferences_repository.dart';
import '../features/dashboard/dashboard_palette.dart';
import 'localization/app_locale_cubit.dart';
import 'localization/app_localizations.dart';
import 'routes/app_router.dart';
import 'theme/app_theme.dart';
import 'theme/app_theme_mode_cubit.dart';

/// Root widget.
///
/// Owns the single [AppDatabase] instance and the [AppLockCubit] for
/// the app's lifetime, provides them to the widget tree, wires the
/// GoRouter guard, and observes app lifecycle to trigger re-locking
/// after the configured background duration.
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  // Created once here, not inside build(), so it survives rebuilds and
  // isn't recreated (which would drop the open db connection).
  late final AppDatabase _database;
  late final MoodEntryDao _moodEntryDao;
  late final ActivityDao _activityDao;
  late final DailyReflectionDao _dailyReflectionDao;
  late final MoodAnalyticsRepository _moodAnalyticsRepository;
  late final MoodEntryRepository _moodEntryRepository;
  late final ActivityRepository _activityRepository;
  late final DailyReflectionRepository _dailyReflectionRepository;
  late final SettingsPreferencesRepository _settingsPreferencesRepository;
  late final AppLocaleCubit _localeCubit;
  late final AppThemeModeCubit _themeModeCubit;
  late final PinRepository _pinRepository;
  late final AppLockCubit _lockCubit;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _database = AppDatabase();
    _moodEntryDao = MoodEntryDao(_database);
    _activityDao = ActivityDao(_database);
    _dailyReflectionDao = DailyReflectionDao(_database);
    _moodAnalyticsRepository = MoodAnalyticsRepository(
      localService: MoodAnalyticsLocalService(moodEntryDao: _moodEntryDao),
    );
    _moodEntryRepository = MoodEntryRepository(
      localService: MoodEntryLocalService(moodEntryDao: _moodEntryDao),
    );
    _activityRepository = ActivityRepository(
      localService: ActivityLocalService(activityDao: _activityDao),
    );
    _dailyReflectionRepository = DailyReflectionRepository(
      localService: DailyReflectionLocalService(dao: _dailyReflectionDao),
    );
    _settingsPreferencesRepository = SettingsPreferencesRepository();
    _localeCubit = AppLocaleCubit(repository: _settingsPreferencesRepository);
    _themeModeCubit = AppThemeModeCubit(
      repository: _settingsPreferencesRepository,
    );
    _pinRepository = PinRepository();
    _lockCubit = AppLockCubit(pinRepository: _pinRepository);
    _router = buildAppRouter(_lockCubit, _pinRepository);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        _lockCubit.appPaused();
        break;
      case AppLifecycleState.resumed:
        _lockCubit.appResumed();
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _localeCubit.close();
    _themeModeCubit.close();
    _lockCubit.close();
    // Releases the native sqlite3/SQLCipher connection cleanly.
    _database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AppDatabase>.value(value: _database),
        RepositoryProvider<MoodAnalyticsRepository>.value(
          value: _moodAnalyticsRepository,
        ),
        RepositoryProvider<MoodEntryRepository>.value(
          value: _moodEntryRepository,
        ),
        RepositoryProvider<ActivityRepository>.value(
          value: _activityRepository,
        ),
        RepositoryProvider<DailyReflectionRepository>.value(
          value: _dailyReflectionRepository,
        ),
        RepositoryProvider<SettingsPreferencesRepository>.value(
          value: _settingsPreferencesRepository,
        ),
        RepositoryProvider<PinRepository>.value(value: _pinRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppLockCubit>.value(value: _lockCubit),
          BlocProvider<AppLocaleCubit>.value(value: _localeCubit),
          BlocProvider<AppThemeModeCubit>.value(value: _themeModeCubit),
        ],
        child: BlocBuilder<AppLocaleCubit, Locale>(
          builder: (context, locale) {
            return BlocBuilder<AppThemeModeCubit, ThemeMode>(
              builder: (context, themeMode) {
                DashboardPalette.resolve(
                  themeMode: themeMode,
                  platformBrightness: WidgetsBinding
                      .instance
                      .platformDispatcher
                      .platformBrightness,
                );

                return MaterialApp.router(
                  title: AppLocalizations(const Locale('en')).appTitle,
                  debugShowCheckedModeBanner: false,
                  locale: locale,
                  supportedLocales: AppLocalizations.supportedLocales,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: themeMode,
                  routerConfig: _router,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
