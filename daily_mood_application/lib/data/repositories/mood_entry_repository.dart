import '../../core/database/app_database.dart' as db;
import '../../domain/models/mood_entry.dart';
import '../services/mood_entry_local_service.dart';

final class MoodEntryRepository {
  MoodEntryRepository({required MoodEntryLocalService localService})
    : _localService = localService;

  final MoodEntryLocalService _localService;

  Stream<List<MoodEntryModel>> watchRecentEntries({int limit = 50}) {
    return _localService
        .watchRecentEntries(limit: limit)
        .map((entries) => entries.map(_toDomain).toList(growable: false));
  }

  Future<int> createEntry({
    required int moodScore,
    String? note,
    String? voiceNotePath,
    String? photoRelativePath,
    required List<int> activityIds,
    List<int> subEmotionIds = const [],
  }) {
    return _localService.createEntry(
      moodScore: moodScore,
      note: note,
      voiceNotePath: voiceNotePath,
      photoRelativePath: photoRelativePath,
      activityIds: activityIds,
      subEmotionIds: subEmotionIds,
    );
  }

  MoodEntryModel _toDomain(db.MoodEntry entry) {
    return MoodEntryModel(
      id: entry.id,
      uuid: entry.uuid,
      moodScore: entry.moodScore,
      note: entry.note,
      voiceNotePath: entry.voiceNotePath,
      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,
    );
  }
}
