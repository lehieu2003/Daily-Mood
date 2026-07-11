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
    createdAt: createdAt,
    updatedAt: createdAt,
  );
}
