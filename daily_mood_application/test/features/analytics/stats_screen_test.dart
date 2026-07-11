import 'package:daily_mood_application/domain/models/monthly_mood_day.dart';
import 'package:daily_mood_application/domain/models/weekly_mood_point.dart';
import 'package:daily_mood_application/features/analytics/stats_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('hides weekly trend chart until three entries exist', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StatsScreen(
          weeklyTrend: Stream.value([
            _point(0, averageMood: 4, entryCount: 1),
            _point(1, averageMood: null, entryCount: 0),
            _point(2, averageMood: 3, entryCount: 1),
            _point(3, averageMood: null, entryCount: 0),
            _point(4, averageMood: null, entryCount: 0),
            _point(5, averageMood: null, entryCount: 0),
            _point(6, averageMood: null, entryCount: 0),
          ]),
          monthlyHeatmap: Stream.value(_monthlyDays(hasEntries: false)),
          focusedMonth: DateTime(2026, 7),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Stats'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('weekly_trend_empty_state')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('weekly_trend_line_chart')), findsNothing);
    expect(
      find.byKey(const ValueKey('monthly_heatmap_empty_state')),
      findsOneWidget,
    );
  });

  testWidgets('renders weekly trend chart for valid trend data', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StatsScreen(
          weeklyTrend: Stream.value([
            _point(0, averageMood: 4, entryCount: 2),
            _point(1, averageMood: null, entryCount: 0),
            _point(2, averageMood: 3, entryCount: 1),
            _point(3, averageMood: null, entryCount: 0),
            _point(4, averageMood: null, entryCount: 0),
            _point(5, averageMood: null, entryCount: 0),
            _point(6, averageMood: null, entryCount: 0),
          ]),
          monthlyHeatmap: Stream.value(_monthlyDays(hasEntries: true)),
          focusedMonth: DateTime(2026, 7),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Weekly trend'), findsOneWidget);
    expect(find.text('3 entries'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('weekly_trend_line_chart')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('weekly_trend_empty_state')),
      findsNothing,
    );
    expect(find.textContaining('TODO'), findsNothing);
  });

  testWidgets('renders monthly mood calendar when month has entries', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StatsScreen(
          weeklyTrend: Stream.value([
            _point(0, averageMood: 4, entryCount: 2),
            _point(1, averageMood: null, entryCount: 0),
            _point(2, averageMood: 3, entryCount: 1),
            _point(3, averageMood: null, entryCount: 0),
            _point(4, averageMood: null, entryCount: 0),
            _point(5, averageMood: null, entryCount: 0),
            _point(6, averageMood: null, entryCount: 0),
          ]),
          monthlyHeatmap: Stream.value(_monthlyDays(hasEntries: true)),
          focusedMonth: DateTime(2026, 7),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Mood calendar'), findsOneWidget);
    expect(find.byKey(const ValueKey('monthly_mood_calendar')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('monthly_heatmap_empty_state')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('monthly_heatmap_day_2026-7-1')),
      findsOneWidget,
    );
  });
}

WeeklyMoodPoint _point(
  int dayOffset, {
  required double? averageMood,
  required int entryCount,
}) {
  return WeeklyMoodPoint(
    date: DateTime(2026, 7, 6).add(Duration(days: dayOffset)),
    averageMood: averageMood,
    entryCount: entryCount,
  );
}

List<MonthlyMoodDay> _monthlyDays({required bool hasEntries}) {
  return [
    for (var offset = 0; offset < 31; offset++)
      MonthlyMoodDay(
        date: DateTime(2026, 7, 1).add(Duration(days: offset)),
        averageMood: hasEntries && offset == 0 ? 4 : null,
        entryCount: hasEntries && offset == 0 ? 2 : 0,
      ),
  ];
}
