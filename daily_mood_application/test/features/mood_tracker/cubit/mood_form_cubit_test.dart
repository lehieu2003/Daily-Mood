import 'package:daily_mood_application/features/mood_tracker/cubit/mood_form_cubit.dart';
import 'package:daily_mood_application/features/mood_tracker/cubit/mood_form_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MoodFormState', () {
    test('starts empty and cannot submit without a mood score', () {
      final state = MoodFormState.initial();

      expect(state.moodScore, isNull);
      expect(state.selectedActivityIds, isEmpty);
      expect(state.selectedSubEmotionIds, isEmpty);
      expect(state.normalizedNote, isNull);
      expect(state.photoRelativePath, isNull);
      expect(state.voiceNoteRelativePath, isNull);
      expect(state.canSubmit, isFalse);
    });

    test('normalizes blank and non-blank notes', () {
      expect(MoodFormState(note: '   ').normalizedNote, isNull);
      expect(MoodFormState(note: '  Good day  ').normalizedNote, 'Good day');
    });
  });

  group('MoodFormCubit', () {
    test('sets a valid mood score', () {
      final cubit = MoodFormCubit();
      addTearDown(cubit.close);

      cubit.setMoodScore(4);

      expect(cubit.state.moodScore, 4);
      expect(cubit.state.canSubmit, isTrue);
    });

    test('rejects mood scores outside the 1 to 5 scale', () {
      final cubit = MoodFormCubit();
      addTearDown(cubit.close);

      expect(() => cubit.setMoodScore(0), throwsRangeError);
      expect(() => cubit.setMoodScore(6), throwsRangeError);
    });

    test('toggles activity and sub-emotion IDs independently', () {
      final cubit = MoodFormCubit();
      addTearDown(cubit.close);

      cubit
        ..toggleActivity(1)
        ..toggleActivity(2)
        ..toggleActivity(1)
        ..toggleSubEmotion(7)
        ..toggleSubEmotion(8);

      expect(cubit.state.selectedActivityIds, {2});
      expect(cubit.state.selectedSubEmotionIds, {7, 8});
    });

    test('rejects non-positive database IDs', () {
      final cubit = MoodFormCubit();
      addTearDown(cubit.close);

      expect(() => cubit.toggleActivity(0), throwsRangeError);
      expect(() => cubit.toggleSubEmotion(-1), throwsRangeError);
    });

    test('stores optional note, photo, and voice relative paths', () {
      final cubit = MoodFormCubit();
      addTearDown(cubit.close);

      cubit
        ..setNote('  private note  ')
        ..setPhotoRelativePath(' mood_photos/entry.jpg ')
        ..setVoiceNoteRelativePath('mood_voices/entry.m4a');

      expect(cubit.state.note, '  private note  ');
      expect(cubit.state.normalizedNote, 'private note');
      expect(cubit.state.photoRelativePath, 'mood_photos/entry.jpg');
      expect(cubit.state.voiceNoteRelativePath, 'mood_voices/entry.m4a');

      cubit
        ..clearPhoto()
        ..clearVoiceNote();

      expect(cubit.state.photoRelativePath, isNull);
      expect(cubit.state.voiceNoteRelativePath, isNull);
    });

    test('rejects empty and absolute media paths', () {
      final cubit = MoodFormCubit();
      addTearDown(cubit.close);

      expect(() => cubit.setPhotoRelativePath('   '), throwsArgumentError);
      expect(
        () => cubit.setPhotoRelativePath('/tmp/photo.jpg'),
        throwsArgumentError,
      );
      expect(
        () => cubit.setVoiceNoteRelativePath(r'C:\tmp\voice.m4a'),
        throwsArgumentError,
      );
    });

    test('resets the form to its initial state', () {
      final cubit = MoodFormCubit();
      addTearDown(cubit.close);

      cubit
        ..setMoodScore(5)
        ..toggleActivity(1)
        ..toggleSubEmotion(3)
        ..setNote('Done')
        ..setPhotoRelativePath('mood_photos/entry.jpg')
        ..setVoiceNoteRelativePath('mood_voices/entry.m4a')
        ..reset();

      expect(cubit.state, MoodFormState.initial());
    });
  });
}
