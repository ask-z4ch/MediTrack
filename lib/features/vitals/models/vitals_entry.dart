import 'package:drift/drift.dart';

class VitalsEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get loggedAt => dateTime()();
  IntColumn get bpSystolic => integer().nullable()();
  IntColumn get bpDiastolic => integer().nullable()();
  RealColumn get bloodSugarFasting => real().nullable()();
  RealColumn get bloodSugarPostMeal => real().nullable()();
  RealColumn get temperatureCelsius => real().nullable()();
  RealColumn get weightKg => real().nullable()();
  IntColumn get spo2Percent => integer().nullable()();
  TextColumn get notes => text().withDefault(const Constant(''))();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
}
