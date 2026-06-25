import 'package:drift/drift.dart';

import 'medicine.dart';

class MedicineDoses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get medicineId => integer().references(Medicines, #id)();
  DateTimeColumn get scheduledAt => dateTime()();
  DateTimeColumn get takenAt => dateTime().nullable()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
}
