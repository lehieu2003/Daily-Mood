// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MoodEntriesTable extends MoodEntries
    with TableInfo<$MoodEntriesTable, MoodEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoodEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _moodScoreMeta = const VerificationMeta(
    'moodScore',
  );
  @override
  late final GeneratedColumn<int> moodScore = GeneratedColumn<int>(
    'mood_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (mood_score BETWEEN 1 AND 5)',
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _voiceNotePathMeta = const VerificationMeta(
    'voiceNotePath',
  );
  @override
  late final GeneratedColumn<String> voiceNotePath = GeneratedColumn<String>(
    'voice_note_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uuid,
    moodScore,
    note,
    voiceNotePath,
    createdAt,
    updatedAt,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mood_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<MoodEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('mood_score')) {
      context.handle(
        _moodScoreMeta,
        moodScore.isAcceptableOrUnknown(data['mood_score']!, _moodScoreMeta),
      );
    } else if (isInserting) {
      context.missing(_moodScoreMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('voice_note_path')) {
      context.handle(
        _voiceNotePathMeta,
        voiceNotePath.isAcceptableOrUnknown(
          data['voice_note_path']!,
          _voiceNotePathMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MoodEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MoodEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      moodScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mood_score'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      voiceNotePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}voice_note_path'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $MoodEntriesTable createAlias(String alias) {
    return $MoodEntriesTable(attachedDatabase, alias);
  }
}

class MoodEntry extends DataClass implements Insertable<MoodEntry> {
  final int id;

  /// Stable logical key used for import/export conflict resolution.
  /// Generated client-side (uuid package) at creation time.
  final String uuid;

  /// 1 = Awful ... 5 = Excellent
  ///
  /// Note: customConstraint() replaces Drift's default constraints
  /// entirely, so NOT NULL must be spelled out here explicitly.
  final int moodScore;
  final String? note;

  /// Relative path of an optional voice recording in app sandbox storage,
  /// e.g. `mood_voices/some-uuid.m4a`.
  final String? voiceNotePath;
  final DateTime createdAt;

  /// Used to resolve conflicts when importing a backup file.
  final DateTime updatedAt;

  /// Soft delete flag — never hard-delete immediately, to protect
  /// against accidental taps. A cleanup job purges rows after N days.
  final bool isDeleted;
  const MoodEntry({
    required this.id,
    required this.uuid,
    required this.moodScore,
    this.note,
    this.voiceNotePath,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['mood_score'] = Variable<int>(moodScore);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || voiceNotePath != null) {
      map['voice_note_path'] = Variable<String>(voiceNotePath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  MoodEntriesCompanion toCompanion(bool nullToAbsent) {
    return MoodEntriesCompanion(
      id: Value(id),
      uuid: Value(uuid),
      moodScore: Value(moodScore),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      voiceNotePath: voiceNotePath == null && nullToAbsent
          ? const Value.absent()
          : Value(voiceNotePath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory MoodEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MoodEntry(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      moodScore: serializer.fromJson<int>(json['moodScore']),
      note: serializer.fromJson<String?>(json['note']),
      voiceNotePath: serializer.fromJson<String?>(json['voiceNotePath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'moodScore': serializer.toJson<int>(moodScore),
      'note': serializer.toJson<String?>(note),
      'voiceNotePath': serializer.toJson<String?>(voiceNotePath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  MoodEntry copyWith({
    int? id,
    String? uuid,
    int? moodScore,
    Value<String?> note = const Value.absent(),
    Value<String?> voiceNotePath = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) => MoodEntry(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    moodScore: moodScore ?? this.moodScore,
    note: note.present ? note.value : this.note,
    voiceNotePath: voiceNotePath.present
        ? voiceNotePath.value
        : this.voiceNotePath,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  MoodEntry copyWithCompanion(MoodEntriesCompanion data) {
    return MoodEntry(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      moodScore: data.moodScore.present ? data.moodScore.value : this.moodScore,
      note: data.note.present ? data.note.value : this.note,
      voiceNotePath: data.voiceNotePath.present
          ? data.voiceNotePath.value
          : this.voiceNotePath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MoodEntry(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('moodScore: $moodScore, ')
          ..write('note: $note, ')
          ..write('voiceNotePath: $voiceNotePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    uuid,
    moodScore,
    note,
    voiceNotePath,
    createdAt,
    updatedAt,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoodEntry &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.moodScore == this.moodScore &&
          other.note == this.note &&
          other.voiceNotePath == this.voiceNotePath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted);
}

class MoodEntriesCompanion extends UpdateCompanion<MoodEntry> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<int> moodScore;
  final Value<String?> note;
  final Value<String?> voiceNotePath;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isDeleted;
  const MoodEntriesCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.moodScore = const Value.absent(),
    this.note = const Value.absent(),
    this.voiceNotePath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  MoodEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required int moodScore,
    this.note = const Value.absent(),
    this.voiceNotePath = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isDeleted = const Value.absent(),
  }) : uuid = Value(uuid),
       moodScore = Value(moodScore),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<MoodEntry> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<int>? moodScore,
    Expression<String>? note,
    Expression<String>? voiceNotePath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (moodScore != null) 'mood_score': moodScore,
      if (note != null) 'note': note,
      if (voiceNotePath != null) 'voice_note_path': voiceNotePath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  MoodEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? uuid,
    Value<int>? moodScore,
    Value<String?>? note,
    Value<String?>? voiceNotePath,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isDeleted,
  }) {
    return MoodEntriesCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      moodScore: moodScore ?? this.moodScore,
      note: note ?? this.note,
      voiceNotePath: voiceNotePath ?? this.voiceNotePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (moodScore.present) {
      map['mood_score'] = Variable<int>(moodScore.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (voiceNotePath.present) {
      map['voice_note_path'] = Variable<String>(voiceNotePath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoodEntriesCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('moodScore: $moodScore, ')
          ..write('note: $note, ')
          ..write('voiceNotePath: $voiceNotePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $ActivitiesTable extends Activities
    with TableInfo<$ActivitiesTable, Activity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCustomMeta = const VerificationMeta(
    'isCustom',
  );
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uuid,
    name,
    category,
    isCustom,
    isArchived,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activities';
  @override
  VerificationContext validateIntegrity(
    Insertable<Activity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {name},
  ];
  @override
  Activity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Activity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      isCustom: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ActivitiesTable createAlias(String alias) {
    return $ActivitiesTable(attachedDatabase, alias);
  }
}

class Activity extends DataClass implements Insertable<Activity> {
  final int id;
  final String uuid;
  final String name;

  /// 'Health' | 'Life' | 'Other'
  final String category;
  final bool isCustom;

  /// Archived tags are hidden from the picker but kept so historical
  /// entries still resolve correctly.
  final bool isArchived;
  final DateTime createdAt;
  const Activity({
    required this.id,
    required this.uuid,
    required this.name,
    required this.category,
    required this.isCustom,
    required this.isArchived,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['is_custom'] = Variable<bool>(isCustom);
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ActivitiesCompanion toCompanion(bool nullToAbsent) {
    return ActivitiesCompanion(
      id: Value(id),
      uuid: Value(uuid),
      name: Value(name),
      category: Value(category),
      isCustom: Value(isCustom),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
    );
  }

  factory Activity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Activity(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'isCustom': serializer.toJson<bool>(isCustom),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Activity copyWith({
    int? id,
    String? uuid,
    String? name,
    String? category,
    bool? isCustom,
    bool? isArchived,
    DateTime? createdAt,
  }) => Activity(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    name: name ?? this.name,
    category: category ?? this.category,
    isCustom: isCustom ?? this.isCustom,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt ?? this.createdAt,
  );
  Activity copyWithCompanion(ActivitiesCompanion data) {
    return Activity(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Activity(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('isCustom: $isCustom, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, uuid, name, category, isCustom, isArchived, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Activity &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.name == this.name &&
          other.category == this.category &&
          other.isCustom == this.isCustom &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt);
}

class ActivitiesCompanion extends UpdateCompanion<Activity> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> name;
  final Value<String> category;
  final Value<bool> isCustom;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  const ActivitiesCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ActivitiesCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required String name,
    required String category,
    this.isCustom = const Value.absent(),
    this.isArchived = const Value.absent(),
    required DateTime createdAt,
  }) : uuid = Value(uuid),
       name = Value(name),
       category = Value(category),
       createdAt = Value(createdAt);
  static Insertable<Activity> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? name,
    Expression<String>? category,
    Expression<bool>? isCustom,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (isCustom != null) 'is_custom': isCustom,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ActivitiesCompanion copyWith({
    Value<int>? id,
    Value<String>? uuid,
    Value<String>? name,
    Value<String>? category,
    Value<bool>? isCustom,
    Value<bool>? isArchived,
    Value<DateTime>? createdAt,
  }) {
    return ActivitiesCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      category: category ?? this.category,
      isCustom: isCustom ?? this.isCustom,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivitiesCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('isCustom: $isCustom, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MoodEntryActivitiesTable extends MoodEntryActivities
    with TableInfo<$MoodEntryActivitiesTable, MoodEntryActivity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoodEntryActivitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _moodEntryIdMeta = const VerificationMeta(
    'moodEntryId',
  );
  @override
  late final GeneratedColumn<int> moodEntryId = GeneratedColumn<int>(
    'mood_entry_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES mood_entries (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<int> activityId = GeneratedColumn<int>(
    'activity_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES activities (id) ON DELETE RESTRICT',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [moodEntryId, activityId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mood_entry_activities';
  @override
  VerificationContext validateIntegrity(
    Insertable<MoodEntryActivity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('mood_entry_id')) {
      context.handle(
        _moodEntryIdMeta,
        moodEntryId.isAcceptableOrUnknown(
          data['mood_entry_id']!,
          _moodEntryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_moodEntryIdMeta);
    }
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_activityIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {moodEntryId, activityId};
  @override
  MoodEntryActivity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MoodEntryActivity(
      moodEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mood_entry_id'],
      )!,
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}activity_id'],
      )!,
    );
  }

  @override
  $MoodEntryActivitiesTable createAlias(String alias) {
    return $MoodEntryActivitiesTable(attachedDatabase, alias);
  }
}

class MoodEntryActivity extends DataClass
    implements Insertable<MoodEntryActivity> {
  final int moodEntryId;

  /// RESTRICT: an activity in use by a real entry can't be hard-deleted,
  /// only archived — keeps historical entries meaningful.
  final int activityId;
  const MoodEntryActivity({
    required this.moodEntryId,
    required this.activityId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['mood_entry_id'] = Variable<int>(moodEntryId);
    map['activity_id'] = Variable<int>(activityId);
    return map;
  }

  MoodEntryActivitiesCompanion toCompanion(bool nullToAbsent) {
    return MoodEntryActivitiesCompanion(
      moodEntryId: Value(moodEntryId),
      activityId: Value(activityId),
    );
  }

  factory MoodEntryActivity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MoodEntryActivity(
      moodEntryId: serializer.fromJson<int>(json['moodEntryId']),
      activityId: serializer.fromJson<int>(json['activityId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'moodEntryId': serializer.toJson<int>(moodEntryId),
      'activityId': serializer.toJson<int>(activityId),
    };
  }

  MoodEntryActivity copyWith({int? moodEntryId, int? activityId}) =>
      MoodEntryActivity(
        moodEntryId: moodEntryId ?? this.moodEntryId,
        activityId: activityId ?? this.activityId,
      );
  MoodEntryActivity copyWithCompanion(MoodEntryActivitiesCompanion data) {
    return MoodEntryActivity(
      moodEntryId: data.moodEntryId.present
          ? data.moodEntryId.value
          : this.moodEntryId,
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MoodEntryActivity(')
          ..write('moodEntryId: $moodEntryId, ')
          ..write('activityId: $activityId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(moodEntryId, activityId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoodEntryActivity &&
          other.moodEntryId == this.moodEntryId &&
          other.activityId == this.activityId);
}

class MoodEntryActivitiesCompanion extends UpdateCompanion<MoodEntryActivity> {
  final Value<int> moodEntryId;
  final Value<int> activityId;
  final Value<int> rowid;
  const MoodEntryActivitiesCompanion({
    this.moodEntryId = const Value.absent(),
    this.activityId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MoodEntryActivitiesCompanion.insert({
    required int moodEntryId,
    required int activityId,
    this.rowid = const Value.absent(),
  }) : moodEntryId = Value(moodEntryId),
       activityId = Value(activityId);
  static Insertable<MoodEntryActivity> custom({
    Expression<int>? moodEntryId,
    Expression<int>? activityId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (moodEntryId != null) 'mood_entry_id': moodEntryId,
      if (activityId != null) 'activity_id': activityId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MoodEntryActivitiesCompanion copyWith({
    Value<int>? moodEntryId,
    Value<int>? activityId,
    Value<int>? rowid,
  }) {
    return MoodEntryActivitiesCompanion(
      moodEntryId: moodEntryId ?? this.moodEntryId,
      activityId: activityId ?? this.activityId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (moodEntryId.present) {
      map['mood_entry_id'] = Variable<int>(moodEntryId.value);
    }
    if (activityId.present) {
      map['activity_id'] = Variable<int>(activityId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoodEntryActivitiesCompanion(')
          ..write('moodEntryId: $moodEntryId, ')
          ..write('activityId: $activityId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubEmotionsTable extends SubEmotions
    with TableInfo<$SubEmotionsTable, SubEmotion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubEmotionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentMoodScoreMeta = const VerificationMeta(
    'parentMoodScore',
  );
  @override
  late final GeneratedColumn<int> parentMoodScore = GeneratedColumn<int>(
    'parent_mood_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (parent_mood_score BETWEEN 1 AND 5)',
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, emoji, parentMoodScore];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sub_emotions';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubEmotion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
      );
    } else if (isInserting) {
      context.missing(_emojiMeta);
    }
    if (data.containsKey('parent_mood_score')) {
      context.handle(
        _parentMoodScoreMeta,
        parentMoodScore.isAcceptableOrUnknown(
          data['parent_mood_score']!,
          _parentMoodScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_parentMoodScoreMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubEmotion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubEmotion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      emoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji'],
      )!,
      parentMoodScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_mood_score'],
      )!,
    );
  }

  @override
  $SubEmotionsTable createAlias(String alias) {
    return $SubEmotionsTable(attachedDatabase, alias);
  }
}

class SubEmotion extends DataClass implements Insertable<SubEmotion> {
  final int id;
  final String name;

  /// Emoji character or app asset code used by the UI.
  final String emoji;

  /// 1 = Awful ... 5 = Excellent
  final int parentMoodScore;
  const SubEmotion({
    required this.id,
    required this.name,
    required this.emoji,
    required this.parentMoodScore,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['emoji'] = Variable<String>(emoji);
    map['parent_mood_score'] = Variable<int>(parentMoodScore);
    return map;
  }

  SubEmotionsCompanion toCompanion(bool nullToAbsent) {
    return SubEmotionsCompanion(
      id: Value(id),
      name: Value(name),
      emoji: Value(emoji),
      parentMoodScore: Value(parentMoodScore),
    );
  }

  factory SubEmotion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubEmotion(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      emoji: serializer.fromJson<String>(json['emoji']),
      parentMoodScore: serializer.fromJson<int>(json['parentMoodScore']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'emoji': serializer.toJson<String>(emoji),
      'parentMoodScore': serializer.toJson<int>(parentMoodScore),
    };
  }

  SubEmotion copyWith({
    int? id,
    String? name,
    String? emoji,
    int? parentMoodScore,
  }) => SubEmotion(
    id: id ?? this.id,
    name: name ?? this.name,
    emoji: emoji ?? this.emoji,
    parentMoodScore: parentMoodScore ?? this.parentMoodScore,
  );
  SubEmotion copyWithCompanion(SubEmotionsCompanion data) {
    return SubEmotion(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      parentMoodScore: data.parentMoodScore.present
          ? data.parentMoodScore.value
          : this.parentMoodScore,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubEmotion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('emoji: $emoji, ')
          ..write('parentMoodScore: $parentMoodScore')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, emoji, parentMoodScore);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubEmotion &&
          other.id == this.id &&
          other.name == this.name &&
          other.emoji == this.emoji &&
          other.parentMoodScore == this.parentMoodScore);
}

class SubEmotionsCompanion extends UpdateCompanion<SubEmotion> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> emoji;
  final Value<int> parentMoodScore;
  const SubEmotionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.emoji = const Value.absent(),
    this.parentMoodScore = const Value.absent(),
  });
  SubEmotionsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String emoji,
    required int parentMoodScore,
  }) : name = Value(name),
       emoji = Value(emoji),
       parentMoodScore = Value(parentMoodScore);
  static Insertable<SubEmotion> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? emoji,
    Expression<int>? parentMoodScore,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (emoji != null) 'emoji': emoji,
      if (parentMoodScore != null) 'parent_mood_score': parentMoodScore,
    });
  }

  SubEmotionsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? emoji,
    Value<int>? parentMoodScore,
  }) {
    return SubEmotionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      parentMoodScore: parentMoodScore ?? this.parentMoodScore,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (parentMoodScore.present) {
      map['parent_mood_score'] = Variable<int>(parentMoodScore.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubEmotionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('emoji: $emoji, ')
          ..write('parentMoodScore: $parentMoodScore')
          ..write(')'))
        .toString();
  }
}

class $MoodEntrySubEmotionsTable extends MoodEntrySubEmotions
    with TableInfo<$MoodEntrySubEmotionsTable, MoodEntrySubEmotion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoodEntrySubEmotionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _moodEntryIdMeta = const VerificationMeta(
    'moodEntryId',
  );
  @override
  late final GeneratedColumn<int> moodEntryId = GeneratedColumn<int>(
    'mood_entry_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES mood_entries (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _subEmotionIdMeta = const VerificationMeta(
    'subEmotionId',
  );
  @override
  late final GeneratedColumn<int> subEmotionId = GeneratedColumn<int>(
    'sub_emotion_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sub_emotions (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [moodEntryId, subEmotionId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mood_entry_sub_emotions';
  @override
  VerificationContext validateIntegrity(
    Insertable<MoodEntrySubEmotion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('mood_entry_id')) {
      context.handle(
        _moodEntryIdMeta,
        moodEntryId.isAcceptableOrUnknown(
          data['mood_entry_id']!,
          _moodEntryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_moodEntryIdMeta);
    }
    if (data.containsKey('sub_emotion_id')) {
      context.handle(
        _subEmotionIdMeta,
        subEmotionId.isAcceptableOrUnknown(
          data['sub_emotion_id']!,
          _subEmotionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subEmotionIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {moodEntryId, subEmotionId};
  @override
  MoodEntrySubEmotion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MoodEntrySubEmotion(
      moodEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mood_entry_id'],
      )!,
      subEmotionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sub_emotion_id'],
      )!,
    );
  }

  @override
  $MoodEntrySubEmotionsTable createAlias(String alias) {
    return $MoodEntrySubEmotionsTable(attachedDatabase, alias);
  }
}

class MoodEntrySubEmotion extends DataClass
    implements Insertable<MoodEntrySubEmotion> {
  final int moodEntryId;
  final int subEmotionId;
  const MoodEntrySubEmotion({
    required this.moodEntryId,
    required this.subEmotionId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['mood_entry_id'] = Variable<int>(moodEntryId);
    map['sub_emotion_id'] = Variable<int>(subEmotionId);
    return map;
  }

  MoodEntrySubEmotionsCompanion toCompanion(bool nullToAbsent) {
    return MoodEntrySubEmotionsCompanion(
      moodEntryId: Value(moodEntryId),
      subEmotionId: Value(subEmotionId),
    );
  }

  factory MoodEntrySubEmotion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MoodEntrySubEmotion(
      moodEntryId: serializer.fromJson<int>(json['moodEntryId']),
      subEmotionId: serializer.fromJson<int>(json['subEmotionId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'moodEntryId': serializer.toJson<int>(moodEntryId),
      'subEmotionId': serializer.toJson<int>(subEmotionId),
    };
  }

  MoodEntrySubEmotion copyWith({int? moodEntryId, int? subEmotionId}) =>
      MoodEntrySubEmotion(
        moodEntryId: moodEntryId ?? this.moodEntryId,
        subEmotionId: subEmotionId ?? this.subEmotionId,
      );
  MoodEntrySubEmotion copyWithCompanion(MoodEntrySubEmotionsCompanion data) {
    return MoodEntrySubEmotion(
      moodEntryId: data.moodEntryId.present
          ? data.moodEntryId.value
          : this.moodEntryId,
      subEmotionId: data.subEmotionId.present
          ? data.subEmotionId.value
          : this.subEmotionId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MoodEntrySubEmotion(')
          ..write('moodEntryId: $moodEntryId, ')
          ..write('subEmotionId: $subEmotionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(moodEntryId, subEmotionId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoodEntrySubEmotion &&
          other.moodEntryId == this.moodEntryId &&
          other.subEmotionId == this.subEmotionId);
}

class MoodEntrySubEmotionsCompanion
    extends UpdateCompanion<MoodEntrySubEmotion> {
  final Value<int> moodEntryId;
  final Value<int> subEmotionId;
  final Value<int> rowid;
  const MoodEntrySubEmotionsCompanion({
    this.moodEntryId = const Value.absent(),
    this.subEmotionId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MoodEntrySubEmotionsCompanion.insert({
    required int moodEntryId,
    required int subEmotionId,
    this.rowid = const Value.absent(),
  }) : moodEntryId = Value(moodEntryId),
       subEmotionId = Value(subEmotionId);
  static Insertable<MoodEntrySubEmotion> custom({
    Expression<int>? moodEntryId,
    Expression<int>? subEmotionId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (moodEntryId != null) 'mood_entry_id': moodEntryId,
      if (subEmotionId != null) 'sub_emotion_id': subEmotionId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MoodEntrySubEmotionsCompanion copyWith({
    Value<int>? moodEntryId,
    Value<int>? subEmotionId,
    Value<int>? rowid,
  }) {
    return MoodEntrySubEmotionsCompanion(
      moodEntryId: moodEntryId ?? this.moodEntryId,
      subEmotionId: subEmotionId ?? this.subEmotionId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (moodEntryId.present) {
      map['mood_entry_id'] = Variable<int>(moodEntryId.value);
    }
    if (subEmotionId.present) {
      map['sub_emotion_id'] = Variable<int>(subEmotionId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoodEntrySubEmotionsCompanion(')
          ..write('moodEntryId: $moodEntryId, ')
          ..write('subEmotionId: $subEmotionId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MoodPhotosTable extends MoodPhotos
    with TableInfo<$MoodPhotosTable, MoodPhoto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoodPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _moodEntryIdMeta = const VerificationMeta(
    'moodEntryId',
  );
  @override
  late final GeneratedColumn<int> moodEntryId = GeneratedColumn<int>(
    'mood_entry_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES mood_entries (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _relativePathMeta = const VerificationMeta(
    'relativePath',
  );
  @override
  late final GeneratedColumn<String> relativePath = GeneratedColumn<String>(
    'relative_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    moodEntryId,
    relativePath,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mood_photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<MoodPhoto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('mood_entry_id')) {
      context.handle(
        _moodEntryIdMeta,
        moodEntryId.isAcceptableOrUnknown(
          data['mood_entry_id']!,
          _moodEntryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_moodEntryIdMeta);
    }
    if (data.containsKey('relative_path')) {
      context.handle(
        _relativePathMeta,
        relativePath.isAcceptableOrUnknown(
          data['relative_path']!,
          _relativePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_relativePathMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MoodPhoto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MoodPhoto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      moodEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mood_entry_id'],
      )!,
      relativePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relative_path'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MoodPhotosTable createAlias(String alias) {
    return $MoodPhotosTable(attachedDatabase, alias);
  }
}

class MoodPhoto extends DataClass implements Insertable<MoodPhoto> {
  final int id;
  final int moodEntryId;

  /// Relative to the app's documents directory, e.g.
  /// `mood_photos/some-uuid.jpg`
  final String relativePath;
  final DateTime createdAt;
  const MoodPhoto({
    required this.id,
    required this.moodEntryId,
    required this.relativePath,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['mood_entry_id'] = Variable<int>(moodEntryId);
    map['relative_path'] = Variable<String>(relativePath);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MoodPhotosCompanion toCompanion(bool nullToAbsent) {
    return MoodPhotosCompanion(
      id: Value(id),
      moodEntryId: Value(moodEntryId),
      relativePath: Value(relativePath),
      createdAt: Value(createdAt),
    );
  }

  factory MoodPhoto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MoodPhoto(
      id: serializer.fromJson<int>(json['id']),
      moodEntryId: serializer.fromJson<int>(json['moodEntryId']),
      relativePath: serializer.fromJson<String>(json['relativePath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'moodEntryId': serializer.toJson<int>(moodEntryId),
      'relativePath': serializer.toJson<String>(relativePath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MoodPhoto copyWith({
    int? id,
    int? moodEntryId,
    String? relativePath,
    DateTime? createdAt,
  }) => MoodPhoto(
    id: id ?? this.id,
    moodEntryId: moodEntryId ?? this.moodEntryId,
    relativePath: relativePath ?? this.relativePath,
    createdAt: createdAt ?? this.createdAt,
  );
  MoodPhoto copyWithCompanion(MoodPhotosCompanion data) {
    return MoodPhoto(
      id: data.id.present ? data.id.value : this.id,
      moodEntryId: data.moodEntryId.present
          ? data.moodEntryId.value
          : this.moodEntryId,
      relativePath: data.relativePath.present
          ? data.relativePath.value
          : this.relativePath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MoodPhoto(')
          ..write('id: $id, ')
          ..write('moodEntryId: $moodEntryId, ')
          ..write('relativePath: $relativePath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, moodEntryId, relativePath, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoodPhoto &&
          other.id == this.id &&
          other.moodEntryId == this.moodEntryId &&
          other.relativePath == this.relativePath &&
          other.createdAt == this.createdAt);
}

class MoodPhotosCompanion extends UpdateCompanion<MoodPhoto> {
  final Value<int> id;
  final Value<int> moodEntryId;
  final Value<String> relativePath;
  final Value<DateTime> createdAt;
  const MoodPhotosCompanion({
    this.id = const Value.absent(),
    this.moodEntryId = const Value.absent(),
    this.relativePath = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MoodPhotosCompanion.insert({
    this.id = const Value.absent(),
    required int moodEntryId,
    required String relativePath,
    required DateTime createdAt,
  }) : moodEntryId = Value(moodEntryId),
       relativePath = Value(relativePath),
       createdAt = Value(createdAt);
  static Insertable<MoodPhoto> custom({
    Expression<int>? id,
    Expression<int>? moodEntryId,
    Expression<String>? relativePath,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (moodEntryId != null) 'mood_entry_id': moodEntryId,
      if (relativePath != null) 'relative_path': relativePath,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MoodPhotosCompanion copyWith({
    Value<int>? id,
    Value<int>? moodEntryId,
    Value<String>? relativePath,
    Value<DateTime>? createdAt,
  }) {
    return MoodPhotosCompanion(
      id: id ?? this.id,
      moodEntryId: moodEntryId ?? this.moodEntryId,
      relativePath: relativePath ?? this.relativePath,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (moodEntryId.present) {
      map['mood_entry_id'] = Variable<int>(moodEntryId.value);
    }
    if (relativePath.present) {
      map['relative_path'] = Variable<String>(relativePath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoodPhotosCompanion(')
          ..write('id: $id, ')
          ..write('moodEntryId: $moodEntryId, ')
          ..write('relativePath: $relativePath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MoodEntriesTable moodEntries = $MoodEntriesTable(this);
  late final $ActivitiesTable activities = $ActivitiesTable(this);
  late final $MoodEntryActivitiesTable moodEntryActivities =
      $MoodEntryActivitiesTable(this);
  late final $SubEmotionsTable subEmotions = $SubEmotionsTable(this);
  late final $MoodEntrySubEmotionsTable moodEntrySubEmotions =
      $MoodEntrySubEmotionsTable(this);
  late final $MoodPhotosTable moodPhotos = $MoodPhotosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    moodEntries,
    activities,
    moodEntryActivities,
    subEmotions,
    moodEntrySubEmotions,
    moodPhotos,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'mood_entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('mood_entry_activities', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'mood_entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('mood_entry_sub_emotions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'sub_emotions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('mood_entry_sub_emotions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'mood_entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('mood_photos', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$MoodEntriesTableCreateCompanionBuilder =
    MoodEntriesCompanion Function({
      Value<int> id,
      required String uuid,
      required int moodScore,
      Value<String?> note,
      Value<String?> voiceNotePath,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> isDeleted,
    });
typedef $$MoodEntriesTableUpdateCompanionBuilder =
    MoodEntriesCompanion Function({
      Value<int> id,
      Value<String> uuid,
      Value<int> moodScore,
      Value<String?> note,
      Value<String?> voiceNotePath,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isDeleted,
    });

final class $$MoodEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $MoodEntriesTable, MoodEntry> {
  $$MoodEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MoodEntryActivitiesTable, List<MoodEntryActivity>>
  _moodEntryActivitiesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.moodEntryActivities,
        aliasName: $_aliasNameGenerator(
          db.moodEntries.id,
          db.moodEntryActivities.moodEntryId,
        ),
      );

  $$MoodEntryActivitiesTableProcessedTableManager get moodEntryActivitiesRefs {
    final manager = $$MoodEntryActivitiesTableTableManager(
      $_db,
      $_db.moodEntryActivities,
    ).filter((f) => f.moodEntryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _moodEntryActivitiesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $MoodEntrySubEmotionsTable,
    List<MoodEntrySubEmotion>
  >
  _moodEntrySubEmotionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.moodEntrySubEmotions,
        aliasName: $_aliasNameGenerator(
          db.moodEntries.id,
          db.moodEntrySubEmotions.moodEntryId,
        ),
      );

  $$MoodEntrySubEmotionsTableProcessedTableManager
  get moodEntrySubEmotionsRefs {
    final manager = $$MoodEntrySubEmotionsTableTableManager(
      $_db,
      $_db.moodEntrySubEmotions,
    ).filter((f) => f.moodEntryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _moodEntrySubEmotionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MoodPhotosTable, List<MoodPhoto>>
  _moodPhotosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.moodPhotos,
    aliasName: $_aliasNameGenerator(
      db.moodEntries.id,
      db.moodPhotos.moodEntryId,
    ),
  );

  $$MoodPhotosTableProcessedTableManager get moodPhotosRefs {
    final manager = $$MoodPhotosTableTableManager(
      $_db,
      $_db.moodPhotos,
    ).filter((f) => f.moodEntryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_moodPhotosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MoodEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $MoodEntriesTable> {
  $$MoodEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get moodScore => $composableBuilder(
    column: $table.moodScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get voiceNotePath => $composableBuilder(
    column: $table.voiceNotePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> moodEntryActivitiesRefs(
    Expression<bool> Function($$MoodEntryActivitiesTableFilterComposer f) f,
  ) {
    final $$MoodEntryActivitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.moodEntryActivities,
      getReferencedColumn: (t) => t.moodEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoodEntryActivitiesTableFilterComposer(
            $db: $db,
            $table: $db.moodEntryActivities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> moodEntrySubEmotionsRefs(
    Expression<bool> Function($$MoodEntrySubEmotionsTableFilterComposer f) f,
  ) {
    final $$MoodEntrySubEmotionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.moodEntrySubEmotions,
      getReferencedColumn: (t) => t.moodEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoodEntrySubEmotionsTableFilterComposer(
            $db: $db,
            $table: $db.moodEntrySubEmotions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> moodPhotosRefs(
    Expression<bool> Function($$MoodPhotosTableFilterComposer f) f,
  ) {
    final $$MoodPhotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.moodPhotos,
      getReferencedColumn: (t) => t.moodEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoodPhotosTableFilterComposer(
            $db: $db,
            $table: $db.moodPhotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MoodEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $MoodEntriesTable> {
  $$MoodEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get moodScore => $composableBuilder(
    column: $table.moodScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get voiceNotePath => $composableBuilder(
    column: $table.voiceNotePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MoodEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MoodEntriesTable> {
  $$MoodEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<int> get moodScore =>
      $composableBuilder(column: $table.moodScore, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get voiceNotePath => $composableBuilder(
    column: $table.voiceNotePath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  Expression<T> moodEntryActivitiesRefs<T extends Object>(
    Expression<T> Function($$MoodEntryActivitiesTableAnnotationComposer a) f,
  ) {
    final $$MoodEntryActivitiesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.moodEntryActivities,
          getReferencedColumn: (t) => t.moodEntryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MoodEntryActivitiesTableAnnotationComposer(
                $db: $db,
                $table: $db.moodEntryActivities,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> moodEntrySubEmotionsRefs<T extends Object>(
    Expression<T> Function($$MoodEntrySubEmotionsTableAnnotationComposer a) f,
  ) {
    final $$MoodEntrySubEmotionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.moodEntrySubEmotions,
          getReferencedColumn: (t) => t.moodEntryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MoodEntrySubEmotionsTableAnnotationComposer(
                $db: $db,
                $table: $db.moodEntrySubEmotions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> moodPhotosRefs<T extends Object>(
    Expression<T> Function($$MoodPhotosTableAnnotationComposer a) f,
  ) {
    final $$MoodPhotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.moodPhotos,
      getReferencedColumn: (t) => t.moodEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoodPhotosTableAnnotationComposer(
            $db: $db,
            $table: $db.moodPhotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MoodEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MoodEntriesTable,
          MoodEntry,
          $$MoodEntriesTableFilterComposer,
          $$MoodEntriesTableOrderingComposer,
          $$MoodEntriesTableAnnotationComposer,
          $$MoodEntriesTableCreateCompanionBuilder,
          $$MoodEntriesTableUpdateCompanionBuilder,
          (MoodEntry, $$MoodEntriesTableReferences),
          MoodEntry,
          PrefetchHooks Function({
            bool moodEntryActivitiesRefs,
            bool moodEntrySubEmotionsRefs,
            bool moodPhotosRefs,
          })
        > {
  $$MoodEntriesTableTableManager(_$AppDatabase db, $MoodEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MoodEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MoodEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MoodEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<int> moodScore = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> voiceNotePath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => MoodEntriesCompanion(
                id: id,
                uuid: uuid,
                moodScore: moodScore,
                note: note,
                voiceNotePath: voiceNotePath,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String uuid,
                required int moodScore,
                Value<String?> note = const Value.absent(),
                Value<String?> voiceNotePath = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> isDeleted = const Value.absent(),
              }) => MoodEntriesCompanion.insert(
                id: id,
                uuid: uuid,
                moodScore: moodScore,
                note: note,
                voiceNotePath: voiceNotePath,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MoodEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                moodEntryActivitiesRefs = false,
                moodEntrySubEmotionsRefs = false,
                moodPhotosRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (moodEntryActivitiesRefs) db.moodEntryActivities,
                    if (moodEntrySubEmotionsRefs) db.moodEntrySubEmotions,
                    if (moodPhotosRefs) db.moodPhotos,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (moodEntryActivitiesRefs)
                        await $_getPrefetchedData<
                          MoodEntry,
                          $MoodEntriesTable,
                          MoodEntryActivity
                        >(
                          currentTable: table,
                          referencedTable: $$MoodEntriesTableReferences
                              ._moodEntryActivitiesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MoodEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).moodEntryActivitiesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.moodEntryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (moodEntrySubEmotionsRefs)
                        await $_getPrefetchedData<
                          MoodEntry,
                          $MoodEntriesTable,
                          MoodEntrySubEmotion
                        >(
                          currentTable: table,
                          referencedTable: $$MoodEntriesTableReferences
                              ._moodEntrySubEmotionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MoodEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).moodEntrySubEmotionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.moodEntryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (moodPhotosRefs)
                        await $_getPrefetchedData<
                          MoodEntry,
                          $MoodEntriesTable,
                          MoodPhoto
                        >(
                          currentTable: table,
                          referencedTable: $$MoodEntriesTableReferences
                              ._moodPhotosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MoodEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).moodPhotosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.moodEntryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MoodEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MoodEntriesTable,
      MoodEntry,
      $$MoodEntriesTableFilterComposer,
      $$MoodEntriesTableOrderingComposer,
      $$MoodEntriesTableAnnotationComposer,
      $$MoodEntriesTableCreateCompanionBuilder,
      $$MoodEntriesTableUpdateCompanionBuilder,
      (MoodEntry, $$MoodEntriesTableReferences),
      MoodEntry,
      PrefetchHooks Function({
        bool moodEntryActivitiesRefs,
        bool moodEntrySubEmotionsRefs,
        bool moodPhotosRefs,
      })
    >;
typedef $$ActivitiesTableCreateCompanionBuilder =
    ActivitiesCompanion Function({
      Value<int> id,
      required String uuid,
      required String name,
      required String category,
      Value<bool> isCustom,
      Value<bool> isArchived,
      required DateTime createdAt,
    });
typedef $$ActivitiesTableUpdateCompanionBuilder =
    ActivitiesCompanion Function({
      Value<int> id,
      Value<String> uuid,
      Value<String> name,
      Value<String> category,
      Value<bool> isCustom,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
    });

final class $$ActivitiesTableReferences
    extends BaseReferences<_$AppDatabase, $ActivitiesTable, Activity> {
  $$ActivitiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MoodEntryActivitiesTable, List<MoodEntryActivity>>
  _moodEntryActivitiesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.moodEntryActivities,
        aliasName: $_aliasNameGenerator(
          db.activities.id,
          db.moodEntryActivities.activityId,
        ),
      );

  $$MoodEntryActivitiesTableProcessedTableManager get moodEntryActivitiesRefs {
    final manager = $$MoodEntryActivitiesTableTableManager(
      $_db,
      $_db.moodEntryActivities,
    ).filter((f) => f.activityId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _moodEntryActivitiesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ActivitiesTableFilterComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> moodEntryActivitiesRefs(
    Expression<bool> Function($$MoodEntryActivitiesTableFilterComposer f) f,
  ) {
    final $$MoodEntryActivitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.moodEntryActivities,
      getReferencedColumn: (t) => t.activityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoodEntryActivitiesTableFilterComposer(
            $db: $db,
            $table: $db.moodEntryActivities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ActivitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> moodEntryActivitiesRefs<T extends Object>(
    Expression<T> Function($$MoodEntryActivitiesTableAnnotationComposer a) f,
  ) {
    final $$MoodEntryActivitiesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.moodEntryActivities,
          getReferencedColumn: (t) => t.activityId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MoodEntryActivitiesTableAnnotationComposer(
                $db: $db,
                $table: $db.moodEntryActivities,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ActivitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivitiesTable,
          Activity,
          $$ActivitiesTableFilterComposer,
          $$ActivitiesTableOrderingComposer,
          $$ActivitiesTableAnnotationComposer,
          $$ActivitiesTableCreateCompanionBuilder,
          $$ActivitiesTableUpdateCompanionBuilder,
          (Activity, $$ActivitiesTableReferences),
          Activity,
          PrefetchHooks Function({bool moodEntryActivitiesRefs})
        > {
  $$ActivitiesTableTableManager(_$AppDatabase db, $ActivitiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ActivitiesCompanion(
                id: id,
                uuid: uuid,
                name: name,
                category: category,
                isCustom: isCustom,
                isArchived: isArchived,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String uuid,
                required String name,
                required String category,
                Value<bool> isCustom = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                required DateTime createdAt,
              }) => ActivitiesCompanion.insert(
                id: id,
                uuid: uuid,
                name: name,
                category: category,
                isCustom: isCustom,
                isArchived: isArchived,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ActivitiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({moodEntryActivitiesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (moodEntryActivitiesRefs) db.moodEntryActivities,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (moodEntryActivitiesRefs)
                    await $_getPrefetchedData<
                      Activity,
                      $ActivitiesTable,
                      MoodEntryActivity
                    >(
                      currentTable: table,
                      referencedTable: $$ActivitiesTableReferences
                          ._moodEntryActivitiesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ActivitiesTableReferences(
                            db,
                            table,
                            p0,
                          ).moodEntryActivitiesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.activityId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ActivitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivitiesTable,
      Activity,
      $$ActivitiesTableFilterComposer,
      $$ActivitiesTableOrderingComposer,
      $$ActivitiesTableAnnotationComposer,
      $$ActivitiesTableCreateCompanionBuilder,
      $$ActivitiesTableUpdateCompanionBuilder,
      (Activity, $$ActivitiesTableReferences),
      Activity,
      PrefetchHooks Function({bool moodEntryActivitiesRefs})
    >;
typedef $$MoodEntryActivitiesTableCreateCompanionBuilder =
    MoodEntryActivitiesCompanion Function({
      required int moodEntryId,
      required int activityId,
      Value<int> rowid,
    });
typedef $$MoodEntryActivitiesTableUpdateCompanionBuilder =
    MoodEntryActivitiesCompanion Function({
      Value<int> moodEntryId,
      Value<int> activityId,
      Value<int> rowid,
    });

final class $$MoodEntryActivitiesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MoodEntryActivitiesTable,
          MoodEntryActivity
        > {
  $$MoodEntryActivitiesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MoodEntriesTable _moodEntryIdTable(_$AppDatabase db) =>
      db.moodEntries.createAlias(
        $_aliasNameGenerator(
          db.moodEntryActivities.moodEntryId,
          db.moodEntries.id,
        ),
      );

  $$MoodEntriesTableProcessedTableManager get moodEntryId {
    final $_column = $_itemColumn<int>('mood_entry_id')!;

    final manager = $$MoodEntriesTableTableManager(
      $_db,
      $_db.moodEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_moodEntryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ActivitiesTable _activityIdTable(_$AppDatabase db) =>
      db.activities.createAlias(
        $_aliasNameGenerator(
          db.moodEntryActivities.activityId,
          db.activities.id,
        ),
      );

  $$ActivitiesTableProcessedTableManager get activityId {
    final $_column = $_itemColumn<int>('activity_id')!;

    final manager = $$ActivitiesTableTableManager(
      $_db,
      $_db.activities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_activityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MoodEntryActivitiesTableFilterComposer
    extends Composer<_$AppDatabase, $MoodEntryActivitiesTable> {
  $$MoodEntryActivitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MoodEntriesTableFilterComposer get moodEntryId {
    final $$MoodEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.moodEntryId,
      referencedTable: $db.moodEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoodEntriesTableFilterComposer(
            $db: $db,
            $table: $db.moodEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ActivitiesTableFilterComposer get activityId {
    final $$ActivitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableFilterComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MoodEntryActivitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $MoodEntryActivitiesTable> {
  $$MoodEntryActivitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MoodEntriesTableOrderingComposer get moodEntryId {
    final $$MoodEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.moodEntryId,
      referencedTable: $db.moodEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoodEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.moodEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ActivitiesTableOrderingComposer get activityId {
    final $$ActivitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableOrderingComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MoodEntryActivitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MoodEntryActivitiesTable> {
  $$MoodEntryActivitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MoodEntriesTableAnnotationComposer get moodEntryId {
    final $$MoodEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.moodEntryId,
      referencedTable: $db.moodEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoodEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.moodEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ActivitiesTableAnnotationComposer get activityId {
    final $$ActivitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MoodEntryActivitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MoodEntryActivitiesTable,
          MoodEntryActivity,
          $$MoodEntryActivitiesTableFilterComposer,
          $$MoodEntryActivitiesTableOrderingComposer,
          $$MoodEntryActivitiesTableAnnotationComposer,
          $$MoodEntryActivitiesTableCreateCompanionBuilder,
          $$MoodEntryActivitiesTableUpdateCompanionBuilder,
          (MoodEntryActivity, $$MoodEntryActivitiesTableReferences),
          MoodEntryActivity,
          PrefetchHooks Function({bool moodEntryId, bool activityId})
        > {
  $$MoodEntryActivitiesTableTableManager(
    _$AppDatabase db,
    $MoodEntryActivitiesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MoodEntryActivitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MoodEntryActivitiesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MoodEntryActivitiesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> moodEntryId = const Value.absent(),
                Value<int> activityId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MoodEntryActivitiesCompanion(
                moodEntryId: moodEntryId,
                activityId: activityId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int moodEntryId,
                required int activityId,
                Value<int> rowid = const Value.absent(),
              }) => MoodEntryActivitiesCompanion.insert(
                moodEntryId: moodEntryId,
                activityId: activityId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MoodEntryActivitiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({moodEntryId = false, activityId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (moodEntryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.moodEntryId,
                                referencedTable:
                                    $$MoodEntryActivitiesTableReferences
                                        ._moodEntryIdTable(db),
                                referencedColumn:
                                    $$MoodEntryActivitiesTableReferences
                                        ._moodEntryIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (activityId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.activityId,
                                referencedTable:
                                    $$MoodEntryActivitiesTableReferences
                                        ._activityIdTable(db),
                                referencedColumn:
                                    $$MoodEntryActivitiesTableReferences
                                        ._activityIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MoodEntryActivitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MoodEntryActivitiesTable,
      MoodEntryActivity,
      $$MoodEntryActivitiesTableFilterComposer,
      $$MoodEntryActivitiesTableOrderingComposer,
      $$MoodEntryActivitiesTableAnnotationComposer,
      $$MoodEntryActivitiesTableCreateCompanionBuilder,
      $$MoodEntryActivitiesTableUpdateCompanionBuilder,
      (MoodEntryActivity, $$MoodEntryActivitiesTableReferences),
      MoodEntryActivity,
      PrefetchHooks Function({bool moodEntryId, bool activityId})
    >;
typedef $$SubEmotionsTableCreateCompanionBuilder =
    SubEmotionsCompanion Function({
      Value<int> id,
      required String name,
      required String emoji,
      required int parentMoodScore,
    });
typedef $$SubEmotionsTableUpdateCompanionBuilder =
    SubEmotionsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> emoji,
      Value<int> parentMoodScore,
    });

final class $$SubEmotionsTableReferences
    extends BaseReferences<_$AppDatabase, $SubEmotionsTable, SubEmotion> {
  $$SubEmotionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $MoodEntrySubEmotionsTable,
    List<MoodEntrySubEmotion>
  >
  _moodEntrySubEmotionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.moodEntrySubEmotions,
        aliasName: $_aliasNameGenerator(
          db.subEmotions.id,
          db.moodEntrySubEmotions.subEmotionId,
        ),
      );

  $$MoodEntrySubEmotionsTableProcessedTableManager
  get moodEntrySubEmotionsRefs {
    final manager = $$MoodEntrySubEmotionsTableTableManager(
      $_db,
      $_db.moodEntrySubEmotions,
    ).filter((f) => f.subEmotionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _moodEntrySubEmotionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SubEmotionsTableFilterComposer
    extends Composer<_$AppDatabase, $SubEmotionsTable> {
  $$SubEmotionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get parentMoodScore => $composableBuilder(
    column: $table.parentMoodScore,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> moodEntrySubEmotionsRefs(
    Expression<bool> Function($$MoodEntrySubEmotionsTableFilterComposer f) f,
  ) {
    final $$MoodEntrySubEmotionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.moodEntrySubEmotions,
      getReferencedColumn: (t) => t.subEmotionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoodEntrySubEmotionsTableFilterComposer(
            $db: $db,
            $table: $db.moodEntrySubEmotions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SubEmotionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubEmotionsTable> {
  $$SubEmotionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get parentMoodScore => $composableBuilder(
    column: $table.parentMoodScore,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SubEmotionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubEmotionsTable> {
  $$SubEmotionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<int> get parentMoodScore => $composableBuilder(
    column: $table.parentMoodScore,
    builder: (column) => column,
  );

  Expression<T> moodEntrySubEmotionsRefs<T extends Object>(
    Expression<T> Function($$MoodEntrySubEmotionsTableAnnotationComposer a) f,
  ) {
    final $$MoodEntrySubEmotionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.moodEntrySubEmotions,
          getReferencedColumn: (t) => t.subEmotionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MoodEntrySubEmotionsTableAnnotationComposer(
                $db: $db,
                $table: $db.moodEntrySubEmotions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$SubEmotionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubEmotionsTable,
          SubEmotion,
          $$SubEmotionsTableFilterComposer,
          $$SubEmotionsTableOrderingComposer,
          $$SubEmotionsTableAnnotationComposer,
          $$SubEmotionsTableCreateCompanionBuilder,
          $$SubEmotionsTableUpdateCompanionBuilder,
          (SubEmotion, $$SubEmotionsTableReferences),
          SubEmotion,
          PrefetchHooks Function({bool moodEntrySubEmotionsRefs})
        > {
  $$SubEmotionsTableTableManager(_$AppDatabase db, $SubEmotionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubEmotionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubEmotionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubEmotionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> emoji = const Value.absent(),
                Value<int> parentMoodScore = const Value.absent(),
              }) => SubEmotionsCompanion(
                id: id,
                name: name,
                emoji: emoji,
                parentMoodScore: parentMoodScore,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String emoji,
                required int parentMoodScore,
              }) => SubEmotionsCompanion.insert(
                id: id,
                name: name,
                emoji: emoji,
                parentMoodScore: parentMoodScore,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SubEmotionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({moodEntrySubEmotionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (moodEntrySubEmotionsRefs) db.moodEntrySubEmotions,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (moodEntrySubEmotionsRefs)
                    await $_getPrefetchedData<
                      SubEmotion,
                      $SubEmotionsTable,
                      MoodEntrySubEmotion
                    >(
                      currentTable: table,
                      referencedTable: $$SubEmotionsTableReferences
                          ._moodEntrySubEmotionsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SubEmotionsTableReferences(
                            db,
                            table,
                            p0,
                          ).moodEntrySubEmotionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.subEmotionId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SubEmotionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubEmotionsTable,
      SubEmotion,
      $$SubEmotionsTableFilterComposer,
      $$SubEmotionsTableOrderingComposer,
      $$SubEmotionsTableAnnotationComposer,
      $$SubEmotionsTableCreateCompanionBuilder,
      $$SubEmotionsTableUpdateCompanionBuilder,
      (SubEmotion, $$SubEmotionsTableReferences),
      SubEmotion,
      PrefetchHooks Function({bool moodEntrySubEmotionsRefs})
    >;
typedef $$MoodEntrySubEmotionsTableCreateCompanionBuilder =
    MoodEntrySubEmotionsCompanion Function({
      required int moodEntryId,
      required int subEmotionId,
      Value<int> rowid,
    });
typedef $$MoodEntrySubEmotionsTableUpdateCompanionBuilder =
    MoodEntrySubEmotionsCompanion Function({
      Value<int> moodEntryId,
      Value<int> subEmotionId,
      Value<int> rowid,
    });

final class $$MoodEntrySubEmotionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MoodEntrySubEmotionsTable,
          MoodEntrySubEmotion
        > {
  $$MoodEntrySubEmotionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MoodEntriesTable _moodEntryIdTable(_$AppDatabase db) =>
      db.moodEntries.createAlias(
        $_aliasNameGenerator(
          db.moodEntrySubEmotions.moodEntryId,
          db.moodEntries.id,
        ),
      );

  $$MoodEntriesTableProcessedTableManager get moodEntryId {
    final $_column = $_itemColumn<int>('mood_entry_id')!;

    final manager = $$MoodEntriesTableTableManager(
      $_db,
      $_db.moodEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_moodEntryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SubEmotionsTable _subEmotionIdTable(_$AppDatabase db) =>
      db.subEmotions.createAlias(
        $_aliasNameGenerator(
          db.moodEntrySubEmotions.subEmotionId,
          db.subEmotions.id,
        ),
      );

  $$SubEmotionsTableProcessedTableManager get subEmotionId {
    final $_column = $_itemColumn<int>('sub_emotion_id')!;

    final manager = $$SubEmotionsTableTableManager(
      $_db,
      $_db.subEmotions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subEmotionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MoodEntrySubEmotionsTableFilterComposer
    extends Composer<_$AppDatabase, $MoodEntrySubEmotionsTable> {
  $$MoodEntrySubEmotionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MoodEntriesTableFilterComposer get moodEntryId {
    final $$MoodEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.moodEntryId,
      referencedTable: $db.moodEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoodEntriesTableFilterComposer(
            $db: $db,
            $table: $db.moodEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SubEmotionsTableFilterComposer get subEmotionId {
    final $$SubEmotionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subEmotionId,
      referencedTable: $db.subEmotions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubEmotionsTableFilterComposer(
            $db: $db,
            $table: $db.subEmotions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MoodEntrySubEmotionsTableOrderingComposer
    extends Composer<_$AppDatabase, $MoodEntrySubEmotionsTable> {
  $$MoodEntrySubEmotionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MoodEntriesTableOrderingComposer get moodEntryId {
    final $$MoodEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.moodEntryId,
      referencedTable: $db.moodEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoodEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.moodEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SubEmotionsTableOrderingComposer get subEmotionId {
    final $$SubEmotionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subEmotionId,
      referencedTable: $db.subEmotions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubEmotionsTableOrderingComposer(
            $db: $db,
            $table: $db.subEmotions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MoodEntrySubEmotionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MoodEntrySubEmotionsTable> {
  $$MoodEntrySubEmotionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$MoodEntriesTableAnnotationComposer get moodEntryId {
    final $$MoodEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.moodEntryId,
      referencedTable: $db.moodEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoodEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.moodEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SubEmotionsTableAnnotationComposer get subEmotionId {
    final $$SubEmotionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subEmotionId,
      referencedTable: $db.subEmotions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubEmotionsTableAnnotationComposer(
            $db: $db,
            $table: $db.subEmotions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MoodEntrySubEmotionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MoodEntrySubEmotionsTable,
          MoodEntrySubEmotion,
          $$MoodEntrySubEmotionsTableFilterComposer,
          $$MoodEntrySubEmotionsTableOrderingComposer,
          $$MoodEntrySubEmotionsTableAnnotationComposer,
          $$MoodEntrySubEmotionsTableCreateCompanionBuilder,
          $$MoodEntrySubEmotionsTableUpdateCompanionBuilder,
          (MoodEntrySubEmotion, $$MoodEntrySubEmotionsTableReferences),
          MoodEntrySubEmotion,
          PrefetchHooks Function({bool moodEntryId, bool subEmotionId})
        > {
  $$MoodEntrySubEmotionsTableTableManager(
    _$AppDatabase db,
    $MoodEntrySubEmotionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MoodEntrySubEmotionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MoodEntrySubEmotionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MoodEntrySubEmotionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> moodEntryId = const Value.absent(),
                Value<int> subEmotionId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MoodEntrySubEmotionsCompanion(
                moodEntryId: moodEntryId,
                subEmotionId: subEmotionId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int moodEntryId,
                required int subEmotionId,
                Value<int> rowid = const Value.absent(),
              }) => MoodEntrySubEmotionsCompanion.insert(
                moodEntryId: moodEntryId,
                subEmotionId: subEmotionId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MoodEntrySubEmotionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({moodEntryId = false, subEmotionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (moodEntryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.moodEntryId,
                                referencedTable:
                                    $$MoodEntrySubEmotionsTableReferences
                                        ._moodEntryIdTable(db),
                                referencedColumn:
                                    $$MoodEntrySubEmotionsTableReferences
                                        ._moodEntryIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (subEmotionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.subEmotionId,
                                referencedTable:
                                    $$MoodEntrySubEmotionsTableReferences
                                        ._subEmotionIdTable(db),
                                referencedColumn:
                                    $$MoodEntrySubEmotionsTableReferences
                                        ._subEmotionIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MoodEntrySubEmotionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MoodEntrySubEmotionsTable,
      MoodEntrySubEmotion,
      $$MoodEntrySubEmotionsTableFilterComposer,
      $$MoodEntrySubEmotionsTableOrderingComposer,
      $$MoodEntrySubEmotionsTableAnnotationComposer,
      $$MoodEntrySubEmotionsTableCreateCompanionBuilder,
      $$MoodEntrySubEmotionsTableUpdateCompanionBuilder,
      (MoodEntrySubEmotion, $$MoodEntrySubEmotionsTableReferences),
      MoodEntrySubEmotion,
      PrefetchHooks Function({bool moodEntryId, bool subEmotionId})
    >;
typedef $$MoodPhotosTableCreateCompanionBuilder =
    MoodPhotosCompanion Function({
      Value<int> id,
      required int moodEntryId,
      required String relativePath,
      required DateTime createdAt,
    });
typedef $$MoodPhotosTableUpdateCompanionBuilder =
    MoodPhotosCompanion Function({
      Value<int> id,
      Value<int> moodEntryId,
      Value<String> relativePath,
      Value<DateTime> createdAt,
    });

final class $$MoodPhotosTableReferences
    extends BaseReferences<_$AppDatabase, $MoodPhotosTable, MoodPhoto> {
  $$MoodPhotosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MoodEntriesTable _moodEntryIdTable(_$AppDatabase db) =>
      db.moodEntries.createAlias(
        $_aliasNameGenerator(db.moodPhotos.moodEntryId, db.moodEntries.id),
      );

  $$MoodEntriesTableProcessedTableManager get moodEntryId {
    final $_column = $_itemColumn<int>('mood_entry_id')!;

    final manager = $$MoodEntriesTableTableManager(
      $_db,
      $_db.moodEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_moodEntryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MoodPhotosTableFilterComposer
    extends Composer<_$AppDatabase, $MoodPhotosTable> {
  $$MoodPhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MoodEntriesTableFilterComposer get moodEntryId {
    final $$MoodEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.moodEntryId,
      referencedTable: $db.moodEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoodEntriesTableFilterComposer(
            $db: $db,
            $table: $db.moodEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MoodPhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $MoodPhotosTable> {
  $$MoodPhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MoodEntriesTableOrderingComposer get moodEntryId {
    final $$MoodEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.moodEntryId,
      referencedTable: $db.moodEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoodEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.moodEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MoodPhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $MoodPhotosTable> {
  $$MoodPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MoodEntriesTableAnnotationComposer get moodEntryId {
    final $$MoodEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.moodEntryId,
      referencedTable: $db.moodEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MoodEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.moodEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MoodPhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MoodPhotosTable,
          MoodPhoto,
          $$MoodPhotosTableFilterComposer,
          $$MoodPhotosTableOrderingComposer,
          $$MoodPhotosTableAnnotationComposer,
          $$MoodPhotosTableCreateCompanionBuilder,
          $$MoodPhotosTableUpdateCompanionBuilder,
          (MoodPhoto, $$MoodPhotosTableReferences),
          MoodPhoto,
          PrefetchHooks Function({bool moodEntryId})
        > {
  $$MoodPhotosTableTableManager(_$AppDatabase db, $MoodPhotosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MoodPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MoodPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MoodPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> moodEntryId = const Value.absent(),
                Value<String> relativePath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MoodPhotosCompanion(
                id: id,
                moodEntryId: moodEntryId,
                relativePath: relativePath,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int moodEntryId,
                required String relativePath,
                required DateTime createdAt,
              }) => MoodPhotosCompanion.insert(
                id: id,
                moodEntryId: moodEntryId,
                relativePath: relativePath,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MoodPhotosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({moodEntryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (moodEntryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.moodEntryId,
                                referencedTable: $$MoodPhotosTableReferences
                                    ._moodEntryIdTable(db),
                                referencedColumn: $$MoodPhotosTableReferences
                                    ._moodEntryIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MoodPhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MoodPhotosTable,
      MoodPhoto,
      $$MoodPhotosTableFilterComposer,
      $$MoodPhotosTableOrderingComposer,
      $$MoodPhotosTableAnnotationComposer,
      $$MoodPhotosTableCreateCompanionBuilder,
      $$MoodPhotosTableUpdateCompanionBuilder,
      (MoodPhoto, $$MoodPhotosTableReferences),
      MoodPhoto,
      PrefetchHooks Function({bool moodEntryId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MoodEntriesTableTableManager get moodEntries =>
      $$MoodEntriesTableTableManager(_db, _db.moodEntries);
  $$ActivitiesTableTableManager get activities =>
      $$ActivitiesTableTableManager(_db, _db.activities);
  $$MoodEntryActivitiesTableTableManager get moodEntryActivities =>
      $$MoodEntryActivitiesTableTableManager(_db, _db.moodEntryActivities);
  $$SubEmotionsTableTableManager get subEmotions =>
      $$SubEmotionsTableTableManager(_db, _db.subEmotions);
  $$MoodEntrySubEmotionsTableTableManager get moodEntrySubEmotions =>
      $$MoodEntrySubEmotionsTableTableManager(_db, _db.moodEntrySubEmotions);
  $$MoodPhotosTableTableManager get moodPhotos =>
      $$MoodPhotosTableTableManager(_db, _db.moodPhotos);
}
