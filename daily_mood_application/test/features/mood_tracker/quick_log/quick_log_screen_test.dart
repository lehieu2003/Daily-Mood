import 'package:daily_mood_application/core/database/app_database.dart';
import 'package:daily_mood_application/features/mood_tracker/cubit/mood_form_cubit.dart';
import 'package:daily_mood_application/features/mood_tracker/cubit/mood_form_state.dart';
import 'package:daily_mood_application/features/mood_tracker/quick_log/quick_log_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders quick-log controls and updates form state', (
    tester,
  ) async {
    final cubit = MoodFormCubit();
    MoodFormState? savedState;
    var donePressed = false;
    addTearDown(cubit.close);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: QuickLogScreen(
            activities: Stream.value([
              Activity(
                id: 1,
                uuid: 'activity-work',
                name: 'Work',
                category: 'Life',
                isCustom: false,
                isArchived: false,
                createdAt: DateTime(2026, 7, 9),
              ),
            ]),
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
    await tester.ensureVisible(find.byKey(const ValueKey('reason_1')).first);
    await tester.tap(find.byKey(const ValueKey('reason_1')).first);
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await tester.pump();

    expect(find.text('Any thing you want to add'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), 'Had a steady day.');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(cubit.state.selectedSubEmotionIds, contains(10));
    expect(cubit.state.selectedActivityIds, contains(1));
    expect(cubit.state.note, 'Had a steady day.');
    expect(savedState, isNotNull);
    expect(savedState!.moodScore, 4);
    expect(savedState!.selectedSubEmotionIds, contains(10));
    expect(savedState!.selectedActivityIds, contains(1));
    expect(savedState!.normalizedNote, 'Had a steady day.');
    expect(find.text("You're on a good way!"), findsOneWidget);

    await tester.tap(find.text('Got it'));
    await tester.pumpAndSettle();

    expect(donePressed, isTrue);
  });
}
