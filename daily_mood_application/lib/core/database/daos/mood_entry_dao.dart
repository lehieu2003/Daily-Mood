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

  Future<void> updateEntry({required int id, int? moodScore, String? note}) {
    return (update(moodEntries)..where((t) => t.id.equals(id))).write(
      MoodEntriesCompanion(
        moodScore: moodScore != null ? Value(moodScore) : const Value.absent(),
        note: note != null ? Value(note) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
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
