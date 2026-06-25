import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../models/medicine.dart';

part 'medicine_dao.g.dart';

@DriftAccessor(tables: [Medicines])
class MedicineDao extends DatabaseAccessor<AppDatabase> with _$MedicineDaoMixin {
  MedicineDao(super.db);

  Future<int> insertMedicine(MedicinesCompanion entry) =>
      into(medicines).insert(entry);

  Future<List<Medicine>> getAllMedicines() => select(medicines).get();
}
