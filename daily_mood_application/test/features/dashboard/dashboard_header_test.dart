import 'package:daily_mood_application/features/dashboard/widgets/dashboard_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows morning icon before noon', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DashboardHeader(
            now: DateTime(2026, 7, 19, 8),
            onLogMood: () {},
          ),
        ),
      ),
    );

    expect(
      find.descendant(
        of: find.byKey(const ValueKey('dashboard_time_of_day_icon')),
        matching: find.byIcon(Icons.wb_sunny_outlined),
      ),
      findsOneWidget,
    );
    expect(find.text('Good morning'), findsOneWidget);
  });

  testWidgets('shows afternoon icon before evening', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DashboardHeader(
            now: DateTime(2026, 7, 19, 14),
            onLogMood: () {},
          ),
        ),
      ),
    );

    expect(
      find.descendant(
        of: find.byKey(const ValueKey('dashboard_time_of_day_icon')),
        matching: find.byIcon(Icons.light_mode_outlined),
      ),
      findsOneWidget,
    );
    expect(find.text('Good afternoon'), findsOneWidget);
  });

  testWidgets('shows evening icon from 18:00 onward', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DashboardHeader(
            now: DateTime(2026, 7, 19, 20),
            onLogMood: () {},
          ),
        ),
      ),
    );

    expect(
      find.descendant(
        of: find.byKey(const ValueKey('dashboard_time_of_day_icon')),
        matching: find.byIcon(Icons.nights_stay_outlined),
      ),
      findsOneWidget,
    );
    expect(find.text('Good night'), findsOneWidget);
  });
}
