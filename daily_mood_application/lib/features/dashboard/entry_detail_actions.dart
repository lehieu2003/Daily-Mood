typedef EntryUpdateAction = Future<void> Function({
  required int id,
  required int moodScore,
  required String note,
  String? voiceNotePath,
  String? photoRelativePath,
  required List<int> activityIds,
  required List<int> subEmotionIds,
});

typedef EntryDeleteAction = Future<void> Function(int id);
