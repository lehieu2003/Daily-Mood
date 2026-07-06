import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/database/app_database.dart';
import '../core/database/daos/activity_dao.dart';
import '../core/database/daos/mood_entry_dao.dart';

/// Root widget.
///
/// Owns the single [AppDatabase] instance for the app's lifetime,
/// provides it (and its DAOs) to the whole widget tree via
/// [MultiRepositoryProvider], and closes the connection on dispose.
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  // Created once here, not inside build(), so it survives rebuilds and
  // isn't recreated (which would drop the open db connection).
  late final AppDatabase _database;
  late final MoodEntryDao _moodEntryDao;
  late final ActivityDao _activityDao;

  @override
  void initState() {
    super.initState();
    _database = AppDatabase();
    _moodEntryDao = MoodEntryDao(_database);
    _activityDao = ActivityDao(_database);
  }

  @override
  void dispose() {
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
      ],
      child: MaterialApp(
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
        // Replaced with GoRouter + the PIN/biometric guard once that
        // piece is built — placeholder home for now so this compiles
        // and runs on its own.
        home: const _HomePlaceholder(),
      ),
    );
  }
}

class _HomePlaceholder extends StatelessWidget {
  const _HomePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Daily Mood — routing not wired up yet')),
    );
  }
}
