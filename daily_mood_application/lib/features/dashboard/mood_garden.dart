import '../../domain/models/daily_reflection.dart';
import '../../domain/models/mood_entry.dart';

enum MoodGardenStage { seed, sprout, leafy, bloom, flourishing }

const moodGardenStages = [
  MoodGardenStage.seed,
  MoodGardenStage.sprout,
  MoodGardenStage.leafy,
  MoodGardenStage.bloom,
  MoodGardenStage.flourishing,
];

final class MoodGardenStageProgress {
  const MoodGardenStageProgress({
    required this.stage,
    required this.requiredPoints,
    required this.isUnlocked,
    required this.isCurrent,
  });

  final MoodGardenStage stage;
  final int requiredPoints;
  final bool isUnlocked;
  final bool isCurrent;
}

final class MoodGardenSummary {
  const MoodGardenSummary({
    required this.stage,
    required this.growthPoints,
    required this.pointsForNextStage,
    required this.activeDayCount,
    required this.reflectionCount,
    required this.recentActiveDays,
  });

  final MoodGardenStage stage;
  final int growthPoints;
  final int pointsForNextStage;
  final int activeDayCount;
  final int reflectionCount;
  final int recentActiveDays;

  double get progressToNextStage {
    if (pointsForNextStage <= growthPoints) return 1;
    final currentThreshold = moodGardenThresholdFor(stage);
    final span = pointsForNextStage - currentThreshold;
    if (span <= 0) return 1;
    return ((growthPoints - currentThreshold) / span).clamp(0, 1).toDouble();
  }

  List<MoodGardenStageProgress> get stageProgression {
    return moodGardenStages
        .map(
          (stage) => MoodGardenStageProgress(
            stage: stage,
            requiredPoints: moodGardenThresholdFor(stage),
            isUnlocked: growthPoints >= moodGardenThresholdFor(stage),
            isCurrent: stage == this.stage,
          ),
        )
        .toList(growable: false);
  }
}

MoodGardenSummary buildMoodGardenSummary({
  required List<MoodEntryModel> entries,
  required List<DailyReflectionModel> reflections,
  required DateTime today,
}) {
  final activeDates = {for (final entry in entries) _dateOnly(entry.createdAt)};
  final reflectionDates = {
    for (final reflection in reflections) _dateOnly(reflection.date),
  };
  final recentDates = {...activeDates, ...reflectionDates};
  final todayOnly = _dateOnly(today);
  final recentWindowStart = todayOnly.subtract(const Duration(days: 6));
  final recentActiveDays = recentDates
      .where(
        (date) => !date.isBefore(recentWindowStart) && !date.isAfter(todayOnly),
      )
      .length;
  final growthPoints = activeDates.length + (reflectionDates.length * 2);
  final stage = _stageFor(growthPoints);

  return MoodGardenSummary(
    stage: stage,
    growthPoints: growthPoints,
    pointsForNextStage: _nextThresholdFor(stage),
    activeDayCount: activeDates.length,
    reflectionCount: reflectionDates.length,
    recentActiveDays: recentActiveDays,
  );
}

MoodGardenStage _stageFor(int points) {
  if (points >= 16) return MoodGardenStage.flourishing;
  if (points >= 9) return MoodGardenStage.bloom;
  if (points >= 4) return MoodGardenStage.leafy;
  if (points >= 1) return MoodGardenStage.sprout;
  return MoodGardenStage.seed;
}

String moodGardenStageName(MoodGardenStage stage) {
  return switch (stage) {
    MoodGardenStage.seed => 'Seed',
    MoodGardenStage.sprout => 'Sprout',
    MoodGardenStage.leafy => 'Leafy',
    MoodGardenStage.bloom => 'Bloom',
    MoodGardenStage.flourishing => 'Flourishing',
  };
}

int moodGardenThresholdFor(MoodGardenStage stage) {
  return switch (stage) {
    MoodGardenStage.seed => 0,
    MoodGardenStage.sprout => 1,
    MoodGardenStage.leafy => 4,
    MoodGardenStage.bloom => 9,
    MoodGardenStage.flourishing => 16,
  };
}

int _nextThresholdFor(MoodGardenStage stage) {
  return switch (stage) {
    MoodGardenStage.seed => 1,
    MoodGardenStage.sprout => 4,
    MoodGardenStage.leafy => 9,
    MoodGardenStage.bloom => 16,
    MoodGardenStage.flourishing => 16,
  };
}

DateTime _dateOnly(DateTime date) {
  final local = date.toLocal();
  return DateTime(local.year, local.month, local.day);
}
