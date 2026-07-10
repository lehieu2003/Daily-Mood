import 'package:flutter_bloc/flutter_bloc.dart';

import 'mood_form_state.dart';

final class MoodFormCubit extends Cubit<MoodFormState> {
  MoodFormCubit() : super(MoodFormState.initial());

  void setMoodScore(int moodScore) {
    if (!MoodFormState.isValidMoodScore(moodScore)) {
      throw RangeError.range(
        moodScore,
        minMoodScore,
        maxMoodScore,
        'moodScore',
      );
    }

    emit(state.copyWith(moodScore: moodScore));
  }

  void toggleActivity(int activityId) {
    _checkPositiveId(activityId, 'activityId');

    final next = {...state.selectedActivityIds};
    if (!next.add(activityId)) {
      next.remove(activityId);
    }

    emit(state.copyWith(selectedActivityIds: next));
  }

  void clearActivities() {
    emit(state.copyWith(selectedActivityIds: const {}));
  }

  void toggleSubEmotion(int subEmotionId) {
    _checkPositiveId(subEmotionId, 'subEmotionId');

    final next = {...state.selectedSubEmotionIds};
    if (!next.add(subEmotionId)) {
      next.remove(subEmotionId);
    }

    emit(state.copyWith(selectedSubEmotionIds: next));
  }

  void clearSubEmotions() {
    emit(state.copyWith(selectedSubEmotionIds: const {}));
  }

  void setNote(String note) {
    emit(state.copyWith(note: note));
  }

  void setPhotoRelativePath(String relativePath) {
    emit(
      state.copyWith(photoRelativePath: _normalizeRelativePath(relativePath)),
    );
  }

  void clearPhoto() {
    emit(state.copyWith(photoRelativePath: null));
  }

  void setVoiceNoteRelativePath(String relativePath) {
    emit(
      state.copyWith(
        voiceNoteRelativePath: _normalizeRelativePath(relativePath),
      ),
    );
  }

  void clearVoiceNote() {
    emit(state.copyWith(voiceNoteRelativePath: null));
  }

  void reset() {
    emit(MoodFormState.initial());
  }

  void _checkPositiveId(int id, String name) {
    if (id <= 0) {
      throw RangeError.range(id, 1, null, name);
    }
  }

  String _normalizeRelativePath(String relativePath) {
    final trimmed = relativePath.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(
        relativePath,
        'relativePath',
        'Cannot be empty',
      );
    }
    if (trimmed.startsWith('/') ||
        RegExp(r'^[A-Za-z]:[\\/]').hasMatch(trimmed)) {
      throw ArgumentError.value(
        relativePath,
        'relativePath',
        'Must be relative to the app storage directory',
      );
    }

    return trimmed;
  }
}
