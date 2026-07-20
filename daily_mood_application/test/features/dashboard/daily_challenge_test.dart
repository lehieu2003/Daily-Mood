import 'package:daily_mood_application/features/dashboard/daily_challenge.dart';
import 'package:daily_mood_application/features/settings/data/settings_preferences_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('selects a stable local challenge for a date', () {
    final first = dailyChallengeForDate(DateTime(2026, 7, 20));
    final second = dailyChallengeForDate(DateTime(2026, 7, 20, 23, 45));
    final nextDay = dailyChallengeForDate(DateTime(2026, 7, 21));

    expect(first.id, DailyChallengeId.breathe);
    expect(second.id, first.id);
    expect(nextDay.id, DailyChallengeId.shortWalk);
  });

  test('stores daily challenge completion per local date', () async {
    final repository = DailyChallengeRepository(
      repository: SettingsPreferencesRepository(
        store: InMemorySettingsPreferencesStore(),
      ),
    );
    final today = DateTime(2026, 7, 20);
    final tomorrow = DateTime(2026, 7, 21);

    expect(await repository.isCompleted(today), isFalse);

    await repository.markCompleted(today);

    expect(await repository.isCompleted(today), isTrue);
    expect(await repository.isCompleted(tomorrow), isFalse);
  });
}
