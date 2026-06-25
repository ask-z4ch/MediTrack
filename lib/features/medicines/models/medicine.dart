import 'package:drift/drift.dart';

class Medicines extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get dosage => text()();
  TextColumn get frequency => text()();
  IntColumn get timesPerDay => integer().withDefault(const Constant(1))();
  TextColumn get scheduledTimes => text().withDefault(const Constant('[]'))();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
