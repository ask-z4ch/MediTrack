import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../models/medicine.dart';

part 'medicine_dao.g.dart';

@DriftAccessor(tables: [Medicines])
class MedicineDao extends DatabaseAccessor<AppDatabase> with _$MedicineDaoMixin {
  MedicineDao(super.db);

  Future<int> insertMedicine(MedicinesCompanion entry) =>
      into(medicines).insert(entry);

  Future<Medicine?> getMedicine(int id) =>
      (select(medicines)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Medicine>> getAllMedicines() => select(medicines).get();

  Stream<List<Medicine>> watchActiveMedicines() =>
      (select(medicines)..where((t) => t.isActive.equals(true))).watch();

  Stream<List<Medicine>> watchInactiveMedicines() =>
      (select(medicines)..where((t) => t.isActive.equals(false))).watch();

  Future<void> toggleActive(int id, bool isActive) =>
      (update(medicines)..where((t) => t.id.equals(id)))
          .write(MedicinesCompanion(isActive: Value(isActive)));
}
