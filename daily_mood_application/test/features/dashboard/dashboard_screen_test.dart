import 'package:daily_mood_application/domain/models/mood_activity.dart';
import 'package:daily_mood_application/domain/models/mood_entry.dart';
import 'package:daily_mood_application/features/dashboard/dashboard_screen.dart';
import 'package:daily_mood_application/features/dashboard/widgets/entry_detail_sheet.dart';
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
    expect(find.text('10:08'), findsNothing);
    expect(find.text('12:10'), findsNothing);
    expect(find.textContaining('Had a fantastic coding run.'), findsOneWidget);
    expect(find.textContaining('Steady afternoon.'), findsNothing);
    expect(find.text('Connect with nature'), findsOneWidget);
    expect(find.byKey(const ValueKey('weekly_trend_entry_card')), findsNothing);
  });

  testWidgets('shows real moods in the weekly selector', (tester) async {
    final today = DateTime(2026, 7, 13, 9);
    final entries = [
      _entry(
        id: 1,
        moodScore: 5,
        note: 'Bright start.',
        createdAt: today,
      ),
      _entry(
        id: 2,
        moodScore: 2,
        note: 'Hard weekend.',
        createdAt: today.subtract(const Duration(days: 2)),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: DashboardScreen(
          entries: Stream.value(entries),
          today: today,
        ),
      ),
    );
    await tester.pump();

    expect(find.byKey(const ValueKey('week_mood_day_20260707')), findsOneWidget);
    expect(find.byKey(const ValueKey('week_mood_day_20260713')), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('week_mood_day_20260713')),
        matching: find.text('😍'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('week_mood_day_20260711')),
        matching: find.text('😞'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('shows real today entries in the mood chart', (tester) async {
    final today = DateTime(2026, 7, 13);
    final entries = [
      _entry(
        id: 1,
        moodScore: 2,
        note: 'Slow afternoon.',
        createdAt: DateTime(2026, 7, 13, 15, 30),
      ),
      _entry(
        id: 2,
        moodScore: 5,
        note: 'Bright morning.',
        createdAt: DateTime(2026, 7, 13, 9, 5),
      ),
      _entry(
        id: 3,
        moodScore: 1,
        note: 'Yesterday should not chart today.',
        createdAt: DateTime(2026, 7, 12, 20, 10),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: DashboardScreen(
          entries: Stream.value(entries),
          today: today,
        ),
      ),
    );
    await tester.pump();

    expect(find.text('09:05'), findsOneWidget);
    expect(find.text('15:30'), findsOneWidget);
    expect(find.text('20:10'), findsNothing);
    expect(
      find.byKey(const ValueKey('dashboard_mood_bar_20260713_0905')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('dashboard_mood_bar_20260713_1530')),
      findsOneWidget,
    );
  });

  testWidgets('selects a previous day from the weekly selector', (
    tester,
  ) async {
    final today = DateTime(2026, 7, 13);
    final entries = [
      _entry(
        id: 1,
        moodScore: 5,
        note: 'Today entry.',
        createdAt: DateTime(2026, 7, 13, 9, 5),
      ),
      _entry(
        id: 2,
        moodScore: 2,
        note: 'Yesterday entry.',
        createdAt: DateTime(2026, 7, 12, 20, 10),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: DashboardScreen(
          entries: Stream.value(entries),
          today: today,
        ),
      ),
    );
    await tester.pump();

    expect(find.text("Today's check-in"), findsOneWidget);
    expect(find.text('09:05'), findsOneWidget);
    expect(find.textContaining('Today entry.'), findsOneWidget);
    expect(find.text('20:10'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('week_mood_day_20260712')));
    await tester.pumpAndSettle();

    expect(find.text("Yesterday's check-in"), findsOneWidget);
    expect(find.text('20:10'), findsOneWidget);
    expect(find.textContaining('Yesterday entry.'), findsOneWidget);
    expect(find.text('09:05'), findsNothing);
    expect(find.textContaining('Today entry.'), findsNothing);
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
    String? updatedPhotoRelativePath;
    String? updatedVoiceNotePath;
    List<int>? updatedActivityIds;
    List<int>? updatedSubEmotionIds;
    final now = DateTime.now();
    final entries = [
      _entry(
        id: 1,
        moodScore: 3,
        note: 'Steady afternoon.',
        createdAt: now,
        activityIds: const [1],
        activityNames: const ['Work'],
        subEmotionIds: const [7],
        subEmotionNames: const ['Neutral'],
        photoRelativePath: 'mood_photos/original.jpg',
        voiceNotePath: 'mood_voices/original.m4a',
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
            String? voiceNotePath,
            String? photoRelativePath,
            required List<int> activityIds,
            required List<int> subEmotionIds,
          }) async {
            updatedId = id;
            updatedScore = moodScore;
            updatedNote = note;
            updatedVoiceNotePath = voiceNotePath;
            updatedPhotoRelativePath = photoRelativePath;
            updatedActivityIds = activityIds;
            updatedSubEmotionIds = subEmotionIds;
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
    await tester.ensureVisible(
      find.byKey(const ValueKey('entry_detail_sub_emotion_7')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('entry_detail_sub_emotion_7')));
    await tester.ensureVisible(
      find.byKey(const ValueKey('entry_detail_remove_photo_button')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('entry_detail_remove_photo_button')),
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey('entry_detail_remove_voice_button')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('entry_detail_remove_voice_button')),
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey('entry_detail_save_button')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('entry_detail_save_button')));
    await tester.pumpAndSettle();

    expect(updatedId, 1);
    expect(updatedScore, 4);
    expect(updatedNote, 'Edited note');
    expect(updatedPhotoRelativePath, isNull);
    expect(updatedVoiceNotePath, isNull);
    expect(updatedActivityIds, [1]);
    expect(updatedSubEmotionIds, isEmpty);
  });

  testWidgets('entry detail sheet updates activities and sub-emotions', (
    tester,
  ) async {
    List<int>? updatedActivityIds;
    List<int>? updatedSubEmotionIds;
    final entry = _entry(
      id: 1,
      moodScore: 4,
      note: 'Good afternoon.',
      createdAt: DateTime.now(),
      activityIds: const [1],
      activityNames: const ['Work'],
      subEmotionIds: const [10],
      subEmotionNames: const ['Calm'],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EntryDetailSheet(
            entry: entry,
            activityOptions: Stream.value(const [
              MoodActivity(
                id: 1,
                name: 'Work',
                category: 'Life',
                isCustom: false,
              ),
              MoodActivity(
                id: 2,
                name: 'Sleep',
                category: 'Health',
                isCustom: false,
              ),
            ]),
            onUpdateEntry: ({
              required int id,
              required int moodScore,
              required String note,
              String? voiceNotePath,
              String? photoRelativePath,
              required List<int> activityIds,
              required List<int> subEmotionIds,
            }) async {
              updatedActivityIds = activityIds;
              updatedSubEmotionIds = subEmotionIds;
            },
            onDeleteEntry: (_) async {},
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('entry_detail_activity_1')));
    await tester.tap(find.byKey(const ValueKey('entry_detail_activity_2')));
    await tester.tap(find.byKey(const ValueKey('entry_detail_sub_emotion_10')));
    await tester.tap(find.byKey(const ValueKey('entry_detail_sub_emotion_11')));
    await tester.ensureVisible(
      find.byKey(const ValueKey('entry_detail_save_button')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('entry_detail_save_button')));
    await tester.pumpAndSettle();

    expect(updatedActivityIds, [2]);
    expect(updatedSubEmotionIds, [11]);
  });
}

MoodEntryModel _entry({
  required int id,
  required int moodScore,
  required String note,
  required DateTime createdAt,
  List<int> activityIds = const [],
  List<String> activityNames = const [],
  List<int> subEmotionIds = const [],
  List<String> subEmotionNames = const [],
  String? photoRelativePath,
  String? voiceNotePath,
}) {
  return MoodEntryModel(
    id: id,
    uuid: 'entry-$id',
    moodScore: moodScore,
    note: note,
    voiceNotePath: voiceNotePath,
    photoRelativePath: photoRelativePath,
    createdAt: createdAt,
    updatedAt: createdAt,
    activityIds: activityIds,
    activityNames: activityNames,
    subEmotionIds: subEmotionIds,
    subEmotionNames: subEmotionNames,
  );
}
