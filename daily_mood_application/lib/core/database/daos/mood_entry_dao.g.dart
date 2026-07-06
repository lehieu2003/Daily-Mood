// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood_entry_dao.dart';

// ignore_for_file: type=lint
mixin _$MoodEntryDaoMixin on DatabaseAccessor<AppDatabase> {
  $MoodEntriesTable get moodEntries => attachedDatabase.moodEntries;
  $ActivitiesTable get activities => attachedDatabase.activities;
  $MoodEntryActivitiesTable get moodEntryActivities =>
      attachedDatabase.moodEntryActivities;
  MoodEntryDaoManager get managers => MoodEntryDaoManager(this);
}

class MoodEntryDaoManager {
  final _$MoodEntryDaoMixin _db;
  MoodEntryDaoManager(this._db);
  $$MoodEntriesTableTableManager get moodEntries =>
      $$MoodEntriesTableTableManager(_db.attachedDatabase, _db.moodEntries);
  $$ActivitiesTableTableManager get activities =>
      $$ActivitiesTableTableManager(_db.attachedDatabase, _db.activities);
  $$MoodEntryActivitiesTableTableManager get moodEntryActivities =>
      $$MoodEntryActivitiesTableTableManager(
        _db.attachedDatabase,
        _db.moodEntryActivities,
      );
}
