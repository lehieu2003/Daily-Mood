import 'package:daily_mood_application/domain/models/mood_entry.dart';
import 'package:daily_mood_application/features/dashboard/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows empty state when history stream has no entries', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: HistoryScreen(entries: Stream.value(const []))),
    );
    await tester.pump();

    expect(find.text('History'), findsOneWidget);
    expect(find.byKey(const ValueKey('history_empty_state')), findsOneWidget);
    expect(find.text('No history yet'), findsOneWidget);
  });

  testWidgets('groups streamed entries by day', (tester) async {
    final now = DateTime.now();
    final entries = [
      _entry(id: 1, moodScore: 5, note: 'Strong morning.', createdAt: now),
      _entry(
        id: 2,
        moodScore: 2,
        note: 'Tense evening.',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(home: HistoryScreen(entries: Stream.value(entries))),
    );
    await tester.pump();

    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Yesterday'), findsOneWidget);
    expect(find.text('Great'), findsOneWidget);
    expect(find.text('Bad'), findsOneWidget);
    expect(find.text('Strong morning.'), findsOneWidget);
    expect(find.text('Tense evening.'), findsOneWidget);
  });

  testWidgets('filters history by note, activity, and emotion search', (
    tester,
  ) async {
    final now = DateTime.now();
    final entries = [
      _entry(
        id: 1,
        moodScore: 5,
        note: 'Strong morning.',
        createdAt: now,
        activityNames: const ['Exercise'],
        subEmotionNames: const ['Energized'],
      ),
      _entry(
        id: 2,
        moodScore: 2,
        note: 'Tense evening.',
        createdAt: now,
        activityNames: const ['Work'],
        subEmotionNames: const ['Anxious'],
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(home: HistoryScreen(entries: Stream.value(entries))),
    );
    await tester.pump();

    await tester.enterText(
      find.byKey(const ValueKey('history_search_field')),
      'exercise',
    );
    await tester.pump();

    expect(find.text('Strong morning.'), findsOneWidget);
    expect(find.text('Tense evening.'), findsNothing);

    await tester.enterText(
      find.byKey(const ValueKey('history_search_field')),
      'anxious',
    );
    await tester.pump();

    expect(find.text('Strong morning.'), findsNothing);
    expect(find.text('Tense evening.'), findsOneWidget);
  });

  testWidgets('filters history by mood score and date range', (tester) async {
    final now = DateTime.now();
    final entries = [
      _entry(
        id: 1,
        moodScore: 5,
        note: 'Today great.',
        createdAt: now,
      ),
      _entry(
        id: 2,
        moodScore: 2,
        note: 'Old bad.',
        createdAt: now.subtract(const Duration(days: 8)),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(home: HistoryScreen(entries: Stream.value(entries))),
    );
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('history_mood_filter_2')));
    await tester.pump();

    expect(find.text('Today great.'), findsNothing);
    expect(find.text('Old bad.'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('history_date_filter_today')));
    await tester.pump();

    expect(find.text('Old bad.'), findsNothing);
    expect(find.byKey(const ValueKey('history_no_matches_state')), findsOneWidget);
  });

  testWidgets('opens entry detail sheet and soft-deletes entry', (tester) async {
    int? deletedId;
    final now = DateTime.now();
    final entries = [
      _entry(
        id: 1,
        moodScore: 5,
        note: 'Strong morning.',
        createdAt: now,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: HistoryScreen(
          entries: Stream.value(entries),
          onUpdateEntry: ({
            required int id,
            required int moodScore,
            required String note,
          }) async {},
          onDeleteEntry: (id) async {
            deletedId = id;
          },
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('history_entry_tile_1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('entry_detail_delete_button')));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('entry_detail_confirm_delete_button')),
    );
    await tester.pumpAndSettle();

    expect(deletedId, 1);
  });
}

MoodEntryModel _entry({
  required int id,
  required int moodScore,
  required String note,
  required DateTime createdAt,
  List<String> activityNames = const [],
  List<String> subEmotionNames = const [],
}) {
  return MoodEntryModel(
    id: id,
    uuid: 'entry-$id',
    moodScore: moodScore,
    note: note,
    createdAt: createdAt,
    updatedAt: createdAt,
    activityNames: activityNames,
    subEmotionNames: subEmotionNames,
  );
}
