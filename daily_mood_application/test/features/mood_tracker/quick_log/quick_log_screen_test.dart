import 'package:daily_mood_application/domain/models/mood_activity.dart';
import 'package:daily_mood_application/features/mood_tracker/cubit/mood_form_cubit.dart';
import 'package:daily_mood_application/features/mood_tracker/cubit/mood_form_state.dart';
import 'package:daily_mood_application/features/mood_tracker/quick_log/quick_log_media_service.dart';
import 'package:daily_mood_application/features/mood_tracker/quick_log/quick_log_screen.dart';
import 'package:daily_mood_application/features/mood_tracker/quick_log/widgets/completion_dialog.dart';
import 'package:daily_mood_application/features/mood_tracker/quick_log/widgets/mood_step.dart';
import 'package:daily_mood_application/features/mood_tracker/quick_log/widgets/note_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders quick-log controls and updates form state', (
    tester,
  ) async {
    final cubit = MoodFormCubit();
    MoodFormState? savedState;
    var nextReasonId = 2;
    var donePressed = false;
    var isRecording = false;
    var moodHapticCount = 0;
    var saveHapticCount = 0;
    addTearDown(cubit.close);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: QuickLogScreen(
            activities: Stream.value([
              MoodActivity(
                id: 1,
                name: 'Work',
                category: 'Life',
                isCustom: false,
              ),
            ]),
            onCreateReason: (name) async => nextReasonId++,
            onPickPhoto: () async => 'mood_photos/test.jpg',
            onStartVoiceRecording: () async {
              isRecording = true;
              return true;
            },
            onStopVoiceRecording: () async {
              isRecording = false;
              return 'mood_voices/test.m4a';
            },
            onCancelVoiceRecording: () async {
              isRecording = false;
            },
            onSave: (state) async => savedState = state,
            onDone: () => donePressed = true,
            onMoodSelectedHaptic: () async => moodHapticCount++,
            onMoodSavedHaptic: () async => saveHapticCount++,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text("What's your mood now?"), findsOneWidget);
    expect(donePressed, isFalse);

    await tester.tap(find.byKey(const ValueKey('mood_option_4')));
    await tester.pump();

    expect(cubit.state.moodScore, 4);
    expect(moodHapticCount, 1);
    await tester.tap(find.text('Continue'));
    await tester.pump();

    expect(find.textContaining('Choose the emotions'), findsOneWidget);
    expect(find.text('Calm'), findsWidgets);
    expect(find.byType(Image), findsWidgets);

    await tester.ensureVisible(
      find.byKey(const ValueKey('sub_emotion_10')).first,
    );
    await tester.tap(find.byKey(const ValueKey('sub_emotion_10')).first);
    await tester.pump();
    expect(moodHapticCount, 1);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.textContaining("What's reason"), findsOneWidget);
    expect(find.text('Work'), findsWidgets);
    expect(
      find.byKey(const ValueKey('quick_log_reason_search_field')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('quick_log_add_reason_field')),
      findsNothing,
    );

    await tester.tap(find.byKey(const ValueKey('quick_log_more_reason')).first);
    await tester.pump();
    expect(
      find.byKey(const ValueKey('quick_log_add_reason_field')),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const ValueKey('quick_log_more_reason')).first);
    await tester.pump();
    expect(
      find.byKey(const ValueKey('quick_log_add_reason_field')),
      findsNothing,
    );

    await tester.tap(find.byKey(const ValueKey('quick_log_more_reason')).first);
    await tester.pump();
    expect(
      find.byKey(const ValueKey('quick_log_add_reason_field')),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(const ValueKey('quick_log_add_reason_field')),
      'Reading',
    );
    await tester.tap(find.byKey(const ValueKey('quick_log_confirm_reason')));
    await tester.pump();
    expect(cubit.state.selectedActivityIds, contains(2));
    expect(
      find.byKey(const ValueKey('quick_log_add_reason_field')),
      findsNothing,
    );

    await tester.ensureVisible(find.byKey(const ValueKey('reason_1')).first);
    await tester.tap(find.byKey(const ValueKey('reason_1')).first);
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await tester.pump();

    expect(find.text('Any thing you want to add'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('quick_log_attach_photo')));
    await tester.pump();
    await tester.enterText(find.byType(TextFormField), 'Had a steady day.');
    await tester.tap(find.byKey(const ValueKey('quick_log_record_voice')));
    await tester.pump();
    expect(isRecording, isTrue);
    expect(find.text('Stop voice'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('quick_log_record_voice')));
    await tester.pump();
    expect(isRecording, isFalse);
    expect(cubit.state.note, 'Had a steady day.');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(cubit.state.selectedSubEmotionIds, contains(10));
    expect(cubit.state.selectedActivityIds, contains(1));
    expect(cubit.state.selectedActivityIds, contains(2));
    expect(cubit.state.photoRelativePath, 'mood_photos/test.jpg');
    expect(cubit.state.voiceNoteRelativePath, 'mood_voices/test.m4a');
    expect(cubit.state.note, 'Had a steady day.');
    expect(savedState, isNotNull);
    expect(savedState!.moodScore, 4);
    expect(savedState!.selectedSubEmotionIds, contains(10));
    expect(savedState!.selectedActivityIds, contains(1));
    expect(savedState!.selectedActivityIds, contains(2));
    expect(savedState!.photoRelativePath, 'mood_photos/test.jpg');
    expect(savedState!.voiceNoteRelativePath, 'mood_voices/test.m4a');
    expect(savedState!.normalizedNote, 'Had a steady day.');
    expect(saveHapticCount, 1);
    expect(
      find.byKey(const ValueKey('quick_log_save_confirmation')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('quick_log_save_confirmation_ring')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('quick_log_save_confirmation_check')),
      findsOneWidget,
    );
    expect(find.text("You're on a good way!"), findsOneWidget);

    await tester.tap(find.text('Got it'));
    await tester.pumpAndSettle();

    expect(donePressed, isTrue);
  });

  testWidgets('mood selection feedback keeps option slots stable', (
    tester,
  ) async {
    final cubit = MoodFormCubit();
    var moodHapticCount = 0;
    addTearDown(cubit.close);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 390,
              child: BlocProvider.value(
                value: cubit,
                child: BlocBuilder<MoodFormCubit, MoodFormState>(
                  builder: (context, state) {
                    return MoodStep(
                      selectedMoodScore: state.moodScore,
                      onMoodSelectedHaptic: () async => moodHapticCount++,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final optionFinders = [
      for (var score = 1; score <= 5; score++)
        find.byKey(ValueKey('mood_option_$score')),
    ];
    for (final finder in optionFinders) {
      expect(tester.getSize(finder), const Size.square(72));
    }

    await tester.tap(find.byKey(const ValueKey('mood_option_4')));
    await tester.pumpAndSettle();

    for (final finder in optionFinders) {
      expect(tester.getSize(finder), const Size.square(72));
    }
    expect(cubit.state.moodScore, 4);
    expect(moodHapticCount, 1);
    expect(
      tester
          .widget<Semantics>(find.byKey(const ValueKey('mood_option_4')))
          .properties
          .selected,
      isTrue,
    );

    await tester.tap(find.byKey(const ValueKey('mood_option_2')));
    await tester.pumpAndSettle();

    expect(cubit.state.moodScore, 2);
    expect(moodHapticCount, 2);
    expect(
      tester
          .widget<Semantics>(find.byKey(const ValueKey('mood_option_4')))
          .properties
          .selected,
      isFalse,
    );
    expect(
      tester
          .widget<Semantics>(find.byKey(const ValueKey('mood_option_2')))
          .properties
          .selected,
      isTrue,
    );
  });

  testWidgets('mood selection feedback adapts to narrow widths', (
    tester,
  ) async {
    final cubit = MoodFormCubit();
    addTearDown(cubit.close);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 260,
              child: BlocProvider.value(
                value: cubit,
                child: BlocBuilder<MoodFormCubit, MoodFormState>(
                  builder: (context, state) {
                    return MoodStep(selectedMoodScore: state.moodScore);
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );

    for (var score = 1; score <= 5; score++) {
      expect(
        tester.getSize(find.byKey(ValueKey('mood_option_$score'))),
        const Size.square(52),
      );
    }

    await tester.tap(find.byKey(const ValueKey('mood_option_5')));
    await tester.pumpAndSettle();

    for (var score = 1; score <= 5; score++) {
      expect(
        tester.getSize(find.byKey(ValueKey('mood_option_$score'))),
        const Size.square(52),
      );
    }
    expect(cubit.state.moodScore, 5);
  });

  testWidgets('completion dialog copy changes with low mood', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: QuickLogCompletionDialog(moodScore: 1, onDismissed: () {}),
      ),
    );

    expect(find.text('That sounds really hard.'), findsOneWidget);
    expect(find.text('Thank you for\nchecking in'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('quick_log_save_confirmation')),
      findsOneWidget,
    );
    expect(find.text('Your day is going\namazing'), findsNothing);
  });

  testWidgets('uses dark surfaces when app is in dark mode', (tester) async {
    final cubit = MoodFormCubit();
    addTearDown(cubit.close);

    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light(),
        darkTheme: darkTheme,
        themeMode: ThemeMode.dark,
        home: BlocProvider.value(
          value: cubit,
          child: QuickLogScreen(
            activities: const Stream<List<MoodActivity>>.empty(),
            onCreateReason: (_) async => 1,
            onPickPhoto: () async => null,
            onStartVoiceRecording: () async => false,
            onStopVoiceRecording: () async => null,
            onCancelVoiceRecording: () async {},
            onSave: (_) async {},
          ),
        ),
      ),
    );

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, darkTheme.colorScheme.surface);
  });

  testWidgets('shows a warning when picked photo is too large', (tester) async {
    final cubit = MoodFormCubit();
    addTearDown(cubit.close);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider.value(
            value: cubit,
            child: NoteStep(
              state: cubit.state,
              onPickPhoto: () async {
                throw const QuickLogPhotoException(QuickLogPhotoError.tooLarge);
              },
              onStartVoiceRecording: () async => false,
              onStopVoiceRecording: () async => null,
              onCancelVoiceRecording: () async {},
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('quick_log_attach_photo')));
    await tester.pump();

    expect(find.text('Choose a smaller photo.'), findsOneWidget);
    expect(cubit.state.photoRelativePath, isNull);
  });

  testWidgets('re-enables voice button after recorder start failure', (
    tester,
  ) async {
    final cubit = MoodFormCubit();
    var startAttempts = 0;
    addTearDown(cubit.close);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider.value(
            value: cubit,
            child: NoteStep(
              state: cubit.state,
              onPickPhoto: () async => null,
              onStartVoiceRecording: () async {
                startAttempts++;
                if (startAttempts == 1) {
                  throw Exception('recorder failed');
                }
                return false;
              },
              onStopVoiceRecording: () async => null,
              onCancelVoiceRecording: () async {},
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('quick_log_record_voice')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('quick_log_record_voice')));
    await tester.pump();

    expect(startAttempts, 2);
    expect(find.text('Microphone permission is required.'), findsWidgets);
  });
}
