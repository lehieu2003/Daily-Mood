import '../../domain/models/mood_entry.dart';

int currentReflectionStreak(
  List<MoodEntryModel> entries, {
  required DateTime today,
}) {
  if (entries.isEmpty) return 0;

  final entryDates = entries
      .map((entry) => _dateOnly(entry.createdAt))
      .toSet();
  final todayOnly = _dateOnly(today);
  var cursor = entryDates.contains(todayOnly)
      ? todayOnly
      : todayOnly.subtract(const Duration(days: 1));
  var count = 0;

  while (entryDates.contains(cursor)) {
    count++;
    cursor = cursor.subtract(const Duration(days: 1));
  }

  return count;
}

DateTime _dateOnly(DateTime date) {
  final local = date.toLocal();
  return DateTime(local.year, local.month, local.day);
}
