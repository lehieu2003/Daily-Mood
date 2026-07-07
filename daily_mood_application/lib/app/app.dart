import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/database/app_database.dart';
import '../core/database/daos/activity_dao.dart';
import '../core/database/daos/mood_entry_dao.dart';
import '../core/security/app_lock_cubit.dart';
import '../core/security/pin_repository.dart';
import 'routes/app_router.dart';

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
        RepositoryProvider<MoodEntryDao>.value(value: _moodEntryDao),
        RepositoryProvider<ActivityDao>.value(value: _activityDao),
        RepositoryProvider<PinRepository>.value(value: _pinRepository),
      ],
      child: BlocProvider<AppLockCubit>.value(
        value: _lockCubit,
        child: MaterialApp.router(
          title: 'Daily Mood',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFFF8FAFC), // Slate 50
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFBAE6FD), // Sky pastel, matches spec
              brightness: Brightness.light,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFF0F172A), // Slate 900
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF075985),
              brightness: Brightness.dark,
            ),
          ),
          themeMode: ThemeMode.system,
          routerConfig: _router,
        ),
      ),
    );
  }
}
