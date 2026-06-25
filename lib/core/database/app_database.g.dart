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

class $VitalsEntriesTable extends VitalsEntries
    with TableInfo<$VitalsEntriesTable, VitalsEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VitalsEntriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _loggedAtMeta = const VerificationMeta(
    'loggedAt',
  );
  @override
  late final GeneratedColumn<DateTime> loggedAt = GeneratedColumn<DateTime>(
    'logged_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bpSystolicMeta = const VerificationMeta(
    'bpSystolic',
  );
  @override
  late final GeneratedColumn<int> bpSystolic = GeneratedColumn<int>(
    'bp_systolic',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bpDiastolicMeta = const VerificationMeta(
    'bpDiastolic',
  );
  @override
  late final GeneratedColumn<int> bpDiastolic = GeneratedColumn<int>(
    'bp_diastolic',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bloodSugarFastingMeta = const VerificationMeta(
    'bloodSugarFasting',
  );
  @override
  late final GeneratedColumn<double> bloodSugarFasting =
      GeneratedColumn<double>(
        'blood_sugar_fasting',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _bloodSugarPostMealMeta =
      const VerificationMeta('bloodSugarPostMeal');
  @override
  late final GeneratedColumn<double> bloodSugarPostMeal =
      GeneratedColumn<double>(
        'blood_sugar_post_meal',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _temperatureCelsiusMeta =
      const VerificationMeta('temperatureCelsius');
  @override
  late final GeneratedColumn<double> temperatureCelsius =
      GeneratedColumn<double>(
        'temperature_celsius',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _spo2PercentMeta = const VerificationMeta(
    'spo2Percent',
  );
  @override
  late final GeneratedColumn<int> spo2Percent = GeneratedColumn<int>(
    'spo2_percent',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    loggedAt,
    bpSystolic,
    bpDiastolic,
    bloodSugarFasting,
    bloodSugarPostMeal,
    temperatureCelsius,
    weightKg,
    spo2Percent,
    notes,
    synced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vitals_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<VitalsEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('logged_at')) {
      context.handle(
        _loggedAtMeta,
        loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_loggedAtMeta);
    }
    if (data.containsKey('bp_systolic')) {
      context.handle(
        _bpSystolicMeta,
        bpSystolic.isAcceptableOrUnknown(data['bp_systolic']!, _bpSystolicMeta),
      );
    }
    if (data.containsKey('bp_diastolic')) {
      context.handle(
        _bpDiastolicMeta,
        bpDiastolic.isAcceptableOrUnknown(
          data['bp_diastolic']!,
          _bpDiastolicMeta,
        ),
      );
    }
    if (data.containsKey('blood_sugar_fasting')) {
      context.handle(
        _bloodSugarFastingMeta,
        bloodSugarFasting.isAcceptableOrUnknown(
          data['blood_sugar_fasting']!,
          _bloodSugarFastingMeta,
        ),
      );
    }
    if (data.containsKey('blood_sugar_post_meal')) {
      context.handle(
        _bloodSugarPostMealMeta,
        bloodSugarPostMeal.isAcceptableOrUnknown(
          data['blood_sugar_post_meal']!,
          _bloodSugarPostMealMeta,
        ),
      );
    }
    if (data.containsKey('temperature_celsius')) {
      context.handle(
        _temperatureCelsiusMeta,
        temperatureCelsius.isAcceptableOrUnknown(
          data['temperature_celsius']!,
          _temperatureCelsiusMeta,
        ),
      );
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('spo2_percent')) {
      context.handle(
        _spo2PercentMeta,
        spo2Percent.isAcceptableOrUnknown(
          data['spo2_percent']!,
          _spo2PercentMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VitalsEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VitalsEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      loggedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}logged_at'],
      )!,
      bpSystolic: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bp_systolic'],
      ),
      bpDiastolic: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bp_diastolic'],
      ),
      bloodSugarFasting: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}blood_sugar_fasting'],
      ),
      bloodSugarPostMeal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}blood_sugar_post_meal'],
      ),
      temperatureCelsius: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}temperature_celsius'],
      ),
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      ),
      spo2Percent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}spo2_percent'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
    );
  }

  @override
  $VitalsEntriesTable createAlias(String alias) {
    return $VitalsEntriesTable(attachedDatabase, alias);
  }
}

class VitalsEntry extends DataClass implements Insertable<VitalsEntry> {
  final int id;
  final DateTime loggedAt;
  final int? bpSystolic;
  final int? bpDiastolic;
  final double? bloodSugarFasting;
  final double? bloodSugarPostMeal;
  final double? temperatureCelsius;
  final double? weightKg;
  final int? spo2Percent;
  final String notes;
  final bool synced;
  const VitalsEntry({
    required this.id,
    required this.loggedAt,
    this.bpSystolic,
    this.bpDiastolic,
    this.bloodSugarFasting,
    this.bloodSugarPostMeal,
    this.temperatureCelsius,
    this.weightKg,
    this.spo2Percent,
    required this.notes,
    required this.synced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['logged_at'] = Variable<DateTime>(loggedAt);
    if (!nullToAbsent || bpSystolic != null) {
      map['bp_systolic'] = Variable<int>(bpSystolic);
    }
    if (!nullToAbsent || bpDiastolic != null) {
      map['bp_diastolic'] = Variable<int>(bpDiastolic);
    }
    if (!nullToAbsent || bloodSugarFasting != null) {
      map['blood_sugar_fasting'] = Variable<double>(bloodSugarFasting);
    }
    if (!nullToAbsent || bloodSugarPostMeal != null) {
      map['blood_sugar_post_meal'] = Variable<double>(bloodSugarPostMeal);
    }
    if (!nullToAbsent || temperatureCelsius != null) {
      map['temperature_celsius'] = Variable<double>(temperatureCelsius);
    }
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    if (!nullToAbsent || spo2Percent != null) {
      map['spo2_percent'] = Variable<int>(spo2Percent);
    }
    map['notes'] = Variable<String>(notes);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  VitalsEntriesCompanion toCompanion(bool nullToAbsent) {
    return VitalsEntriesCompanion(
      id: Value(id),
      loggedAt: Value(loggedAt),
      bpSystolic: bpSystolic == null && nullToAbsent
          ? const Value.absent()
          : Value(bpSystolic),
      bpDiastolic: bpDiastolic == null && nullToAbsent
          ? const Value.absent()
          : Value(bpDiastolic),
      bloodSugarFasting: bloodSugarFasting == null && nullToAbsent
          ? const Value.absent()
          : Value(bloodSugarFasting),
      bloodSugarPostMeal: bloodSugarPostMeal == null && nullToAbsent
          ? const Value.absent()
          : Value(bloodSugarPostMeal),
      temperatureCelsius: temperatureCelsius == null && nullToAbsent
          ? const Value.absent()
          : Value(temperatureCelsius),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      spo2Percent: spo2Percent == null && nullToAbsent
          ? const Value.absent()
          : Value(spo2Percent),
      notes: Value(notes),
      synced: Value(synced),
    );
  }

  factory VitalsEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VitalsEntry(
      id: serializer.fromJson<int>(json['id']),
      loggedAt: serializer.fromJson<DateTime>(json['loggedAt']),
      bpSystolic: serializer.fromJson<int?>(json['bpSystolic']),
      bpDiastolic: serializer.fromJson<int?>(json['bpDiastolic']),
      bloodSugarFasting: serializer.fromJson<double?>(
        json['bloodSugarFasting'],
      ),
      bloodSugarPostMeal: serializer.fromJson<double?>(
        json['bloodSugarPostMeal'],
      ),
      temperatureCelsius: serializer.fromJson<double?>(
        json['temperatureCelsius'],
      ),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      spo2Percent: serializer.fromJson<int?>(json['spo2Percent']),
      notes: serializer.fromJson<String>(json['notes']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'loggedAt': serializer.toJson<DateTime>(loggedAt),
      'bpSystolic': serializer.toJson<int?>(bpSystolic),
      'bpDiastolic': serializer.toJson<int?>(bpDiastolic),
      'bloodSugarFasting': serializer.toJson<double?>(bloodSugarFasting),
      'bloodSugarPostMeal': serializer.toJson<double?>(bloodSugarPostMeal),
      'temperatureCelsius': serializer.toJson<double?>(temperatureCelsius),
      'weightKg': serializer.toJson<double?>(weightKg),
      'spo2Percent': serializer.toJson<int?>(spo2Percent),
      'notes': serializer.toJson<String>(notes),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  VitalsEntry copyWith({
    int? id,
    DateTime? loggedAt,
    Value<int?> bpSystolic = const Value.absent(),
    Value<int?> bpDiastolic = const Value.absent(),
    Value<double?> bloodSugarFasting = const Value.absent(),
    Value<double?> bloodSugarPostMeal = const Value.absent(),
    Value<double?> temperatureCelsius = const Value.absent(),
    Value<double?> weightKg = const Value.absent(),
    Value<int?> spo2Percent = const Value.absent(),
    String? notes,
    bool? synced,
  }) => VitalsEntry(
    id: id ?? this.id,
    loggedAt: loggedAt ?? this.loggedAt,
    bpSystolic: bpSystolic.present ? bpSystolic.value : this.bpSystolic,
    bpDiastolic: bpDiastolic.present ? bpDiastolic.value : this.bpDiastolic,
    bloodSugarFasting: bloodSugarFasting.present
        ? bloodSugarFasting.value
        : this.bloodSugarFasting,
    bloodSugarPostMeal: bloodSugarPostMeal.present
        ? bloodSugarPostMeal.value
        : this.bloodSugarPostMeal,
    temperatureCelsius: temperatureCelsius.present
        ? temperatureCelsius.value
        : this.temperatureCelsius,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
    spo2Percent: spo2Percent.present ? spo2Percent.value : this.spo2Percent,
    notes: notes ?? this.notes,
    synced: synced ?? this.synced,
  );
  VitalsEntry copyWithCompanion(VitalsEntriesCompanion data) {
    return VitalsEntry(
      id: data.id.present ? data.id.value : this.id,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
      bpSystolic: data.bpSystolic.present
          ? data.bpSystolic.value
          : this.bpSystolic,
      bpDiastolic: data.bpDiastolic.present
          ? data.bpDiastolic.value
          : this.bpDiastolic,
      bloodSugarFasting: data.bloodSugarFasting.present
          ? data.bloodSugarFasting.value
          : this.bloodSugarFasting,
      bloodSugarPostMeal: data.bloodSugarPostMeal.present
          ? data.bloodSugarPostMeal.value
          : this.bloodSugarPostMeal,
      temperatureCelsius: data.temperatureCelsius.present
          ? data.temperatureCelsius.value
          : this.temperatureCelsius,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      spo2Percent: data.spo2Percent.present
          ? data.spo2Percent.value
          : this.spo2Percent,
      notes: data.notes.present ? data.notes.value : this.notes,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VitalsEntry(')
          ..write('id: $id, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('bpSystolic: $bpSystolic, ')
          ..write('bpDiastolic: $bpDiastolic, ')
          ..write('bloodSugarFasting: $bloodSugarFasting, ')
          ..write('bloodSugarPostMeal: $bloodSugarPostMeal, ')
          ..write('temperatureCelsius: $temperatureCelsius, ')
          ..write('weightKg: $weightKg, ')
          ..write('spo2Percent: $spo2Percent, ')
          ..write('notes: $notes, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    loggedAt,
    bpSystolic,
    bpDiastolic,
    bloodSugarFasting,
    bloodSugarPostMeal,
    temperatureCelsius,
    weightKg,
    spo2Percent,
    notes,
    synced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VitalsEntry &&
          other.id == this.id &&
          other.loggedAt == this.loggedAt &&
          other.bpSystolic == this.bpSystolic &&
          other.bpDiastolic == this.bpDiastolic &&
          other.bloodSugarFasting == this.bloodSugarFasting &&
          other.bloodSugarPostMeal == this.bloodSugarPostMeal &&
          other.temperatureCelsius == this.temperatureCelsius &&
          other.weightKg == this.weightKg &&
          other.spo2Percent == this.spo2Percent &&
          other.notes == this.notes &&
          other.synced == this.synced);
}

class VitalsEntriesCompanion extends UpdateCompanion<VitalsEntry> {
  final Value<int> id;
  final Value<DateTime> loggedAt;
  final Value<int?> bpSystolic;
  final Value<int?> bpDiastolic;
  final Value<double?> bloodSugarFasting;
  final Value<double?> bloodSugarPostMeal;
  final Value<double?> temperatureCelsius;
  final Value<double?> weightKg;
  final Value<int?> spo2Percent;
  final Value<String> notes;
  final Value<bool> synced;
  const VitalsEntriesCompanion({
    this.id = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.bpSystolic = const Value.absent(),
    this.bpDiastolic = const Value.absent(),
    this.bloodSugarFasting = const Value.absent(),
    this.bloodSugarPostMeal = const Value.absent(),
    this.temperatureCelsius = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.spo2Percent = const Value.absent(),
    this.notes = const Value.absent(),
    this.synced = const Value.absent(),
  });
  VitalsEntriesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime loggedAt,
    this.bpSystolic = const Value.absent(),
    this.bpDiastolic = const Value.absent(),
    this.bloodSugarFasting = const Value.absent(),
    this.bloodSugarPostMeal = const Value.absent(),
    this.temperatureCelsius = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.spo2Percent = const Value.absent(),
    this.notes = const Value.absent(),
    this.synced = const Value.absent(),
  }) : loggedAt = Value(loggedAt);
  static Insertable<VitalsEntry> custom({
    Expression<int>? id,
    Expression<DateTime>? loggedAt,
    Expression<int>? bpSystolic,
    Expression<int>? bpDiastolic,
    Expression<double>? bloodSugarFasting,
    Expression<double>? bloodSugarPostMeal,
    Expression<double>? temperatureCelsius,
    Expression<double>? weightKg,
    Expression<int>? spo2Percent,
    Expression<String>? notes,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (loggedAt != null) 'logged_at': loggedAt,
      if (bpSystolic != null) 'bp_systolic': bpSystolic,
      if (bpDiastolic != null) 'bp_diastolic': bpDiastolic,
      if (bloodSugarFasting != null) 'blood_sugar_fasting': bloodSugarFasting,
      if (bloodSugarPostMeal != null)
        'blood_sugar_post_meal': bloodSugarPostMeal,
      if (temperatureCelsius != null) 'temperature_celsius': temperatureCelsius,
      if (weightKg != null) 'weight_kg': weightKg,
      if (spo2Percent != null) 'spo2_percent': spo2Percent,
      if (notes != null) 'notes': notes,
      if (synced != null) 'synced': synced,
    });
  }

  VitalsEntriesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? loggedAt,
    Value<int?>? bpSystolic,
    Value<int?>? bpDiastolic,
    Value<double?>? bloodSugarFasting,
    Value<double?>? bloodSugarPostMeal,
    Value<double?>? temperatureCelsius,
    Value<double?>? weightKg,
    Value<int?>? spo2Percent,
    Value<String>? notes,
    Value<bool>? synced,
  }) {
    return VitalsEntriesCompanion(
      id: id ?? this.id,
      loggedAt: loggedAt ?? this.loggedAt,
      bpSystolic: bpSystolic ?? this.bpSystolic,
      bpDiastolic: bpDiastolic ?? this.bpDiastolic,
      bloodSugarFasting: bloodSugarFasting ?? this.bloodSugarFasting,
      bloodSugarPostMeal: bloodSugarPostMeal ?? this.bloodSugarPostMeal,
      temperatureCelsius: temperatureCelsius ?? this.temperatureCelsius,
      weightKg: weightKg ?? this.weightKg,
      spo2Percent: spo2Percent ?? this.spo2Percent,
      notes: notes ?? this.notes,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<DateTime>(loggedAt.value);
    }
    if (bpSystolic.present) {
      map['bp_systolic'] = Variable<int>(bpSystolic.value);
    }
    if (bpDiastolic.present) {
      map['bp_diastolic'] = Variable<int>(bpDiastolic.value);
    }
    if (bloodSugarFasting.present) {
      map['blood_sugar_fasting'] = Variable<double>(bloodSugarFasting.value);
    }
    if (bloodSugarPostMeal.present) {
      map['blood_sugar_post_meal'] = Variable<double>(bloodSugarPostMeal.value);
    }
    if (temperatureCelsius.present) {
      map['temperature_celsius'] = Variable<double>(temperatureCelsius.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (spo2Percent.present) {
      map['spo2_percent'] = Variable<int>(spo2Percent.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VitalsEntriesCompanion(')
          ..write('id: $id, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('bpSystolic: $bpSystolic, ')
          ..write('bpDiastolic: $bpDiastolic, ')
          ..write('bloodSugarFasting: $bloodSugarFasting, ')
          ..write('bloodSugarPostMeal: $bloodSugarPostMeal, ')
          ..write('temperatureCelsius: $temperatureCelsius, ')
          ..write('weightKg: $weightKg, ')
          ..write('spo2Percent: $spo2Percent, ')
          ..write('notes: $notes, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $MedicinesTable extends Medicines
    with TableInfo<$MedicinesTable, Medicine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicinesTable(this.attachedDatabase, [this._alias]);
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
  );
  static const VerificationMeta _dosageMeta = const VerificationMeta('dosage');
  @override
  late final GeneratedColumn<String> dosage = GeneratedColumn<String>(
    'dosage',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timesPerDayMeta = const VerificationMeta(
    'timesPerDay',
  );
  @override
  late final GeneratedColumn<int> timesPerDay = GeneratedColumn<int>(
    'times_per_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _scheduledTimesMeta = const VerificationMeta(
    'scheduledTimes',
  );
  @override
  late final GeneratedColumn<String> scheduledTimes = GeneratedColumn<String>(
    'scheduled_times',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    dosage,
    frequency,
    timesPerDay,
    scheduledTimes,
    startDate,
    endDate,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medicines';
  @override
  VerificationContext validateIntegrity(
    Insertable<Medicine> instance, {
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
    if (data.containsKey('dosage')) {
      context.handle(
        _dosageMeta,
        dosage.isAcceptableOrUnknown(data['dosage']!, _dosageMeta),
      );
    } else if (isInserting) {
      context.missing(_dosageMeta);
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('times_per_day')) {
      context.handle(
        _timesPerDayMeta,
        timesPerDay.isAcceptableOrUnknown(
          data['times_per_day']!,
          _timesPerDayMeta,
        ),
      );
    }
    if (data.containsKey('scheduled_times')) {
      context.handle(
        _scheduledTimesMeta,
        scheduledTimes.isAcceptableOrUnknown(
          data['scheduled_times']!,
          _scheduledTimesMeta,
        ),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Medicine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Medicine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      dosage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dosage'],
      )!,
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      )!,
      timesPerDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}times_per_day'],
      )!,
      scheduledTimes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scheduled_times'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $MedicinesTable createAlias(String alias) {
    return $MedicinesTable(attachedDatabase, alias);
  }
}

class Medicine extends DataClass implements Insertable<Medicine> {
  final int id;
  final String name;
  final String dosage;
  final String frequency;
  final int timesPerDay;
  final String scheduledTimes;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  const Medicine({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.timesPerDay,
    required this.scheduledTimes,
    required this.startDate,
    this.endDate,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['dosage'] = Variable<String>(dosage);
    map['frequency'] = Variable<String>(frequency);
    map['times_per_day'] = Variable<int>(timesPerDay);
    map['scheduled_times'] = Variable<String>(scheduledTimes);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  MedicinesCompanion toCompanion(bool nullToAbsent) {
    return MedicinesCompanion(
      id: Value(id),
      name: Value(name),
      dosage: Value(dosage),
      frequency: Value(frequency),
      timesPerDay: Value(timesPerDay),
      scheduledTimes: Value(scheduledTimes),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      isActive: Value(isActive),
    );
  }

  factory Medicine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Medicine(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      dosage: serializer.fromJson<String>(json['dosage']),
      frequency: serializer.fromJson<String>(json['frequency']),
      timesPerDay: serializer.fromJson<int>(json['timesPerDay']),
      scheduledTimes: serializer.fromJson<String>(json['scheduledTimes']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'dosage': serializer.toJson<String>(dosage),
      'frequency': serializer.toJson<String>(frequency),
      'timesPerDay': serializer.toJson<int>(timesPerDay),
      'scheduledTimes': serializer.toJson<String>(scheduledTimes),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Medicine copyWith({
    int? id,
    String? name,
    String? dosage,
    String? frequency,
    int? timesPerDay,
    String? scheduledTimes,
    DateTime? startDate,
    Value<DateTime?> endDate = const Value.absent(),
    bool? isActive,
  }) => Medicine(
    id: id ?? this.id,
    name: name ?? this.name,
    dosage: dosage ?? this.dosage,
    frequency: frequency ?? this.frequency,
    timesPerDay: timesPerDay ?? this.timesPerDay,
    scheduledTimes: scheduledTimes ?? this.scheduledTimes,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    isActive: isActive ?? this.isActive,
  );
  Medicine copyWithCompanion(MedicinesCompanion data) {
    return Medicine(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      dosage: data.dosage.present ? data.dosage.value : this.dosage,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      timesPerDay: data.timesPerDay.present
          ? data.timesPerDay.value
          : this.timesPerDay,
      scheduledTimes: data.scheduledTimes.present
          ? data.scheduledTimes.value
          : this.scheduledTimes,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Medicine(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dosage: $dosage, ')
          ..write('frequency: $frequency, ')
          ..write('timesPerDay: $timesPerDay, ')
          ..write('scheduledTimes: $scheduledTimes, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    dosage,
    frequency,
    timesPerDay,
    scheduledTimes,
    startDate,
    endDate,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Medicine &&
          other.id == this.id &&
          other.name == this.name &&
          other.dosage == this.dosage &&
          other.frequency == this.frequency &&
          other.timesPerDay == this.timesPerDay &&
          other.scheduledTimes == this.scheduledTimes &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.isActive == this.isActive);
}

class MedicinesCompanion extends UpdateCompanion<Medicine> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> dosage;
  final Value<String> frequency;
  final Value<int> timesPerDay;
  final Value<String> scheduledTimes;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<bool> isActive;
  const MedicinesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.dosage = const Value.absent(),
    this.frequency = const Value.absent(),
    this.timesPerDay = const Value.absent(),
    this.scheduledTimes = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  MedicinesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String dosage,
    required String frequency,
    this.timesPerDay = const Value.absent(),
    this.scheduledTimes = const Value.absent(),
    required DateTime startDate,
    this.endDate = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : name = Value(name),
       dosage = Value(dosage),
       frequency = Value(frequency),
       startDate = Value(startDate);
  static Insertable<Medicine> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? dosage,
    Expression<String>? frequency,
    Expression<int>? timesPerDay,
    Expression<String>? scheduledTimes,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (dosage != null) 'dosage': dosage,
      if (frequency != null) 'frequency': frequency,
      if (timesPerDay != null) 'times_per_day': timesPerDay,
      if (scheduledTimes != null) 'scheduled_times': scheduledTimes,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (isActive != null) 'is_active': isActive,
    });
  }

  MedicinesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? dosage,
    Value<String>? frequency,
    Value<int>? timesPerDay,
    Value<String>? scheduledTimes,
    Value<DateTime>? startDate,
    Value<DateTime?>? endDate,
    Value<bool>? isActive,
  }) {
    return MedicinesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      timesPerDay: timesPerDay ?? this.timesPerDay,
      scheduledTimes: scheduledTimes ?? this.scheduledTimes,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
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
    if (dosage.present) {
      map['dosage'] = Variable<String>(dosage.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (timesPerDay.present) {
      map['times_per_day'] = Variable<int>(timesPerDay.value);
    }
    if (scheduledTimes.present) {
      map['scheduled_times'] = Variable<String>(scheduledTimes.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicinesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dosage: $dosage, ')
          ..write('frequency: $frequency, ')
          ..write('timesPerDay: $timesPerDay, ')
          ..write('scheduledTimes: $scheduledTimes, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $MedicineDosesTable extends MedicineDoses
    with TableInfo<$MedicineDosesTable, MedicineDose> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicineDosesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _medicineIdMeta = const VerificationMeta(
    'medicineId',
  );
  @override
  late final GeneratedColumn<int> medicineId = GeneratedColumn<int>(
    'medicine_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medicines (id)',
    ),
  );
  static const VerificationMeta _scheduledAtMeta = const VerificationMeta(
    'scheduledAt',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
    'scheduled_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _takenAtMeta = const VerificationMeta(
    'takenAt',
  );
  @override
  late final GeneratedColumn<DateTime> takenAt = GeneratedColumn<DateTime>(
    'taken_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicineId,
    scheduledAt,
    takenAt,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medicine_doses';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicineDose> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('medicine_id')) {
      context.handle(
        _medicineIdMeta,
        medicineId.isAcceptableOrUnknown(data['medicine_id']!, _medicineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_medicineIdMeta);
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
        _scheduledAtMeta,
        scheduledAt.isAcceptableOrUnknown(
          data['scheduled_at']!,
          _scheduledAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('taken_at')) {
      context.handle(
        _takenAtMeta,
        takenAt.isAcceptableOrUnknown(data['taken_at']!, _takenAtMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicineDose map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicineDose(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      medicineId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}medicine_id'],
      )!,
      scheduledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_at'],
      )!,
      takenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}taken_at'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $MedicineDosesTable createAlias(String alias) {
    return $MedicineDosesTable(attachedDatabase, alias);
  }
}

class MedicineDose extends DataClass implements Insertable<MedicineDose> {
  final int id;
  final int medicineId;
  final DateTime scheduledAt;
  final DateTime? takenAt;
  final String status;
  const MedicineDose({
    required this.id,
    required this.medicineId,
    required this.scheduledAt,
    this.takenAt,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['medicine_id'] = Variable<int>(medicineId);
    map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    if (!nullToAbsent || takenAt != null) {
      map['taken_at'] = Variable<DateTime>(takenAt);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  MedicineDosesCompanion toCompanion(bool nullToAbsent) {
    return MedicineDosesCompanion(
      id: Value(id),
      medicineId: Value(medicineId),
      scheduledAt: Value(scheduledAt),
      takenAt: takenAt == null && nullToAbsent
          ? const Value.absent()
          : Value(takenAt),
      status: Value(status),
    );
  }

  factory MedicineDose.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicineDose(
      id: serializer.fromJson<int>(json['id']),
      medicineId: serializer.fromJson<int>(json['medicineId']),
      scheduledAt: serializer.fromJson<DateTime>(json['scheduledAt']),
      takenAt: serializer.fromJson<DateTime?>(json['takenAt']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'medicineId': serializer.toJson<int>(medicineId),
      'scheduledAt': serializer.toJson<DateTime>(scheduledAt),
      'takenAt': serializer.toJson<DateTime?>(takenAt),
      'status': serializer.toJson<String>(status),
    };
  }

  MedicineDose copyWith({
    int? id,
    int? medicineId,
    DateTime? scheduledAt,
    Value<DateTime?> takenAt = const Value.absent(),
    String? status,
  }) => MedicineDose(
    id: id ?? this.id,
    medicineId: medicineId ?? this.medicineId,
    scheduledAt: scheduledAt ?? this.scheduledAt,
    takenAt: takenAt.present ? takenAt.value : this.takenAt,
    status: status ?? this.status,
  );
  MedicineDose copyWithCompanion(MedicineDosesCompanion data) {
    return MedicineDose(
      id: data.id.present ? data.id.value : this.id,
      medicineId: data.medicineId.present
          ? data.medicineId.value
          : this.medicineId,
      scheduledAt: data.scheduledAt.present
          ? data.scheduledAt.value
          : this.scheduledAt,
      takenAt: data.takenAt.present ? data.takenAt.value : this.takenAt,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicineDose(')
          ..write('id: $id, ')
          ..write('medicineId: $medicineId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('takenAt: $takenAt, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, medicineId, scheduledAt, takenAt, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicineDose &&
          other.id == this.id &&
          other.medicineId == this.medicineId &&
          other.scheduledAt == this.scheduledAt &&
          other.takenAt == this.takenAt &&
          other.status == this.status);
}

class MedicineDosesCompanion extends UpdateCompanion<MedicineDose> {
  final Value<int> id;
  final Value<int> medicineId;
  final Value<DateTime> scheduledAt;
  final Value<DateTime?> takenAt;
  final Value<String> status;
  const MedicineDosesCompanion({
    this.id = const Value.absent(),
    this.medicineId = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.takenAt = const Value.absent(),
    this.status = const Value.absent(),
  });
  MedicineDosesCompanion.insert({
    this.id = const Value.absent(),
    required int medicineId,
    required DateTime scheduledAt,
    this.takenAt = const Value.absent(),
    this.status = const Value.absent(),
  }) : medicineId = Value(medicineId),
       scheduledAt = Value(scheduledAt);
  static Insertable<MedicineDose> custom({
    Expression<int>? id,
    Expression<int>? medicineId,
    Expression<DateTime>? scheduledAt,
    Expression<DateTime>? takenAt,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicineId != null) 'medicine_id': medicineId,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (takenAt != null) 'taken_at': takenAt,
      if (status != null) 'status': status,
    });
  }

  MedicineDosesCompanion copyWith({
    Value<int>? id,
    Value<int>? medicineId,
    Value<DateTime>? scheduledAt,
    Value<DateTime?>? takenAt,
    Value<String>? status,
  }) {
    return MedicineDosesCompanion(
      id: id ?? this.id,
      medicineId: medicineId ?? this.medicineId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      takenAt: takenAt ?? this.takenAt,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (medicineId.present) {
      map['medicine_id'] = Variable<int>(medicineId.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (takenAt.present) {
      map['taken_at'] = Variable<DateTime>(takenAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicineDosesCompanion(')
          ..write('id: $id, ')
          ..write('medicineId: $medicineId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('takenAt: $takenAt, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $VitalsEntriesTable vitalsEntries = $VitalsEntriesTable(this);
  late final $MedicinesTable medicines = $MedicinesTable(this);
  late final $MedicineDosesTable medicineDoses = $MedicineDosesTable(this);
  late final ProfileDao profileDao = ProfileDao(this as AppDatabase);
  late final VitalsDao vitalsDao = VitalsDao(this as AppDatabase);
  late final MedicineDao medicineDao = MedicineDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userProfiles,
    vitalsEntries,
    medicines,
    medicineDoses,
  ];
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
typedef $$VitalsEntriesTableCreateCompanionBuilder =
    VitalsEntriesCompanion Function({
      Value<int> id,
      required DateTime loggedAt,
      Value<int?> bpSystolic,
      Value<int?> bpDiastolic,
      Value<double?> bloodSugarFasting,
      Value<double?> bloodSugarPostMeal,
      Value<double?> temperatureCelsius,
      Value<double?> weightKg,
      Value<int?> spo2Percent,
      Value<String> notes,
      Value<bool> synced,
    });
typedef $$VitalsEntriesTableUpdateCompanionBuilder =
    VitalsEntriesCompanion Function({
      Value<int> id,
      Value<DateTime> loggedAt,
      Value<int?> bpSystolic,
      Value<int?> bpDiastolic,
      Value<double?> bloodSugarFasting,
      Value<double?> bloodSugarPostMeal,
      Value<double?> temperatureCelsius,
      Value<double?> weightKg,
      Value<int?> spo2Percent,
      Value<String> notes,
      Value<bool> synced,
    });

class $$VitalsEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $VitalsEntriesTable> {
  $$VitalsEntriesTableFilterComposer({
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

  ColumnFilters<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bpSystolic => $composableBuilder(
    column: $table.bpSystolic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bpDiastolic => $composableBuilder(
    column: $table.bpDiastolic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bloodSugarFasting => $composableBuilder(
    column: $table.bloodSugarFasting,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bloodSugarPostMeal => $composableBuilder(
    column: $table.bloodSugarPostMeal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get temperatureCelsius => $composableBuilder(
    column: $table.temperatureCelsius,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get spo2Percent => $composableBuilder(
    column: $table.spo2Percent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VitalsEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $VitalsEntriesTable> {
  $$VitalsEntriesTableOrderingComposer({
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

  ColumnOrderings<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bpSystolic => $composableBuilder(
    column: $table.bpSystolic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bpDiastolic => $composableBuilder(
    column: $table.bpDiastolic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bloodSugarFasting => $composableBuilder(
    column: $table.bloodSugarFasting,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bloodSugarPostMeal => $composableBuilder(
    column: $table.bloodSugarPostMeal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get temperatureCelsius => $composableBuilder(
    column: $table.temperatureCelsius,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get spo2Percent => $composableBuilder(
    column: $table.spo2Percent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VitalsEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VitalsEntriesTable> {
  $$VitalsEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);

  GeneratedColumn<int> get bpSystolic => $composableBuilder(
    column: $table.bpSystolic,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bpDiastolic => $composableBuilder(
    column: $table.bpDiastolic,
    builder: (column) => column,
  );

  GeneratedColumn<double> get bloodSugarFasting => $composableBuilder(
    column: $table.bloodSugarFasting,
    builder: (column) => column,
  );

  GeneratedColumn<double> get bloodSugarPostMeal => $composableBuilder(
    column: $table.bloodSugarPostMeal,
    builder: (column) => column,
  );

  GeneratedColumn<double> get temperatureCelsius => $composableBuilder(
    column: $table.temperatureCelsius,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<int> get spo2Percent => $composableBuilder(
    column: $table.spo2Percent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$VitalsEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VitalsEntriesTable,
          VitalsEntry,
          $$VitalsEntriesTableFilterComposer,
          $$VitalsEntriesTableOrderingComposer,
          $$VitalsEntriesTableAnnotationComposer,
          $$VitalsEntriesTableCreateCompanionBuilder,
          $$VitalsEntriesTableUpdateCompanionBuilder,
          (
            VitalsEntry,
            BaseReferences<_$AppDatabase, $VitalsEntriesTable, VitalsEntry>,
          ),
          VitalsEntry,
          PrefetchHooks Function()
        > {
  $$VitalsEntriesTableTableManager(_$AppDatabase db, $VitalsEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VitalsEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VitalsEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VitalsEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> loggedAt = const Value.absent(),
                Value<int?> bpSystolic = const Value.absent(),
                Value<int?> bpDiastolic = const Value.absent(),
                Value<double?> bloodSugarFasting = const Value.absent(),
                Value<double?> bloodSugarPostMeal = const Value.absent(),
                Value<double?> temperatureCelsius = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<int?> spo2Percent = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => VitalsEntriesCompanion(
                id: id,
                loggedAt: loggedAt,
                bpSystolic: bpSystolic,
                bpDiastolic: bpDiastolic,
                bloodSugarFasting: bloodSugarFasting,
                bloodSugarPostMeal: bloodSugarPostMeal,
                temperatureCelsius: temperatureCelsius,
                weightKg: weightKg,
                spo2Percent: spo2Percent,
                notes: notes,
                synced: synced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime loggedAt,
                Value<int?> bpSystolic = const Value.absent(),
                Value<int?> bpDiastolic = const Value.absent(),
                Value<double?> bloodSugarFasting = const Value.absent(),
                Value<double?> bloodSugarPostMeal = const Value.absent(),
                Value<double?> temperatureCelsius = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<int?> spo2Percent = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => VitalsEntriesCompanion.insert(
                id: id,
                loggedAt: loggedAt,
                bpSystolic: bpSystolic,
                bpDiastolic: bpDiastolic,
                bloodSugarFasting: bloodSugarFasting,
                bloodSugarPostMeal: bloodSugarPostMeal,
                temperatureCelsius: temperatureCelsius,
                weightKg: weightKg,
                spo2Percent: spo2Percent,
                notes: notes,
                synced: synced,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VitalsEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VitalsEntriesTable,
      VitalsEntry,
      $$VitalsEntriesTableFilterComposer,
      $$VitalsEntriesTableOrderingComposer,
      $$VitalsEntriesTableAnnotationComposer,
      $$VitalsEntriesTableCreateCompanionBuilder,
      $$VitalsEntriesTableUpdateCompanionBuilder,
      (
        VitalsEntry,
        BaseReferences<_$AppDatabase, $VitalsEntriesTable, VitalsEntry>,
      ),
      VitalsEntry,
      PrefetchHooks Function()
    >;
typedef $$MedicinesTableCreateCompanionBuilder =
    MedicinesCompanion Function({
      Value<int> id,
      required String name,
      required String dosage,
      required String frequency,
      Value<int> timesPerDay,
      Value<String> scheduledTimes,
      required DateTime startDate,
      Value<DateTime?> endDate,
      Value<bool> isActive,
    });
typedef $$MedicinesTableUpdateCompanionBuilder =
    MedicinesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> dosage,
      Value<String> frequency,
      Value<int> timesPerDay,
      Value<String> scheduledTimes,
      Value<DateTime> startDate,
      Value<DateTime?> endDate,
      Value<bool> isActive,
    });

final class $$MedicinesTableReferences
    extends BaseReferences<_$AppDatabase, $MedicinesTable, Medicine> {
  $$MedicinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MedicineDosesTable, List<MedicineDose>>
  _medicineDosesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.medicineDoses,
    aliasName: $_aliasNameGenerator(
      db.medicines.id,
      db.medicineDoses.medicineId,
    ),
  );

  $$MedicineDosesTableProcessedTableManager get medicineDosesRefs {
    final manager = $$MedicineDosesTableTableManager(
      $_db,
      $_db.medicineDoses,
    ).filter((f) => f.medicineId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_medicineDosesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MedicinesTableFilterComposer
    extends Composer<_$AppDatabase, $MedicinesTable> {
  $$MedicinesTableFilterComposer({
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

  ColumnFilters<String> get dosage => $composableBuilder(
    column: $table.dosage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timesPerDay => $composableBuilder(
    column: $table.timesPerDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scheduledTimes => $composableBuilder(
    column: $table.scheduledTimes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> medicineDosesRefs(
    Expression<bool> Function($$MedicineDosesTableFilterComposer f) f,
  ) {
    final $$MedicineDosesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicineDoses,
      getReferencedColumn: (t) => t.medicineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicineDosesTableFilterComposer(
            $db: $db,
            $table: $db.medicineDoses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicinesTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicinesTable> {
  $$MedicinesTableOrderingComposer({
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

  ColumnOrderings<String> get dosage => $composableBuilder(
    column: $table.dosage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timesPerDay => $composableBuilder(
    column: $table.timesPerDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheduledTimes => $composableBuilder(
    column: $table.scheduledTimes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MedicinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicinesTable> {
  $$MedicinesTableAnnotationComposer({
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

  GeneratedColumn<String> get dosage =>
      $composableBuilder(column: $table.dosage, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<int> get timesPerDay => $composableBuilder(
    column: $table.timesPerDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scheduledTimes => $composableBuilder(
    column: $table.scheduledTimes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> medicineDosesRefs<T extends Object>(
    Expression<T> Function($$MedicineDosesTableAnnotationComposer a) f,
  ) {
    final $$MedicineDosesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicineDoses,
      getReferencedColumn: (t) => t.medicineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicineDosesTableAnnotationComposer(
            $db: $db,
            $table: $db.medicineDoses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicinesTable,
          Medicine,
          $$MedicinesTableFilterComposer,
          $$MedicinesTableOrderingComposer,
          $$MedicinesTableAnnotationComposer,
          $$MedicinesTableCreateCompanionBuilder,
          $$MedicinesTableUpdateCompanionBuilder,
          (Medicine, $$MedicinesTableReferences),
          Medicine,
          PrefetchHooks Function({bool medicineDosesRefs})
        > {
  $$MedicinesTableTableManager(_$AppDatabase db, $MedicinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> dosage = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                Value<int> timesPerDay = const Value.absent(),
                Value<String> scheduledTimes = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => MedicinesCompanion(
                id: id,
                name: name,
                dosage: dosage,
                frequency: frequency,
                timesPerDay: timesPerDay,
                scheduledTimes: scheduledTimes,
                startDate: startDate,
                endDate: endDate,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String dosage,
                required String frequency,
                Value<int> timesPerDay = const Value.absent(),
                Value<String> scheduledTimes = const Value.absent(),
                required DateTime startDate,
                Value<DateTime?> endDate = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => MedicinesCompanion.insert(
                id: id,
                name: name,
                dosage: dosage,
                frequency: frequency,
                timesPerDay: timesPerDay,
                scheduledTimes: scheduledTimes,
                startDate: startDate,
                endDate: endDate,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MedicinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicineDosesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (medicineDosesRefs) db.medicineDoses,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (medicineDosesRefs)
                    await $_getPrefetchedData<
                      Medicine,
                      $MedicinesTable,
                      MedicineDose
                    >(
                      currentTable: table,
                      referencedTable: $$MedicinesTableReferences
                          ._medicineDosesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MedicinesTableReferences(
                            db,
                            table,
                            p0,
                          ).medicineDosesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.medicineId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MedicinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicinesTable,
      Medicine,
      $$MedicinesTableFilterComposer,
      $$MedicinesTableOrderingComposer,
      $$MedicinesTableAnnotationComposer,
      $$MedicinesTableCreateCompanionBuilder,
      $$MedicinesTableUpdateCompanionBuilder,
      (Medicine, $$MedicinesTableReferences),
      Medicine,
      PrefetchHooks Function({bool medicineDosesRefs})
    >;
typedef $$MedicineDosesTableCreateCompanionBuilder =
    MedicineDosesCompanion Function({
      Value<int> id,
      required int medicineId,
      required DateTime scheduledAt,
      Value<DateTime?> takenAt,
      Value<String> status,
    });
typedef $$MedicineDosesTableUpdateCompanionBuilder =
    MedicineDosesCompanion Function({
      Value<int> id,
      Value<int> medicineId,
      Value<DateTime> scheduledAt,
      Value<DateTime?> takenAt,
      Value<String> status,
    });

final class $$MedicineDosesTableReferences
    extends BaseReferences<_$AppDatabase, $MedicineDosesTable, MedicineDose> {
  $$MedicineDosesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MedicinesTable _medicineIdTable(_$AppDatabase db) =>
      db.medicines.createAlias(
        $_aliasNameGenerator(db.medicineDoses.medicineId, db.medicines.id),
      );

  $$MedicinesTableProcessedTableManager get medicineId {
    final $_column = $_itemColumn<int>('medicine_id')!;

    final manager = $$MedicinesTableTableManager(
      $_db,
      $_db.medicines,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MedicineDosesTableFilterComposer
    extends Composer<_$AppDatabase, $MedicineDosesTable> {
  $$MedicineDosesTableFilterComposer({
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

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicinesTableFilterComposer get medicineId {
    final $$MedicinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicineId,
      referencedTable: $db.medicines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicinesTableFilterComposer(
            $db: $db,
            $table: $db.medicines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicineDosesTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicineDosesTable> {
  $$MedicineDosesTableOrderingComposer({
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

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicinesTableOrderingComposer get medicineId {
    final $$MedicinesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicineId,
      referencedTable: $db.medicines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicinesTableOrderingComposer(
            $db: $db,
            $table: $db.medicines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicineDosesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicineDosesTable> {
  $$MedicineDosesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get takenAt =>
      $composableBuilder(column: $table.takenAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$MedicinesTableAnnotationComposer get medicineId {
    final $$MedicinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicineId,
      referencedTable: $db.medicines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicinesTableAnnotationComposer(
            $db: $db,
            $table: $db.medicines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicineDosesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicineDosesTable,
          MedicineDose,
          $$MedicineDosesTableFilterComposer,
          $$MedicineDosesTableOrderingComposer,
          $$MedicineDosesTableAnnotationComposer,
          $$MedicineDosesTableCreateCompanionBuilder,
          $$MedicineDosesTableUpdateCompanionBuilder,
          (MedicineDose, $$MedicineDosesTableReferences),
          MedicineDose,
          PrefetchHooks Function({bool medicineId})
        > {
  $$MedicineDosesTableTableManager(_$AppDatabase db, $MedicineDosesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicineDosesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicineDosesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicineDosesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> medicineId = const Value.absent(),
                Value<DateTime> scheduledAt = const Value.absent(),
                Value<DateTime?> takenAt = const Value.absent(),
                Value<String> status = const Value.absent(),
              }) => MedicineDosesCompanion(
                id: id,
                medicineId: medicineId,
                scheduledAt: scheduledAt,
                takenAt: takenAt,
                status: status,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int medicineId,
                required DateTime scheduledAt,
                Value<DateTime?> takenAt = const Value.absent(),
                Value<String> status = const Value.absent(),
              }) => MedicineDosesCompanion.insert(
                id: id,
                medicineId: medicineId,
                scheduledAt: scheduledAt,
                takenAt: takenAt,
                status: status,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MedicineDosesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicineId = false}) {
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
                    if (medicineId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.medicineId,
                                referencedTable: $$MedicineDosesTableReferences
                                    ._medicineIdTable(db),
                                referencedColumn: $$MedicineDosesTableReferences
                                    ._medicineIdTable(db)
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

typedef $$MedicineDosesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicineDosesTable,
      MedicineDose,
      $$MedicineDosesTableFilterComposer,
      $$MedicineDosesTableOrderingComposer,
      $$MedicineDosesTableAnnotationComposer,
      $$MedicineDosesTableCreateCompanionBuilder,
      $$MedicineDosesTableUpdateCompanionBuilder,
      (MedicineDose, $$MedicineDosesTableReferences),
      MedicineDose,
      PrefetchHooks Function({bool medicineId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$VitalsEntriesTableTableManager get vitalsEntries =>
      $$VitalsEntriesTableTableManager(_db, _db.vitalsEntries);
  $$MedicinesTableTableManager get medicines =>
      $$MedicinesTableTableManager(_db, _db.medicines);
  $$MedicineDosesTableTableManager get medicineDoses =>
      $$MedicineDosesTableTableManager(_db, _db.medicineDoses);
}
