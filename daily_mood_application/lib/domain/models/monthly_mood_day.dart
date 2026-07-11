import 'package:equatable/equatable.dart';

final class MonthlyMoodDay extends Equatable {
  const MonthlyMoodDay({
    required this.date,
    required this.averageMood,
    required this.entryCount,
  });

  final DateTime date;
  final double? averageMood;
  final int entryCount;

  bool get hasEntries => entryCount > 0;

  @override
  List<Object?> get props => [date, averageMood, entryCount];
}
