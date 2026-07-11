import 'package:daily_mood_application/features/settings/data/local_data_reset_service.dart';
import 'package:daily_mood_application/features/settings/data/settings_preferences_repository.dart';
import 'package:daily_mood_application/features/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders settings entry points for lock data and haptics', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        SettingsScreen(
          preferencesRepository: SettingsPreferencesRepository(
            store: InMemorySettingsPreferencesStore(),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Privacy lock'), findsOneWidget);
    expect(find.text('Lock now'), findsOneWidget);
    expect(find.text('PIN & biometrics'), findsOneWidget);
    expect(find.text('Data control'), findsOneWidget);
    expect(find.text('Export data'), findsOneWidget);
    expect(find.text('Import data'), findsOneWidget);
    expect(find.text('Delete all local data'), findsOneWidget);
    expect(find.text('Experience'), findsOneWidget);
    expect(find.text('Haptic feedback'), findsOneWidget);
    expect(find.textContaining('TODO'), findsNothing);
  });

  testWidgets('persists haptics toggle state', (tester) async {
    final store = InMemorySettingsPreferencesStore();
    final repository = SettingsPreferencesRepository(store: store);

    await tester.pumpWidget(
      _app(SettingsScreen(preferencesRepository: repository)),
    );
    await tester.pump();

    Switch adaptiveSwitch() {
      return tester.widget<Switch>(
        find.byKey(const ValueKey('settings_haptics_switch')),
      );
    }

    expect(adaptiveSwitch().value, isTrue);

    await tester.ensureVisible(
      find.byKey(const ValueKey('settings_haptics_switch')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('settings_haptics_switch')));
    await tester.pump();

    expect(adaptiveSwitch().value, isFalse);
    expect(await repository.readHapticsEnabled(), isFalse);
  });

  testWidgets('lock now tile calls lock action', (tester) async {
    var locked = false;

    await tester.pumpWidget(
      _app(
        SettingsScreen(
          preferencesRepository: SettingsPreferencesRepository(
            store: InMemorySettingsPreferencesStore(),
          ),
          onLockNow: () => locked = true,
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('settings_lock_now_tile')));
    await tester.pump();

    expect(locked, isTrue);
  });

  testWidgets('delete data flow requires confirmation before reset', (
    tester,
  ) async {
    final resetService = _FakeLocalDataResetService();
    var deleted = false;

    await tester.pumpWidget(
      _app(
        SettingsScreen(
          preferencesRepository: SettingsPreferencesRepository(
            store: InMemorySettingsPreferencesStore(),
          ),
          dataResetService: resetService,
          onDataDeleted: () => deleted = true,
        ),
      ),
    );
    await tester.pump();

    await tester.ensureVisible(
      find.byKey(const ValueKey('settings_delete_data_tile')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('settings_delete_data_tile')));
    await tester.pumpAndSettle();

    expect(find.text('Delete all local data'), findsWidgets);
    expect(find.text('Type DELETE to confirm.'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(
            find.byKey(const ValueKey('delete_all_data_confirm_button')),
          )
          .onPressed,
      isNull,
    );

    await tester.enterText(
      find.byKey(const ValueKey('delete_all_data_confirmation_field')),
      'DELETE',
    );
    await tester.pump();
    await tester.tap(
      find.byKey(const ValueKey('delete_all_data_confirm_button')),
    );
    await tester.pumpAndSettle();

    expect(resetService.deleteCount, 1);
    expect(deleted, isTrue);
    expect(find.text('Local data deleted.'), findsOneWidget);
  });
}

Widget _app(Widget child) {
  return MaterialApp(home: child);
}

class _FakeLocalDataResetService implements LocalDataResetService {
  int deleteCount = 0;

  @override
  Future<void> deleteAllData() async {
    deleteCount++;
  }
}
