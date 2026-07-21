import 'package:daily_mood_application/domain/models/daily_reflection.dart';
import 'package:daily_mood_application/domain/models/mood_activity.dart';
import 'package:daily_mood_application/domain/models/mood_entry.dart';
import 'package:daily_mood_application/features/dashboard/daily_challenge.dart';
import 'package:daily_mood_application/features/dashboard/dashboard_palette.dart';
import 'package:daily_mood_application/features/dashboard/dashboard_screen.dart';
import 'package:daily_mood_application/features/dashboard/mood_garden.dart';
import 'package:daily_mood_application/features/dashboard/widgets/daily_challenge_card.dart';
import 'package:daily_mood_application/features/dashboard/widgets/entry_detail_sheet.dart';
import 'package:daily_mood_application/features/dashboard/widgets/mood_garden_card.dart';
import 'package:daily_mood_application/features/settings/data/settings_preferences_repository.dart';
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
      _entry(id: 1, moodScore: 5, note: 'Bright start.', createdAt: today),
      _entry(
        id: 2,
        moodScore: 2,
        note: 'Hard weekend.',
        createdAt: today.subtract(const Duration(days: 2)),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: DashboardScreen(entries: Stream.value(entries), today: today),
      ),
    );
    await tester.pump();

    expect(
      find.byKey(const ValueKey('week_mood_day_20260707')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('week_mood_day_20260713')),
      findsOneWidget,
    );
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
        home: DashboardScreen(entries: Stream.value(entries), today: today),
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
        home: DashboardScreen(entries: Stream.value(entries), today: today),
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
      _entry(id: 1, moodScore: 5, note: 'Strong morning.', createdAt: now),
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

    expect(
      find.byKey(const ValueKey('weekly_trend_entry_card')),
      findsOneWidget,
    );
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

  testWidgets('shows neutral on this day memories with media indicators', (
    tester,
  ) async {
    final today = DateTime(2026, 7, 20, 10);
    final memories = [
      _entry(
        id: 10,
        moodScore: 2,
        note: 'A difficult day that should be worded neutrally.',
        createdAt: DateTime(2025, 7, 20, 8, 30),
        photoRelativePath: 'mood_photos/memory.jpg',
        voiceNotePath: 'mood_voices/memory.m4a',
      ),
    ];
    final currentEntries = [
      _entry(id: 1, moodScore: 4, note: 'Today entry.', createdAt: today),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: DashboardScreen(
          entries: Stream.value(currentEntries),
          today: today,
          onThisDayEntries: Stream.value(memories),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.byKey(const ValueKey('on_this_day_card')), findsOneWidget);
    expect(find.text('On this day'), findsOneWidget);
    expect(find.text('A memory from this day'), findsOneWidget);
    expect(find.text('Jul 20, 2025'), findsOneWidget);
    expect(
      find.textContaining('A difficult day that should be worded neutrally.'),
      findsOneWidget,
    );
    expect(find.text('Photo attached'), findsOneWidget);
    expect(find.text('Voice attached'), findsOneWidget);
  });

  testWidgets('shows optional daily challenge and marks it complete', (
    tester,
  ) async {
    final store = InMemorySettingsPreferencesStore();
    final preferencesRepository = SettingsPreferencesRepository(store: store);
    final challengeRepository = DailyChallengeRepository(
      repository: preferencesRepository,
    );
    final today = DateTime(2026, 7, 20, 10);
    final entries = [
      _entry(id: 1, moodScore: 4, note: 'Today entry.', createdAt: today),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: DashboardScreen(
          entries: Stream.value(entries),
          today: today,
          dailyChallengeRepository: challengeRepository,
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.byKey(const ValueKey('daily_challenge_card')), findsOneWidget);
    expect(find.text('Daily challenge'), findsOneWidget);
    expect(find.text('Breathe slowly for one minute'), findsOneWidget);
    expect(
      find.text('Optional and local. It never blocks mood logging.'),
      findsOneWidget,
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey('daily_challenge_complete_button')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('daily_challenge_complete_button')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Done today'), findsOneWidget);
    expect(find.text('Marked complete for today.'), findsOneWidget);
    expect(await challengeRepository.isCompleted(today), isTrue);
  });

  testWidgets('daily challenge card renders in light and dark themes', (
    tester,
  ) async {
    addTearDown(
      () => DashboardPalette.resolve(
        themeMode: ThemeMode.light,
        platformBrightness: Brightness.light,
      ),
    );

    for (final mode in [ThemeMode.light, ThemeMode.dark]) {
      DashboardPalette.resolve(
        themeMode: mode,
        platformBrightness: mode == ThemeMode.dark
            ? Brightness.dark
            : Brightness.light,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: mode,
          home: Scaffold(
            body: DailyChallengeCard(
              challenge: const DailyChallenge(id: DailyChallengeId.shortWalk),
              completed: mode == ThemeMode.dark,
              onComplete: () {},
            ),
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(
        find.byKey(const ValueKey('daily_challenge_card')),
        findsOneWidget,
      );
      expect(find.text('Daily challenge'), findsOneWidget);
    }
  });

  testWidgets('daily challenge completion feedback plays once', (tester) async {
    var completed = false;

    Widget buildCard() {
      return MaterialApp(
        home: Scaffold(
          body: DailyChallengeCard(
            challenge: const DailyChallenge(id: DailyChallengeId.shortWalk),
            completed: completed,
            onComplete: () {
              completed = true;
            },
          ),
        ),
      );
    }

    await tester.pumpWidget(buildCard());
    await tester.pump();

    expect(
      tester
          .widget<Opacity>(
            find.byKey(const ValueKey('daily_challenge_completion_feedback')),
          )
          .opacity,
      0,
    );

    await tester.tap(
      find.byKey(const ValueKey('daily_challenge_complete_button')),
    );
    await tester.pumpWidget(buildCard());
    await tester.pump(const Duration(milliseconds: 120));

    expect(find.text('Done today'), findsOneWidget);
    expect(find.text('Marked complete for today.'), findsOneWidget);
    expect(
      tester
          .widget<Opacity>(
            find.byKey(const ValueKey('daily_challenge_completion_feedback')),
          )
          .opacity,
      greaterThan(0),
    );

    await tester.pumpAndSettle();
    completed = false;
    await tester.pumpWidget(buildCard());
    await tester.pumpAndSettle();
    completed = true;
    await tester.pumpWidget(buildCard());
    await tester.pump(const Duration(milliseconds: 120));

    expect(
      tester
          .widget<Opacity>(
            find.byKey(const ValueKey('daily_challenge_completion_feedback')),
          )
          .opacity,
      0,
    );
  });

  testWidgets('retention cards fit a small phone viewport', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final challengeRepository = DailyChallengeRepository(
      repository: SettingsPreferencesRepository(
        store: InMemorySettingsPreferencesStore(),
      ),
    );
    final today = DateTime(2026, 7, 20, 10);
    final entries = [
      _entry(
        id: 1,
        moodScore: 4,
        note: 'Today entry.',
        createdAt: today,
        activityIds: const [1],
        activityNames: const ['Work'],
        subEmotionIds: const [10],
        subEmotionNames: const ['Calm'],
      ),
      _entry(
        id: 2,
        moodScore: 3,
        note: 'Yesterday entry.',
        createdAt: DateTime(2026, 7, 19, 9),
      ),
      _entry(
        id: 3,
        moodScore: 5,
        note: 'Earlier entry.',
        createdAt: DateTime(2026, 7, 18, 9),
      ),
    ];
    final memories = [
      _entry(
        id: 10,
        moodScore: 2,
        note: 'A prior-year memory.',
        createdAt: DateTime(2025, 7, 20, 8),
      ),
    ];
    final reflections = [
      _reflection(id: 1, date: today),
      _reflection(id: 2, date: DateTime(2026, 7, 19)),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: DashboardScreen(
          entries: Stream.value(entries),
          today: today,
          dailyReflections: Stream.value(reflections),
          onThisDayEntries: Stream.value(memories),
          dailyChallengeRepository: challengeRepository,
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byKey(const ValueKey('daily_challenge_card')), findsOneWidget);
    expect(find.byKey(const ValueKey('mood_garden_card')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('weekly_reflection_report_card')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('on_this_day_card')), findsOneWidget);
  });

  testWidgets('shows non-punitive reflection streak from local entries', (
    tester,
  ) async {
    final today = DateTime(2026, 7, 17, 10);
    final entries = [
      _entry(
        id: 1,
        moodScore: 4,
        note: 'Yesterday reflection.',
        createdAt: DateTime(2026, 7, 16, 20),
      ),
      _entry(
        id: 2,
        moodScore: 3,
        note: 'Two days ago.',
        createdAt: DateTime(2026, 7, 15, 21),
      ),
      _entry(
        id: 3,
        moodScore: 5,
        note: 'Older break.',
        createdAt: DateTime(2026, 7, 13, 9),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: DashboardScreen(entries: Stream.value(entries), today: today),
      ),
    );
    await tester.pump();

    expect(
      find.byKey(const ValueKey('reflection_streak_card')),
      findsOneWidget,
    );
    expect(find.text('Reflection streak'), findsOneWidget);
    expect(find.text('2 day rhythm'), findsOneWidget);
    expect(find.text('Private and pressure-free'), findsOneWidget);
  });

  testWidgets('shows mood garden growth from entries and reflections', (
    tester,
  ) async {
    final today = DateTime(2026, 7, 18, 10);
    final entries = [
      _entry(
        id: 1,
        moodScore: 4,
        note: 'Today.',
        createdAt: DateTime(2026, 7, 18, 9),
        activityIds: const [1],
        activityNames: const ['Work'],
        subEmotionIds: const [10],
        subEmotionNames: const ['Calm'],
      ),
      _entry(
        id: 2,
        moodScore: 3,
        note: 'Yesterday.',
        createdAt: DateTime(2026, 7, 17, 9),
        activityIds: const [1],
        activityNames: const ['Work'],
        subEmotionIds: const [7],
        subEmotionNames: const ['Neutral'],
      ),
    ];
    final reflections = [
      _reflection(id: 1, date: DateTime(2026, 7, 18)),
      _reflection(id: 2, date: DateTime(2026, 7, 16)),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: DashboardScreen(
          entries: Stream.value(entries),
          today: today,
          dailyReflections: Stream.value(reflections),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.byKey(const ValueKey('mood_garden_card')), findsOneWidget);
    expect(find.text('Mood garden'), findsOneWidget);
    expect(find.text('Leafy'), findsOneWidget);
    expect(find.text('2 mood days - 2 reflections'), findsOneWidget);
    expect(find.text('3 recent care days'), findsOneWidget);
    expect(find.text('Missed days never reset it'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('weekly_reflection_report_card')),
      findsOneWidget,
    );
    expect(find.text('Weekly report'), findsOneWidget);
    expect(find.text('Jul 13 - Jul 19'), findsOneWidget);
    expect(
      find.text('You paired check-ins with reflections this week.'),
      findsOneWidget,
    );
    expect(find.text('Average mood: 3.5'), findsOneWidget);
    expect(find.text('Top reason: Work'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey('mood_garden_progression_button')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('mood_garden_progression_button')),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('mood_garden_progression_sheet')),
      findsOneWidget,
    );
    expect(find.text('Garden journey'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('mood_garden_stage_leafy')),
      findsOneWidget,
    );
    expect(find.text('Current stage'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('mood_garden_stage_bloom_lock')),
      findsOneWidget,
    );
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('mood_garden_stage_flourishing_lock')),
      120,
      scrollable: find.descendant(
        of: find.byKey(const ValueKey('mood_garden_progression_sheet')),
        matching: find.byType(Scrollable),
      ),
    );
    expect(
      find.byKey(const ValueKey('mood_garden_stage_flourishing_lock')),
      findsOneWidget,
    );
  });

  testWidgets('mood garden shows growth moment after points increase', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MoodGardenCard(summary: _gardenSummary(growthPoints: 0)),
        ),
      ),
    );
    await tester.pump();

    expect(find.byKey(const ValueKey('mood_garden_card')), findsOneWidget);
    expect(
      tester
          .widget<Opacity>(
            find.byKey(const ValueKey('mood_garden_growth_moment')),
          )
          .opacity,
      0,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MoodGardenCard(summary: _gardenSummary(growthPoints: 1)),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 120));

    expect(
      tester
          .widget<Opacity>(
            find.byKey(const ValueKey('mood_garden_growth_moment')),
          )
          .opacity,
      greaterThan(0),
    );
    expect(
      find.byKey(const ValueKey('mood_garden_growth_visual')),
      findsOneWidget,
    );
  });

  testWidgets('saves an optional daily reflection after a logged mood', (
    tester,
  ) async {
    DateTime? savedDate;
    String? savedPrompt;
    String? savedResponse;
    final today = DateTime(2026, 7, 18, 10);
    final entries = [
      _entry(
        id: 1,
        moodScore: 4,
        note: 'Calm morning.',
        createdAt: DateTime(2026, 7, 18, 9),
        activityIds: const [1],
        activityNames: const ['Work'],
        subEmotionIds: const [10],
        subEmotionNames: const ['Calm'],
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: DashboardScreen(
          entries: Stream.value(entries),
          today: today,
          dailyReflectionForDate: (_) => Stream.value(null),
          onSaveReflection:
              ({
                required DateTime date,
                required String prompt,
                required String response,
              }) async {
                savedDate = date;
                savedPrompt = prompt;
                savedResponse = response;
              },
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Daily reflection'), findsOneWidget);
    expect(find.text('Today: Good'), findsOneWidget);
    expect(find.text('Emotion: Calm'), findsOneWidget);
    expect(find.text('Reason: Work'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey('daily_reflection_field')),
    );
    await tester.enterText(
      find.byKey(const ValueKey('daily_reflection_field')),
      '  A focused block helped.  ',
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey('daily_reflection_save_button')),
    );
    await tester.tap(
      find.byKey(const ValueKey('daily_reflection_save_button')),
    );
    await tester.pump();

    expect(savedDate, DateTime(2026, 7, 18));
    expect(savedPrompt, 'What made today better?');
    expect(savedResponse, 'A focused block helped.');
  });

  testWidgets('shows an existing daily reflection for editing', (tester) async {
    final today = DateTime(2026, 7, 18, 10);
    final entries = [
      _entry(id: 1, moodScore: 5, note: 'Good day.', createdAt: today),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: DashboardScreen(
          entries: Stream.value(entries),
          today: today,
          dailyReflectionForDate: (_) => Stream.value(
            DailyReflectionModel(
              id: 1,
              uuid: 'reflection-1',
              date: DateTime(2026, 7, 18),
              prompt: 'What made today better?',
              response: 'Dinner with friends.',
              createdAt: DateTime(2026, 7, 18, 20),
              updatedAt: DateTime(2026, 7, 18, 20),
            ),
          ),
          onSaveReflection:
              ({
                required DateTime date,
                required String prompt,
                required String response,
              }) async {},
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Update reflection'), findsOneWidget);
    expect(find.text('Dinner with friends.'), findsOneWidget);
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
          onUpdateEntry:
              ({
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
            onUpdateEntry:
                ({
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

MoodGardenSummary _gardenSummary({required int growthPoints}) {
  final stage = growthPoints == 0
      ? MoodGardenStage.seed
      : MoodGardenStage.sprout;
  return MoodGardenSummary(
    stage: stage,
    growthPoints: growthPoints,
    pointsForNextStage: growthPoints == 0 ? 1 : 4,
    activeDayCount: growthPoints,
    reflectionCount: 0,
    recentActiveDays: growthPoints,
  );
}

DailyReflectionModel _reflection({required int id, required DateTime date}) {
  return DailyReflectionModel(
    id: id,
    uuid: 'reflection-$id',
    date: date,
    prompt: 'What made today better?',
    response: 'A quiet moment.',
    createdAt: date,
    updatedAt: date,
  );
}
