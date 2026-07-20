import '../settings/data/settings_preferences_repository.dart';

enum DailyChallengeId {
  goOutside,
  gratitude,
  stretch,
  drinkWater,
  breathe,
  shortWalk,
}

final class DailyChallenge {
  const DailyChallenge({required this.id});

  final DailyChallengeId id;
}

const dailyChallengePool = [
  DailyChallenge(id: DailyChallengeId.goOutside),
  DailyChallenge(id: DailyChallengeId.gratitude),
  DailyChallenge(id: DailyChallengeId.stretch),
  DailyChallenge(id: DailyChallengeId.drinkWater),
  DailyChallenge(id: DailyChallengeId.breathe),
  DailyChallenge(id: DailyChallengeId.shortWalk),
];

DailyChallenge dailyChallengeForDate(DateTime date) {
  final local = date.toLocal();
  final seed = local.year * 10000 + local.month * 100 + local.day;
  return dailyChallengePool[seed % dailyChallengePool.length];
}

final class DailyChallengeRepository {
  DailyChallengeRepository({required SettingsPreferencesRepository repository})
    : _repository = repository;

  final SettingsPreferencesRepository _repository;

  DailyChallenge challengeForDate(DateTime date) {
    return dailyChallengeForDate(date);
  }

  Future<bool> isCompleted(DateTime date) {
    return _repository.readDailyChallengeCompleted(date);
  }

  Future<void> markCompleted(DateTime date) {
    return _repository.setDailyChallengeCompleted(
      date: date,
      completed: true,
    );
  }
}
