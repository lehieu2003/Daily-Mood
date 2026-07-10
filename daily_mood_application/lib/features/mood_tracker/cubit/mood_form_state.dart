import 'package:equatable/equatable.dart';

const int minMoodScore = 1;
const int maxMoodScore = 5;

final class MoodFormState extends Equatable {
  MoodFormState({
    this.moodScore,
    Set<int> selectedActivityIds = const {},
    Set<int> selectedSubEmotionIds = const {},
    this.note = '',
    this.photoRelativePath,
    this.voiceNoteRelativePath,
  }) : selectedActivityIds = Set.unmodifiable(selectedActivityIds),
       selectedSubEmotionIds = Set.unmodifiable(selectedSubEmotionIds);

  factory MoodFormState.initial() => MoodFormState();

  final int? moodScore;
  final Set<int> selectedActivityIds;
  final Set<int> selectedSubEmotionIds;
  final String note;
  final String? photoRelativePath;
  final String? voiceNoteRelativePath;

  bool get hasMoodScore => moodScore != null;
  bool get canSubmit => hasMoodScore;
  String? get normalizedNote {
    final trimmed = note.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  bool get hasPhoto => photoRelativePath != null;
  bool get hasVoiceNote => voiceNoteRelativePath != null;

  MoodFormState copyWith({
    int? moodScore,
    Set<int>? selectedActivityIds,
    Set<int>? selectedSubEmotionIds,
    String? note,
    Object? photoRelativePath = _unchanged,
    Object? voiceNoteRelativePath = _unchanged,
  }) {
    return MoodFormState(
      moodScore: moodScore ?? this.moodScore,
      selectedActivityIds: selectedActivityIds ?? this.selectedActivityIds,
      selectedSubEmotionIds:
          selectedSubEmotionIds ?? this.selectedSubEmotionIds,
      note: note ?? this.note,
      photoRelativePath: photoRelativePath == _unchanged
          ? this.photoRelativePath
          : photoRelativePath as String?,
      voiceNoteRelativePath: voiceNoteRelativePath == _unchanged
          ? this.voiceNoteRelativePath
          : voiceNoteRelativePath as String?,
    );
  }

  static bool isValidMoodScore(int moodScore) {
    return moodScore >= minMoodScore && moodScore <= maxMoodScore;
  }

  List<int> get _activityIdsForEquality {
    return selectedActivityIds.toList()..sort();
  }

  List<int> get _subEmotionIdsForEquality {
    return selectedSubEmotionIds.toList()..sort();
  }

  @override
  List<Object?> get props => [
    moodScore,
    _activityIdsForEquality,
    _subEmotionIdsForEquality,
    note,
    photoRelativePath,
    voiceNoteRelativePath,
  ];
}

const Object _unchanged = Object();
