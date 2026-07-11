import '../../core/database/app_database.dart';
import '../../core/database/daos/mood_entry_dao.dart';

final class MoodEntryLocalService {
  MoodEntryLocalService({required MoodEntryDao moodEntryDao})
    : _moodEntryDao = moodEntryDao;

  final MoodEntryDao _moodEntryDao;

  Stream<List<MoodEntry>> watchRecentEntries({int limit = 50}) {
    return _moodEntryDao.watchRecentEntries(limit: limit);
  }

  Future<int> createEntry({
    required int moodScore,
    String? note,
    String? voiceNotePath,
    String? photoRelativePath,
    required List<int> activityIds,
    List<int> subEmotionIds = const [],
  }) {
    return _moodEntryDao.createEntry(
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
  }) {
    return _moodEntryDao.updateEntry(id: id, moodScore: moodScore, note: note);
  }

  Future<void> softDeleteEntry(int id) {
    return _moodEntryDao.softDeleteEntry(id);
  }
}
