import 'package:drift/drift.dart';

class DoctorVisits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get doctorName => text()();
  TextColumn get specialty => text().withDefault(const Constant(''))();
  TextColumn get clinicOrHospital => text().withDefault(const Constant(''))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get visitDate => dateTime()();
  DateTimeColumn get followUpDate => dateTime().nullable()();
  TextColumn get prescriptionPaths => text().withDefault(const Constant('[]'))();
}
