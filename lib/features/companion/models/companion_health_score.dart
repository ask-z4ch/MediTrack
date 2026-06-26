import 'package:drift/drift.dart';

class CompanionHealthScores extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get calculatedAt => dateTime()();
  RealColumn get score => real()();
  RealColumn get loggingFactor => real()();
  RealColumn get vitalsFactor => real()();
  RealColumn get adherenceFactor => real()();
}
