import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../models/symptom_entry.dart';

part 'symptom_dao.g.dart';

@DriftAccessor(tables: [SymptomEntries])
class SymptomDao extends DatabaseAccessor<AppDatabase> with _$SymptomDaoMixin {
  SymptomDao(super.db);

  Future<int> insertSymptom(SymptomEntriesCompanion entry) =>
      into(symptomEntries).insert(entry);

  Future<List<SymptomEntry>> getSymptomsInRange(DateTime from, DateTime to) =>
      (select(symptomEntries)
            ..where((t) => t.loggedAt.isBiggerOrEqualValue(from))
            ..where((t) => t.loggedAt.isSmallerThanValue(to))
            ..orderBy([(t) => OrderingTerm.desc(t.loggedAt)]))
          .get();

  Stream<List<SymptomEntry>> watchAll() =>
      (select(symptomEntries)
            ..orderBy([(t) => OrderingTerm.desc(t.loggedAt)]))
          .watch();
}
