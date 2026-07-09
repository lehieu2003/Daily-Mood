import 'package:drift/drift.dart';

/// Mood log entries — the central table of the app.
class MoodEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Stable logical key used for import/export conflict resolution.
  /// Generated client-side (uuid package) at creation time.
  TextColumn get uuid => text().unique()();

  /// 1 = Awful ... 5 = Excellent
  ///
  /// Note: customConstraint() replaces Drift's default constraints
  /// entirely, so NOT NULL must be spelled out here explicitly.
  IntColumn get moodScore => integer().customConstraint(
    'NOT NULL CHECK (mood_score BETWEEN 1 AND 5)',
  )();

  TextColumn get note => text().nullable()();

  /// Relative path of an optional voice recording in app sandbox storage,
  /// e.g. `mood_voices/some-uuid.m4a`.
  TextColumn get voiceNotePath => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  /// Used to resolve conflicts when importing a backup file.
  DateTimeColumn get updatedAt => dateTime()();

  /// Soft delete flag — never hard-delete immediately, to protect
  /// against accidental taps. A cleanup job purges rows after N days.
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}

/// Category enum stored as plain text for simplicity + forward
/// compatibility (adding a new category doesn't need a migration).
class Activities extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get uuid => text().unique()();

  TextColumn get name => text().withLength(min: 1, max: 20)();

  /// 'Health' | 'Life' | 'Other'
  TextColumn get category => text()();

  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();

  /// Archived tags are hidden from the picker but kept so historical
  /// entries still resolve correctly.
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {name},
  ];
}

/// Many-to-many join table between MoodEntries and Activities.
class MoodEntryActivities extends Table {
  IntColumn get moodEntryId =>
      integer().references(MoodEntries, #id, onDelete: KeyAction.cascade)();

  /// RESTRICT: an activity in use by a real entry can't be hard-deleted,
  /// only archived — keeps historical entries meaningful.
  IntColumn get activityId =>
      integer().references(Activities, #id, onDelete: KeyAction.restrict)();

  @override
  Set<Column> get primaryKey => {moodEntryId, activityId};
}

/// Static catalog of detailed emotions grouped under the 5 mood scores.
class SubEmotions extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().unique()();

  /// Emoji character or app asset code used by the UI.
  TextColumn get emoji => text()();

  /// 1 = Awful ... 5 = Excellent
  IntColumn get parentMoodScore => integer().customConstraint(
    'NOT NULL CHECK (parent_mood_score BETWEEN 1 AND 5)',
  )();
}

/// Many-to-many join table between MoodEntries and SubEmotions.
class MoodEntrySubEmotions extends Table {
  IntColumn get moodEntryId =>
      integer().references(MoodEntries, #id, onDelete: KeyAction.cascade)();

  IntColumn get subEmotionId =>
      integer().references(SubEmotions, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {moodEntryId, subEmotionId};
}

/// Reference to an optional photo attached to an entry.
/// The actual image bytes live on disk (path_provider); only the
/// relative path is stored here — never an absolute path.
class MoodPhotos extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get moodEntryId => integer()
      .references(MoodEntries, #id, onDelete: KeyAction.cascade)
      .unique()();

  /// Relative to the app's documents directory, e.g.
  /// `mood_photos/some-uuid.jpg`
  TextColumn get relativePath => text()();

  DateTimeColumn get createdAt => dateTime()();
}
