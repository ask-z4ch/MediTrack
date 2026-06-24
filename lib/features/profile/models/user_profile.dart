import 'package:drift/drift.dart';

class UserProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  DateTimeColumn get dateOfBirth => dateTime().nullable()();
  TextColumn get bloodGroup => text().nullable()();
  TextColumn get activeConditions => text().withDefault(const Constant(''))();
  TextColumn get allergies => text().withDefault(const Constant(''))();
  TextColumn get emergencyContactName => text().nullable()();
  TextColumn get emergencyContactPhone => text().nullable()();
  TextColumn get emergencyContactRelation => text().nullable()();
}
