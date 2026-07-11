import 'package:daily_mood_application/domain/models/mood_entry.dart';
import 'package:daily_mood_application/features/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows first-use empty state without trend content', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: DashboardScreen(entries: Stream.value(const []))),
    );
    await tester.pump();

    expect(find.byKey(const ValueKey('dashboard_empty_state')), findsOneWidget);
    expect(find.text('No mood entries yet'), findsOneWidget);
    expect(find.text("Today's check-in"), findsNothing);
  });

  testWidgets('shows dashboard summaries and recent entries', (tester) async {
    final now = DateTime.now();
    final entries = [
      _entry(
        id: 1,
        moodScore: 5,
        note: 'Had a fantastic coding run.',
        createdAt: now,
      ),
      _entry(
        id: 2,
        moodScore: 3,
        note: 'Steady afternoon.',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(home: DashboardScreen(entries: Stream.value(entries))),
    );
    await tester.pump();

    expect(find.text("Today's check-in"), findsOneWidget);
    expect(find.text('Mood chart'), findsOneWidget);
    expect(find.text('Check-in'), findsOneWidget);
    expect(find.textContaining('Had a fantastic coding run.'), findsOneWidget);
    expect(find.textContaining('Steady afternoon.'), findsOneWidget);
    expect(find.text('Connect with nature'), findsOneWidget);
    expect(find.byKey(const ValueKey('weekly_trend_entry_card')), findsNothing);
  });

  testWidgets('shows weekly trend entry point after three entries', (
    tester,
  ) async {
    var trendOpened = false;
    final now = DateTime.now();
    final entries = [
      _entry(
        id: 1,
        moodScore: 5,
        note: 'Strong morning.',
        createdAt: now,
      ),
      _entry(
        id: 2,
        moodScore: 4,
        note: 'Good lunch.',
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      _entry(
        id: 3,
        moodScore: 3,
        note: 'Steady evening.',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: DashboardScreen(
          entries: Stream.value(entries),
          onOpenTrend: () => trendOpened = true,
        ),
      ),
    );
    await tester.pump();

    expect(find.byKey(const ValueKey('weekly_trend_entry_card')), findsOneWidget);
    expect(find.text('Weekly trend'), findsOneWidget);
    expect(find.text('3 entries ready - Average 4.0'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey('weekly_trend_entry_card')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('weekly_trend_entry_card')));
    await tester.pump();

    expect(trendOpened, isTrue);
  });

  testWidgets('opens entry detail sheet and saves edits', (tester) async {
    int? updatedId;
    int? updatedScore;
    String? updatedNote;
    final now = DateTime.now();
    final entries = [
      _entry(
        id: 1,
        moodScore: 3,
        note: 'Steady afternoon.',
        createdAt: now,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: DashboardScreen(
          entries: Stream.value(entries),
          onUpdateEntry: ({
            required int id,
            required int moodScore,
            required String note,
          }) async {
            updatedId = id;
            updatedScore = moodScore;
            updatedNote = note;
          },
          onDeleteEntry: (_) async {},
        ),
      ),
    );
    await tester.pump();

    await tester.ensureVisible(
      find.byKey(const ValueKey('dashboard_entry_card_1')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('dashboard_entry_card_1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('entry_mood_score_4')));
    await tester.enterText(
      find.byKey(const ValueKey('entry_detail_note_field')),
      'Edited note',
    );
    await tester.tap(find.byKey(const ValueKey('entry_detail_save_button')));
    await tester.pumpAndSettle();

    expect(updatedId, 1);
    expect(updatedScore, 4);
    expect(updatedNote, 'Edited note');
  });
}

MoodEntryModel _entry({
  required int id,
  required int moodScore,
  required String note,
  required DateTime createdAt,
}) {
  return MoodEntryModel(
    id: id,
    uuid: 'entry-$id',
    moodScore: moodScore,
    note: note,
    voiceNotePath: null,
    createdAt: createdAt,
    updatedAt: createdAt,
  );
}
