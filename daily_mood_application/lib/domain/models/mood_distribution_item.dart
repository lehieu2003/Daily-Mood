import 'package:equatable/equatable.dart';

final class MoodDistributionItem extends Equatable {
  const MoodDistributionItem({
    required this.moodScore,
    required this.entryCount,
    required this.totalCount,
  });

  final int moodScore;
  final int entryCount;
  final int totalCount;

  double get percentage {
    if (totalCount == 0) return 0;
    return entryCount / totalCount;
  }

  @override
  List<Object?> get props => [moodScore, entryCount, totalCount];
}
