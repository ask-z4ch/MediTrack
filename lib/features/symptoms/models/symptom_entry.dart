import 'package:drift/drift.dart';

class SymptomEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get symptomName => text()();
  IntColumn get severity => integer()();
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get loggedAt => dateTime()();
}
