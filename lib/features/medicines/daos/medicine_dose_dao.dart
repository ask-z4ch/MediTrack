import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../models/medicine_dose.dart';

part 'medicine_dose_dao.g.dart';

@DriftAccessor(tables: [MedicineDoses])
class MedicineDoseDao extends DatabaseAccessor<AppDatabase>
    with _$MedicineDoseDaoMixin {
  MedicineDoseDao(super.db);

  Future<MedicineDose?> getDose(int medicineId, DateTime scheduledAt) =>
      (select(medicineDoses)
            ..where((t) => t.medicineId.equals(medicineId))
            ..where((t) => t.scheduledAt.equals(scheduledAt)))
          .getSingleOrNull();

  Future<int> createDose(MedicineDosesCompanion entry) =>
      into(medicineDoses).insert(entry);

  Future<void> markTaken(int doseId) =>
      (update(medicineDoses)..where((t) => t.id.equals(doseId))).write(
        const MedicineDosesCompanion(
          takenAt: Value(DateTime.now()),
          status: Value('taken'),
        ),
      );

  Future<void> markSkipped(int doseId) =>
      (update(medicineDoses)..where((t) => t.id.equals(doseId))).write(
        const MedicineDosesCompanion(status: Value('skipped')),
      );

  Future<List<MedicineDose>> getDosesInRange(DateTime from, DateTime to) =>
      (select(medicineDoses)
            ..where((t) => t.scheduledAt.isBiggerOrEqualValue(from))
            ..where((t) => t.scheduledAt.isSmallerThanValue(to))
            ..orderBy([(t) => OrderingTerm.asc(t.scheduledAt)]))
          .get();

  Future<List<MedicineDose>> getTodaysDoses() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));
    return (select(medicineDoses)
          ..where((t) => t.scheduledAt.isBiggerOrEqualValue(start))
          ..where((t) => t.scheduledAt.isSmallerThanValue(end))
          ..orderBy([(t) => OrderingTerm.asc(t.scheduledAt)]))
        .get();
  }
}
