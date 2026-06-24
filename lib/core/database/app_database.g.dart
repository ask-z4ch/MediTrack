// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
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
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateOfBirthMeta = const VerificationMeta(
    'dateOfBirth',
  );
  @override
  late final GeneratedColumn<DateTime> dateOfBirth = GeneratedColumn<DateTime>(
    'date_of_birth',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bloodGroupMeta = const VerificationMeta(
    'bloodGroup',
  );
  @override
  late final GeneratedColumn<String> bloodGroup = GeneratedColumn<String>(
    'blood_group',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeConditionsMeta = const VerificationMeta(
    'activeConditions',
  );
  @override
  late final GeneratedColumn<String> activeConditions = GeneratedColumn<String>(
    'active_conditions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _allergiesMeta = const VerificationMeta(
    'allergies',
  );
  @override
  late final GeneratedColumn<String> allergies = GeneratedColumn<String>(
    'allergies',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _emergencyContactNameMeta =
      const VerificationMeta('emergencyContactName');
  @override
  late final GeneratedColumn<String> emergencyContactName =
      GeneratedColumn<String>(
        'emergency_contact_name',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _emergencyContactPhoneMeta =
      const VerificationMeta('emergencyContactPhone');
  @override
  late final GeneratedColumn<String> emergencyContactPhone =
      GeneratedColumn<String>(
        'emergency_contact_phone',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _emergencyContactRelationMeta =
      const VerificationMeta('emergencyContactRelation');
  @override
  late final GeneratedColumn<String> emergencyContactRelation =
      GeneratedColumn<String>(
        'emergency_contact_relation',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    dateOfBirth,
    bloodGroup,
    activeConditions,
    allergies,
    emergencyContactName,
    emergencyContactPhone,
    emergencyContactRelation,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfile> instance, {
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
    if (data.containsKey('date_of_birth')) {
      context.handle(
        _dateOfBirthMeta,
        dateOfBirth.isAcceptableOrUnknown(
          data['date_of_birth']!,
          _dateOfBirthMeta,
        ),
      );
    }
    if (data.containsKey('blood_group')) {
      context.handle(
        _bloodGroupMeta,
        bloodGroup.isAcceptableOrUnknown(data['blood_group']!, _bloodGroupMeta),
      );
    }
    if (data.containsKey('active_conditions')) {
      context.handle(
        _activeConditionsMeta,
        activeConditions.isAcceptableOrUnknown(
          data['active_conditions']!,
          _activeConditionsMeta,
        ),
      );
    }
    if (data.containsKey('allergies')) {
      context.handle(
        _allergiesMeta,
        allergies.isAcceptableOrUnknown(data['allergies']!, _allergiesMeta),
      );
    }
    if (data.containsKey('emergency_contact_name')) {
      context.handle(
        _emergencyContactNameMeta,
        emergencyContactName.isAcceptableOrUnknown(
          data['emergency_contact_name']!,
          _emergencyContactNameMeta,
        ),
      );
    }
    if (data.containsKey('emergency_contact_phone')) {
      context.handle(
        _emergencyContactPhoneMeta,
        emergencyContactPhone.isAcceptableOrUnknown(
          data['emergency_contact_phone']!,
          _emergencyContactPhoneMeta,
        ),
      );
    }
    if (data.containsKey('emergency_contact_relation')) {
      context.handle(
        _emergencyContactRelationMeta,
        emergencyContactRelation.isAcceptableOrUnknown(
          data['emergency_contact_relation']!,
          _emergencyContactRelationMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      dateOfBirth: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_of_birth'],
      ),
      bloodGroup: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}blood_group'],
      ),
      activeConditions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}active_conditions'],
      )!,
      allergies: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allergies'],
      )!,
      emergencyContactName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emergency_contact_name'],
      ),
      emergencyContactPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emergency_contact_phone'],
      ),
      emergencyContactRelation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emergency_contact_relation'],
      ),
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  final int id;
  final String name;
  final DateTime? dateOfBirth;
  final String? bloodGroup;
  final String activeConditions;
  final String allergies;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? emergencyContactRelation;
  const UserProfile({
    required this.id,
    required this.name,
    this.dateOfBirth,
    this.bloodGroup,
    required this.activeConditions,
    required this.allergies,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.emergencyContactRelation,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || dateOfBirth != null) {
      map['date_of_birth'] = Variable<DateTime>(dateOfBirth);
    }
    if (!nullToAbsent || bloodGroup != null) {
      map['blood_group'] = Variable<String>(bloodGroup);
    }
    map['active_conditions'] = Variable<String>(activeConditions);
    map['allergies'] = Variable<String>(allergies);
    if (!nullToAbsent || emergencyContactName != null) {
      map['emergency_contact_name'] = Variable<String>(emergencyContactName);
    }
    if (!nullToAbsent || emergencyContactPhone != null) {
      map['emergency_contact_phone'] = Variable<String>(emergencyContactPhone);
    }
    if (!nullToAbsent || emergencyContactRelation != null) {
      map['emergency_contact_relation'] = Variable<String>(
        emergencyContactRelation,
      );
    }
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      name: Value(name),
      dateOfBirth: dateOfBirth == null && nullToAbsent
          ? const Value.absent()
          : Value(dateOfBirth),
      bloodGroup: bloodGroup == null && nullToAbsent
          ? const Value.absent()
          : Value(bloodGroup),
      activeConditions: Value(activeConditions),
      allergies: Value(allergies),
      emergencyContactName: emergencyContactName == null && nullToAbsent
          ? const Value.absent()
          : Value(emergencyContactName),
      emergencyContactPhone: emergencyContactPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(emergencyContactPhone),
      emergencyContactRelation: emergencyContactRelation == null && nullToAbsent
          ? const Value.absent()
          : Value(emergencyContactRelation),
    );
  }

  factory UserProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      dateOfBirth: serializer.fromJson<DateTime?>(json['dateOfBirth']),
      bloodGroup: serializer.fromJson<String?>(json['bloodGroup']),
      activeConditions: serializer.fromJson<String>(json['activeConditions']),
      allergies: serializer.fromJson<String>(json['allergies']),
      emergencyContactName: serializer.fromJson<String?>(
        json['emergencyContactName'],
      ),
      emergencyContactPhone: serializer.fromJson<String?>(
        json['emergencyContactPhone'],
      ),
      emergencyContactRelation: serializer.fromJson<String?>(
        json['emergencyContactRelation'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'dateOfBirth': serializer.toJson<DateTime?>(dateOfBirth),
      'bloodGroup': serializer.toJson<String?>(bloodGroup),
      'activeConditions': serializer.toJson<String>(activeConditions),
      'allergies': serializer.toJson<String>(allergies),
      'emergencyContactName': serializer.toJson<String?>(emergencyContactName),
      'emergencyContactPhone': serializer.toJson<String?>(
        emergencyContactPhone,
      ),
      'emergencyContactRelation': serializer.toJson<String?>(
        emergencyContactRelation,
      ),
    };
  }

  UserProfile copyWith({
    int? id,
    String? name,
    Value<DateTime?> dateOfBirth = const Value.absent(),
    Value<String?> bloodGroup = const Value.absent(),
    String? activeConditions,
    String? allergies,
    Value<String?> emergencyContactName = const Value.absent(),
    Value<String?> emergencyContactPhone = const Value.absent(),
    Value<String?> emergencyContactRelation = const Value.absent(),
  }) => UserProfile(
    id: id ?? this.id,
    name: name ?? this.name,
    dateOfBirth: dateOfBirth.present ? dateOfBirth.value : this.dateOfBirth,
    bloodGroup: bloodGroup.present ? bloodGroup.value : this.bloodGroup,
    activeConditions: activeConditions ?? this.activeConditions,
    allergies: allergies ?? this.allergies,
    emergencyContactName: emergencyContactName.present
        ? emergencyContactName.value
        : this.emergencyContactName,
    emergencyContactPhone: emergencyContactPhone.present
        ? emergencyContactPhone.value
        : this.emergencyContactPhone,
    emergencyContactRelation: emergencyContactRelation.present
        ? emergencyContactRelation.value
        : this.emergencyContactRelation,
  );
  UserProfile copyWithCompanion(UserProfilesCompanion data) {
    return UserProfile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      dateOfBirth: data.dateOfBirth.present
          ? data.dateOfBirth.value
          : this.dateOfBirth,
      bloodGroup: data.bloodGroup.present
          ? data.bloodGroup.value
          : this.bloodGroup,
      activeConditions: data.activeConditions.present
          ? data.activeConditions.value
          : this.activeConditions,
      allergies: data.allergies.present ? data.allergies.value : this.allergies,
      emergencyContactName: data.emergencyContactName.present
          ? data.emergencyContactName.value
          : this.emergencyContactName,
      emergencyContactPhone: data.emergencyContactPhone.present
          ? data.emergencyContactPhone.value
          : this.emergencyContactPhone,
      emergencyContactRelation: data.emergencyContactRelation.present
          ? data.emergencyContactRelation.value
          : this.emergencyContactRelation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('bloodGroup: $bloodGroup, ')
          ..write('activeConditions: $activeConditions, ')
          ..write('allergies: $allergies, ')
          ..write('emergencyContactName: $emergencyContactName, ')
          ..write('emergencyContactPhone: $emergencyContactPhone, ')
          ..write('emergencyContactRelation: $emergencyContactRelation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    dateOfBirth,
    bloodGroup,
    activeConditions,
    allergies,
    emergencyContactName,
    emergencyContactPhone,
    emergencyContactRelation,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          other.id == this.id &&
          other.name == this.name &&
          other.dateOfBirth == this.dateOfBirth &&
          other.bloodGroup == this.bloodGroup &&
          other.activeConditions == this.activeConditions &&
          other.allergies == this.allergies &&
          other.emergencyContactName == this.emergencyContactName &&
          other.emergencyContactPhone == this.emergencyContactPhone &&
          other.emergencyContactRelation == this.emergencyContactRelation);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime?> dateOfBirth;
  final Value<String?> bloodGroup;
  final Value<String> activeConditions;
  final Value<String> allergies;
  final Value<String?> emergencyContactName;
  final Value<String?> emergencyContactPhone;
  final Value<String?> emergencyContactRelation;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.bloodGroup = const Value.absent(),
    this.activeConditions = const Value.absent(),
    this.allergies = const Value.absent(),
    this.emergencyContactName = const Value.absent(),
    this.emergencyContactPhone = const Value.absent(),
    this.emergencyContactRelation = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.dateOfBirth = const Value.absent(),
    this.bloodGroup = const Value.absent(),
    this.activeConditions = const Value.absent(),
    this.allergies = const Value.absent(),
    this.emergencyContactName = const Value.absent(),
    this.emergencyContactPhone = const Value.absent(),
    this.emergencyContactRelation = const Value.absent(),
  }) : name = Value(name);
  static Insertable<UserProfile> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? dateOfBirth,
    Expression<String>? bloodGroup,
    Expression<String>? activeConditions,
    Expression<String>? allergies,
    Expression<String>? emergencyContactName,
    Expression<String>? emergencyContactPhone,
    Expression<String>? emergencyContactRelation,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (bloodGroup != null) 'blood_group': bloodGroup,
      if (activeConditions != null) 'active_conditions': activeConditions,
      if (allergies != null) 'allergies': allergies,
      if (emergencyContactName != null)
        'emergency_contact_name': emergencyContactName,
      if (emergencyContactPhone != null)
        'emergency_contact_phone': emergencyContactPhone,
      if (emergencyContactRelation != null)
        'emergency_contact_relation': emergencyContactRelation,
    });
  }

  UserProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime?>? dateOfBirth,
    Value<String?>? bloodGroup,
    Value<String>? activeConditions,
    Value<String>? allergies,
    Value<String?>? emergencyContactName,
    Value<String?>? emergencyContactPhone,
    Value<String?>? emergencyContactRelation,
  }) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      activeConditions: activeConditions ?? this.activeConditions,
      allergies: allergies ?? this.allergies,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
      emergencyContactRelation:
          emergencyContactRelation ?? this.emergencyContactRelation,
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
    if (dateOfBirth.present) {
      map['date_of_birth'] = Variable<DateTime>(dateOfBirth.value);
    }
    if (bloodGroup.present) {
      map['blood_group'] = Variable<String>(bloodGroup.value);
    }
    if (activeConditions.present) {
      map['active_conditions'] = Variable<String>(activeConditions.value);
    }
    if (allergies.present) {
      map['allergies'] = Variable<String>(allergies.value);
    }
    if (emergencyContactName.present) {
      map['emergency_contact_name'] = Variable<String>(
        emergencyContactName.value,
      );
    }
    if (emergencyContactPhone.present) {
      map['emergency_contact_phone'] = Variable<String>(
        emergencyContactPhone.value,
      );
    }
    if (emergencyContactRelation.present) {
      map['emergency_contact_relation'] = Variable<String>(
        emergencyContactRelation.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('bloodGroup: $bloodGroup, ')
          ..write('activeConditions: $activeConditions, ')
          ..write('allergies: $allergies, ')
          ..write('emergencyContactName: $emergencyContactName, ')
          ..write('emergencyContactPhone: $emergencyContactPhone, ')
          ..write('emergencyContactRelation: $emergencyContactRelation')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final ProfileDao profileDao = ProfileDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [userProfiles];
}

typedef $$UserProfilesTableCreateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<int> id,
      required String name,
      Value<DateTime?> dateOfBirth,
      Value<String?> bloodGroup,
      Value<String> activeConditions,
      Value<String> allergies,
      Value<String?> emergencyContactName,
      Value<String?> emergencyContactPhone,
      Value<String?> emergencyContactRelation,
    });
typedef $$UserProfilesTableUpdateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DateTime?> dateOfBirth,
      Value<String?> bloodGroup,
      Value<String> activeConditions,
      Value<String> allergies,
      Value<String?> emergencyContactName,
      Value<String?> emergencyContactPhone,
      Value<String?> emergencyContactRelation,
    });

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
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

  ColumnFilters<DateTime> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bloodGroup => $composableBuilder(
    column: $table.bloodGroup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activeConditions => $composableBuilder(
    column: $table.activeConditions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allergies => $composableBuilder(
    column: $table.allergies,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emergencyContactName => $composableBuilder(
    column: $table.emergencyContactName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emergencyContactPhone => $composableBuilder(
    column: $table.emergencyContactPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emergencyContactRelation => $composableBuilder(
    column: $table.emergencyContactRelation,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
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

  ColumnOrderings<DateTime> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bloodGroup => $composableBuilder(
    column: $table.bloodGroup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activeConditions => $composableBuilder(
    column: $table.activeConditions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allergies => $composableBuilder(
    column: $table.allergies,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emergencyContactName => $composableBuilder(
    column: $table.emergencyContactName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emergencyContactPhone => $composableBuilder(
    column: $table.emergencyContactPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emergencyContactRelation => $composableBuilder(
    column: $table.emergencyContactRelation,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
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

  GeneratedColumn<DateTime> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bloodGroup => $composableBuilder(
    column: $table.bloodGroup,
    builder: (column) => column,
  );

  GeneratedColumn<String> get activeConditions => $composableBuilder(
    column: $table.activeConditions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get allergies =>
      $composableBuilder(column: $table.allergies, builder: (column) => column);

  GeneratedColumn<String> get emergencyContactName => $composableBuilder(
    column: $table.emergencyContactName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get emergencyContactPhone => $composableBuilder(
    column: $table.emergencyContactPhone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get emergencyContactRelation => $composableBuilder(
    column: $table.emergencyContactRelation,
    builder: (column) => column,
  );
}

class $$UserProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfilesTable,
          UserProfile,
          $$UserProfilesTableFilterComposer,
          $$UserProfilesTableOrderingComposer,
          $$UserProfilesTableAnnotationComposer,
          $$UserProfilesTableCreateCompanionBuilder,
          $$UserProfilesTableUpdateCompanionBuilder,
          (
            UserProfile,
            BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
          ),
          UserProfile,
          PrefetchHooks Function()
        > {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime?> dateOfBirth = const Value.absent(),
                Value<String?> bloodGroup = const Value.absent(),
                Value<String> activeConditions = const Value.absent(),
                Value<String> allergies = const Value.absent(),
                Value<String?> emergencyContactName = const Value.absent(),
                Value<String?> emergencyContactPhone = const Value.absent(),
                Value<String?> emergencyContactRelation = const Value.absent(),
              }) => UserProfilesCompanion(
                id: id,
                name: name,
                dateOfBirth: dateOfBirth,
                bloodGroup: bloodGroup,
                activeConditions: activeConditions,
                allergies: allergies,
                emergencyContactName: emergencyContactName,
                emergencyContactPhone: emergencyContactPhone,
                emergencyContactRelation: emergencyContactRelation,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<DateTime?> dateOfBirth = const Value.absent(),
                Value<String?> bloodGroup = const Value.absent(),
                Value<String> activeConditions = const Value.absent(),
                Value<String> allergies = const Value.absent(),
                Value<String?> emergencyContactName = const Value.absent(),
                Value<String?> emergencyContactPhone = const Value.absent(),
                Value<String?> emergencyContactRelation = const Value.absent(),
              }) => UserProfilesCompanion.insert(
                id: id,
                name: name,
                dateOfBirth: dateOfBirth,
                bloodGroup: bloodGroup,
                activeConditions: activeConditions,
                allergies: allergies,
                emergencyContactName: emergencyContactName,
                emergencyContactPhone: emergencyContactPhone,
                emergencyContactRelation: emergencyContactRelation,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfilesTable,
      UserProfile,
      $$UserProfilesTableFilterComposer,
      $$UserProfilesTableOrderingComposer,
      $$UserProfilesTableAnnotationComposer,
      $$UserProfilesTableCreateCompanionBuilder,
      $$UserProfilesTableUpdateCompanionBuilder,
      (
        UserProfile,
        BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
      ),
      UserProfile,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
}
