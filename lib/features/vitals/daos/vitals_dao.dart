import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../models/vitals_entry.dart';

part 'vitals_dao.g.dart';

@DriftAccessor(tables: [VitalsEntries])
class VitalsDao extends DatabaseAccessor<AppDatabase> with _$VitalsDaoMixin {
  VitalsDao(super.db);

  Future<int> insertVitals(VitalsEntriesCompanion entry) =>
      into(vitalsEntries).insert(entry);

  Future<VitalsEntry?> getVitalsForDate(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return (select(vitalsEntries)
          ..where((t) => t.loggedAt.isBiggerOrEqualValue(start))
          ..where((t) => t.loggedAt.isSmallerThanValue(end)))
        .getSingleOrNull();
  }

  Future<List<VitalsEntry>> getVitalsInRange(DateTime from, DateTime to) =>
      (select(vitalsEntries)
            ..where((t) => t.loggedAt.isBiggerOrEqualValue(from))
            ..where((t) => t.loggedAt.isSmallerThanValue(to))
            ..orderBy([(t) => OrderingTerm.asc(t.loggedAt)]))
          .get();

  Stream<List<VitalsEntry>> watchRecentVitals(int days) {
    final from = DateTime.now().subtract(Duration(days: days));
    return (select(vitalsEntries)
          ..where((t) => t.loggedAt.isBiggerOrEqualValue(from))
          ..orderBy([(t) => OrderingTerm.desc(t.loggedAt)])
        ).watch();
  }

  Future<List<VitalsEntry>> getUnsynced() =>
      (select(vitalsEntries)..where((t) => t.synced.equals(false))).get();

  Future<void> markAsSynced(int id) =>
      (update(vitalsEntries)..where((t) => t.id.equals(id)))
          .write(const VitalsEntriesCompanion(synced: Value(true)));
}
