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

  Stream<List<MoodEntryModel>> watchHistoryEntries({int limit = 500}) {
    return _localService.watchHistoryEntries(limit: limit).map((entries) {
      return entries
          .map(
            (row) => _toDomain(
              row.entry,
              photoRelativePath: row.photoRelativePath,
              activityIds: row.activityIds,
              activityNames: row.activityNames,
              subEmotionIds: row.subEmotionIds,
              subEmotionNames: row.subEmotionNames,
            ),
          )
          .toList(growable: false);
    });
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

  Future<void> updateEntry({
    required int id,
    required int moodScore,
    required String note,
    String? voiceNotePath,
    String? photoRelativePath,
    required List<int> activityIds,
    required List<int> subEmotionIds,
  }) {
    return _localService.updateEntry(
      id: id,
      moodScore: moodScore,
      note: note,
      voiceNotePath: voiceNotePath,
      photoRelativePath: photoRelativePath,
      activityIds: activityIds,
      subEmotionIds: subEmotionIds,
    );
  }

  Future<void> softDeleteEntry(int id) {
    return _localService.softDeleteEntry(id);
  }

  MoodEntryModel _toDomain(
    db.MoodEntry entry, {
    String? photoRelativePath,
    List<int> activityIds = const [],
    List<String> activityNames = const [],
    List<int> subEmotionIds = const [],
    List<String> subEmotionNames = const [],
  }) {
    return MoodEntryModel(
      id: entry.id,
      uuid: entry.uuid,
      moodScore: entry.moodScore,
      note: entry.note,
      voiceNotePath: entry.voiceNotePath,
      photoRelativePath: photoRelativePath,
      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,
      activityIds: activityIds,
      activityNames: activityNames,
      subEmotionIds: subEmotionIds,
      subEmotionNames: subEmotionNames,
    );
  }
}
