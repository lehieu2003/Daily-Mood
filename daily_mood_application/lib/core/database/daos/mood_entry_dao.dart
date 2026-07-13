import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';
import '../tables/tables.dart';

part 'mood_entry_dao.g.dart';

@DriftAccessor(tables: [MoodEntries, Activities, MoodEntryActivities])
class MoodEntryDao extends DatabaseAccessor<AppDatabase>
    with _$MoodEntryDaoMixin {
  MoodEntryDao(super.db);

  static const _uuid = Uuid();

  /// Reactive stream of non-deleted entries, most recent first.
  /// Dashboard listens to this directly — no manual refresh needed.
  Stream<List<MoodEntry>> watchRecentEntries({int limit = 50}) {
    final query = select(moodEntries)
      ..where((t) => t.isDeleted.equals(false))
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..limit(limit);
    return query.watch();
  }

  Stream<List<MoodEntryHistoryRow>> watchHistoryEntries({int limit = 500}) {
    return customSelect(
      '''
SELECT
  me.id,
  me.uuid,
  me.mood_score,
  me.note,
  me.voice_note_path,
  me.created_at,
  me.updated_at,
  me.is_deleted,
  mp.relative_path AS photo_relative_path,
  COALESCE((
    SELECT GROUP_CONCAT(a.id, char(31))
    FROM mood_entry_activities mea
    INNER JOIN activities a ON a.id = mea.activity_id
    WHERE mea.mood_entry_id = me.id
    ORDER BY a.name COLLATE NOCASE
  ), '') AS activity_ids,
  COALESCE((
    SELECT GROUP_CONCAT(a.name, char(31))
    FROM mood_entry_activities mea
    INNER JOIN activities a ON a.id = mea.activity_id
    WHERE mea.mood_entry_id = me.id
    ORDER BY a.name COLLATE NOCASE
  ), '') AS activity_names,
  COALESCE((
    SELECT GROUP_CONCAT(se.id, char(31))
    FROM mood_entry_sub_emotions mese
    INNER JOIN sub_emotions se ON se.id = mese.sub_emotion_id
    WHERE mese.mood_entry_id = me.id
    ORDER BY se.name COLLATE NOCASE
  ), '') AS sub_emotion_ids,
  COALESCE((
    SELECT GROUP_CONCAT(se.name, char(31))
    FROM mood_entry_sub_emotions mese
    INNER JOIN sub_emotions se ON se.id = mese.sub_emotion_id
    WHERE mese.mood_entry_id = me.id
    ORDER BY se.name COLLATE NOCASE
  ), '') AS sub_emotion_names
FROM mood_entries me
LEFT JOIN mood_photos mp ON mp.mood_entry_id = me.id
WHERE me.is_deleted = 0
ORDER BY me.created_at DESC
LIMIT ?
''',
      variables: [Variable<int>(limit)],
      readsFrom: {
        moodEntries,
        activities,
        moodEntryActivities,
        attachedDatabase.subEmotions,
        attachedDatabase.moodEntrySubEmotions,
        attachedDatabase.moodPhotos,
      },
    ).watch().map((rows) {
      return rows.map(MoodEntryHistoryRow.fromQueryRow).toList(growable: false);
    });
  }

  Stream<List<MoodEntry>> watchEntriesBetween(DateTime start, DateTime end) {
    final query = select(moodEntries)
      ..where(
        (t) =>
            t.isDeleted.equals(false) &
            t.createdAt.isBiggerOrEqualValue(start) &
            t.createdAt.isSmallerThanValue(end),
      )
      ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]);
    return query.watch();
  }

  Stream<List<QueryRow>> watchActivityMoodCorrelationRows({int limit = 6}) {
    return customSelect(
      '''
SELECT
  a.id AS activity_id,
  a.name AS activity_name,
  COUNT(me.id) AS entry_count,
  AVG(me.mood_score) AS average_mood
FROM activities a
INNER JOIN mood_entry_activities mea ON mea.activity_id = a.id
INNER JOIN mood_entries me ON me.id = mea.mood_entry_id
WHERE me.is_deleted = 0
GROUP BY a.id, a.name
ORDER BY entry_count DESC, average_mood DESC, a.name ASC
LIMIT ?
''',
      variables: [Variable<int>(limit)],
      readsFrom: {activities, moodEntryActivities, moodEntries},
    ).watch();
  }

  /// Creates a new entry plus its activity tag links in a single
  /// transaction, so the dashboard never sees a half-written entry.
  Future<int> createEntry({
    required int moodScore,
    String? note,
    String? voiceNotePath,
    String? photoRelativePath,
    required List<int> activityIds,
    List<int> subEmotionIds = const [],
  }) async {
    final now = DateTime.now();

    return transaction(() async {
      final entryId = await into(moodEntries).insert(
        MoodEntriesCompanion.insert(
          uuid: _uuid.v4(),
          moodScore: moodScore,
          note: Value(note),
          voiceNotePath: Value(voiceNotePath),
          createdAt: now,
          updatedAt: now,
        ),
      );

      if (activityIds.isNotEmpty) {
        await batch((b) {
          b.insertAll(
            moodEntryActivities,
            activityIds
                .map(
                  (activityId) => MoodEntryActivitiesCompanion.insert(
                    moodEntryId: entryId,
                    activityId: activityId,
                  ),
                )
                .toList(),
          );
        });
      }

      if (subEmotionIds.isNotEmpty) {
        await batch((b) {
          b.insertAll(
            attachedDatabase.moodEntrySubEmotions,
            subEmotionIds
                .map(
                  (subEmotionId) => MoodEntrySubEmotionsCompanion.insert(
                    moodEntryId: entryId,
                    subEmotionId: subEmotionId,
                  ),
                )
                .toList(),
          );
        });
      }

      if (photoRelativePath != null) {
        await into(attachedDatabase.moodPhotos).insert(
          MoodPhotosCompanion.insert(
            moodEntryId: entryId,
            relativePath: photoRelativePath,
            createdAt: now,
          ),
        );
      }

      return entryId;
    });
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
    final now = DateTime.now();

    return transaction(() async {
      await (update(moodEntries)..where((t) => t.id.equals(id))).write(
        MoodEntriesCompanion(
          moodScore: Value(moodScore),
          note: Value(note),
          voiceNotePath: Value(voiceNotePath),
          updatedAt: Value(now),
        ),
      );

      await (delete(
        moodEntryActivities,
      )..where((t) => t.moodEntryId.equals(id))).go();
      if (activityIds.isNotEmpty) {
        await batch((b) {
          b.insertAll(
            moodEntryActivities,
            activityIds
                .map(
                  (activityId) => MoodEntryActivitiesCompanion.insert(
                    moodEntryId: id,
                    activityId: activityId,
                  ),
                )
                .toList(),
          );
        });
      }

      await (delete(
        attachedDatabase.moodEntrySubEmotions,
      )..where((t) => t.moodEntryId.equals(id))).go();
      if (subEmotionIds.isNotEmpty) {
        await batch((b) {
          b.insertAll(
            attachedDatabase.moodEntrySubEmotions,
            subEmotionIds
                .map(
                  (subEmotionId) => MoodEntrySubEmotionsCompanion.insert(
                    moodEntryId: id,
                    subEmotionId: subEmotionId,
                  ),
                )
                .toList(),
          );
        });
      }

      await (delete(
        attachedDatabase.moodPhotos,
      )..where((t) => t.moodEntryId.equals(id))).go();
      if (photoRelativePath != null) {
        await into(attachedDatabase.moodPhotos).insert(
          MoodPhotosCompanion.insert(
            moodEntryId: id,
            relativePath: photoRelativePath,
            createdAt: now,
          ),
        );
      }
    });
  }

  /// Soft delete — actual row cleanup happens in a periodic background
  /// job, not here, so an accidental delete can still be recovered.
  Future<void> softDeleteEntry(int id) {
    return (update(moodEntries)..where((t) => t.id.equals(id))).write(
      MoodEntriesCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<List<Activity>> getActivitiesForEntry(int entryId) {
    final query = select(activities).join([
      innerJoin(
        moodEntryActivities,
        moodEntryActivities.activityId.equalsExp(activities.id),
      ),
    ])..where(moodEntryActivities.moodEntryId.equals(entryId));

    return query.map((row) => row.readTable(activities)).get();
  }
}

final class MoodEntryHistoryRow {
  const MoodEntryHistoryRow({
    required this.entry,
    required this.photoRelativePath,
    required this.activityIds,
    required this.activityNames,
    required this.subEmotionIds,
    required this.subEmotionNames,
  });

  final MoodEntry entry;
  final String? photoRelativePath;
  final List<int> activityIds;
  final List<String> activityNames;
  final List<int> subEmotionIds;
  final List<String> subEmotionNames;

  factory MoodEntryHistoryRow.fromQueryRow(QueryRow row) {
    return MoodEntryHistoryRow(
      entry: MoodEntry(
        id: row.read<int>('id'),
        uuid: row.read<String>('uuid'),
        moodScore: row.read<int>('mood_score'),
        note: row.readNullable<String>('note'),
        voiceNotePath: row.readNullable<String>('voice_note_path'),
        createdAt: row.read<DateTime>('created_at'),
        updatedAt: row.read<DateTime>('updated_at'),
        isDeleted: _readBool(row.data['is_deleted']),
      ),
      photoRelativePath: row.readNullable<String>('photo_relative_path'),
      activityIds: _splitIds(row.read<String>('activity_ids')),
      activityNames: _splitNames(row.read<String>('activity_names')),
      subEmotionIds: _splitIds(row.read<String>('sub_emotion_ids')),
      subEmotionNames: _splitNames(row.read<String>('sub_emotion_names')),
    );
  }

  static bool _readBool(Object? value) {
    return value == true || value == 1;
  }

  static List<String> _splitNames(String value) {
    if (value.isEmpty) return const [];
    return value
        .split('\u001f')
        .where((name) => name.trim().isNotEmpty)
        .toList(growable: false);
  }

  static List<int> _splitIds(String value) {
    if (value.isEmpty) return const [];
    return value
        .split('\u001f')
        .map(int.tryParse)
        .whereType<int>()
        .toList(growable: false);
  }
}
