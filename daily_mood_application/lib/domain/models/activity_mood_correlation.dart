import 'package:equatable/equatable.dart';

final class ActivityMoodCorrelation extends Equatable {
  const ActivityMoodCorrelation({
    required this.activityId,
    required this.activityName,
    required this.entryCount,
    required this.averageMood,
  });

  final int activityId;
  final String activityName;
  final int entryCount;
  final double averageMood;

  @override
  List<Object?> get props => [
    activityId,
    activityName,
    entryCount,
    averageMood,
  ];
}
