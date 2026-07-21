import 'package:daily_mood_application/app/localization/app_localizations.dart';
import 'package:daily_mood_application/features/shell/shell_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders shell drawer destinations and reports selection', (
    tester,
  ) async {
    ShellDrawerDestination? selected;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [AppLocalizations.delegate],
        home: Scaffold(
          body: ShellDrawer(
            selectedDestination: ShellDrawerDestination.home,
            onDestinationSelected: (destination) {
              selected = destination;
            },
          ),
        ),
      ),
    );

    expect(find.byKey(const ValueKey('main_shell_drawer')), findsOneWidget);
    expect(find.text('Daily Mood'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Stats'), findsOneWidget);
    expect(find.text('Add mood'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('drawer_destination_stats')));
    await tester.pump();

    expect(selected, ShellDrawerDestination.stats);
  });
}
