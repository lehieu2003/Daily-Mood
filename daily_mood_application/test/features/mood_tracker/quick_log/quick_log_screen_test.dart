import 'package:daily_mood_application/domain/models/mood_activity.dart';
import 'package:daily_mood_application/features/mood_tracker/cubit/mood_form_cubit.dart';
import 'package:daily_mood_application/features/mood_tracker/cubit/mood_form_state.dart';
import 'package:daily_mood_application/features/mood_tracker/quick_log/quick_log_screen.dart';
import 'package:daily_mood_application/features/mood_tracker/quick_log/widgets/completion_dialog.dart';
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
            onTranscribeVoice: () async => 'Voice generated note.',
            onSave: (state) async => savedState = state,
            onDone: () => donePressed = true,
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
    await tester.tap(find.byKey(const ValueKey('quick_log_transcribe_voice')));
    await tester.pump();
    expect(cubit.state.note, 'Had a steady day. Voice generated note.');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(cubit.state.selectedSubEmotionIds, contains(10));
    expect(cubit.state.selectedActivityIds, contains(1));
    expect(cubit.state.selectedActivityIds, contains(2));
    expect(cubit.state.photoRelativePath, 'mood_photos/test.jpg');
    expect(cubit.state.voiceNoteRelativePath, isNull);
    expect(cubit.state.note, 'Had a steady day. Voice generated note.');
    expect(savedState, isNotNull);
    expect(savedState!.moodScore, 4);
    expect(savedState!.selectedSubEmotionIds, contains(10));
    expect(savedState!.selectedActivityIds, contains(1));
    expect(savedState!.selectedActivityIds, contains(2));
    expect(savedState!.photoRelativePath, 'mood_photos/test.jpg');
    expect(savedState!.voiceNoteRelativePath, isNull);
    expect(
      savedState!.normalizedNote,
      'Had a steady day. Voice generated note.',
    );
    expect(find.text("You're on a good way!"), findsOneWidget);

    await tester.tap(find.text('Got it'));
    await tester.pumpAndSettle();

    expect(donePressed, isTrue);
  });

  testWidgets('completion dialog copy changes with low mood', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: QuickLogCompletionDialog(moodScore: 1, onDismissed: () {}),
      ),
    );

    expect(find.text('That sounds really hard.'), findsOneWidget);
    expect(find.text('Thank you for\nchecking in'), findsOneWidget);
    expect(find.text('Your day is going\namazing'), findsNothing);
  });
}
