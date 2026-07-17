import 'package:daily_mood_application/domain/models/activity_mood_correlation.dart';
import 'package:daily_mood_application/domain/models/mood_distribution_item.dart';
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
          activityCorrelations: Stream.value(const []),
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
    expect(
      find.byKey(const ValueKey('activity_correlation_empty_state')),
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
          activityCorrelations: Stream.value(_activityCorrelations()),
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
          activityCorrelations: Stream.value(_activityCorrelations()),
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

  testWidgets('renders activity correlation chart with labels and values', (
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
          activityCorrelations: Stream.value(_activityCorrelations()),
          focusedMonth: DateTime(2026, 7),
        ),
      ),
    );
    await tester.pump();

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -520));
    await tester.pumpAndSettle();

    expect(find.text('Activity impact'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('activity_correlation_chart')),
      findsOneWidget,
    );
    expect(find.text('Work'), findsOneWidget);
    expect(find.text('4.0 avg'), findsOneWidget);
    expect(find.text('2 entries'), findsWidgets);
    expect(
      find.byKey(const ValueKey('activity_correlation_empty_state')),
      findsNothing,
    );
  });

  testWidgets('renders local guided insights from mood patterns', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StatsScreen(
          weeklyTrend: Stream.value([
            _point(0, averageMood: 2, entryCount: 1),
            _point(1, averageMood: 2.5, entryCount: 1),
            _point(2, averageMood: 3, entryCount: 1),
            _point(3, averageMood: 4, entryCount: 1),
            _point(4, averageMood: 4.5, entryCount: 1),
          ]),
          monthlyHeatmap: Stream.value(_monthlyDays(hasEntries: true)),
          activityCorrelations: Stream.value(const [
            ActivityMoodCorrelation(
              activityId: 1,
              activityName: 'Work',
              entryCount: 3,
              averageMood: 2.2,
            ),
            ActivityMoodCorrelation(
              activityId: 2,
              activityName: 'Exercise',
              entryCount: 2,
              averageMood: 4.6,
            ),
          ]),
          moodDistribution: Stream.value(const [
            MoodDistributionItem(moodScore: 5, entryCount: 1, totalCount: 5),
            MoodDistributionItem(moodScore: 4, entryCount: 1, totalCount: 5),
            MoodDistributionItem(moodScore: 3, entryCount: 1, totalCount: 5),
            MoodDistributionItem(moodScore: 2, entryCount: 2, totalCount: 5),
          ]),
          focusedMonth: DateTime(2026, 7),
        ),
      ),
    );
    await tester.pump();

    expect(find.byKey(const ValueKey('guided_insights_card')), findsOneWidget);
    expect(find.text('Guided insights'), findsOneWidget);
    expect(find.text('Work showed up with lower moods'), findsOneWidget);
    expect(find.text('Exercise showed up with higher moods'), findsOneWidget);
    expect(find.textContaining('not medical advice'), findsOneWidget);
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

List<ActivityMoodCorrelation> _activityCorrelations() {
  return const [
    ActivityMoodCorrelation(
      activityId: 1,
      activityName: 'Work',
      entryCount: 2,
      averageMood: 4,
    ),
    ActivityMoodCorrelation(
      activityId: 2,
      activityName: 'Sleep',
      entryCount: 1,
      averageMood: 2,
    ),
  ];
}
