import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';
import '../tables/tables.dart';

part 'activity_dao.g.dart';

class ActivityLimitExceeded implements Exception {
  final String message;
  ActivityLimitExceeded(this.message);
}

@DriftAccessor(tables: [Activities])
class ActivityDao extends DatabaseAccessor<AppDatabase>
    with _$ActivityDaoMixin {
  ActivityDao(super.db);

  static const _uuid = Uuid();

  /// Business rule from the design spec: max 30 custom tags per user.
  static const maxCustomTags = 30;

  Stream<List<Activity>> watchActiveActivities() {
    final query = select(activities)
      ..where((t) => t.isArchived.equals(false))
      ..orderBy([(t) => OrderingTerm.asc(t.category)]);
    return query.watch().map((rows) {
      debugPrint(
        '[DailyMood][reasons] watchActiveActivities emitted '
        '${rows.length} rows: '
        '${rows.map((activity) => '${activity.id}:${activity.name}').join(', ')}',
      );
      return rows;
    });
  }

  Stream<List<Activity>> watchCustomActivities() {
    final query = select(activities)
      ..where((t) => t.isCustom.equals(true))
      ..orderBy([
        (t) => OrderingTerm.asc(t.isArchived),
        (t) => OrderingTerm.asc(t.name),
      ]);
    return query.watch();
  }

  Future<int> createCustomActivity({
    required String name,
    required String category,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty || trimmed.length > 20) {
      throw ArgumentError('Activity name must be 1-20 characters');
    }

    final customCount =
        await (selectOnly(activities)
              ..addColumns([activities.id.count()])
              ..where(activities.isCustom.equals(true)))
            .map((row) => row.read(activities.id.count()) ?? 0)
            .getSingle();

    if (customCount >= maxCustomTags) {
      throw ActivityLimitExceeded(
        'Maximum of $maxCustomTags custom tags reached',
      );
    }

    return into(activities).insert(
      ActivitiesCompanion.insert(
        uuid: _uuid.v4(),
        name: trimmed,
        category: category,
        isCustom: const Value(true),
        createdAt: DateTime.now(),
      ),
    );
  }

  /// Tags in use are archived, never hard-deleted — see ERD notes on
  /// ON DELETE RESTRICT for why historical entries must keep context.
  Future<void> archiveActivity(int id) {
    return (update(activities)..where((t) => t.id.equals(id))).write(
      const ActivitiesCompanion(isArchived: Value(true)),
    );
  }

  Future<void> restoreActivity(int id) {
    return (update(activities)..where((t) => t.id.equals(id))).write(
      const ActivitiesCompanion(isArchived: Value(false)),
    );
  }
}
