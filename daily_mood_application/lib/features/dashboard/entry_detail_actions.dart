typedef EntryUpdateAction = Future<void> Function({
  required int id,
  required int moodScore,
  required String note,
});

typedef EntryDeleteAction = Future<void> Function(int id);
