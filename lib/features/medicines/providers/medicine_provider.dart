import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/app_database.dart';
import '../daos/medicine_dao.dart';
import '../daos/medicine_dose_dao.dart';
import '../models/medicine.dart';
import '../models/medicine_dose.dart';

part 'medicine_provider.g.dart';

@riverpod
MedicineDao medicineDao(MedicineDaoRef ref) {
  return ref.read(appDatabaseProvider).medicineDao;
}

@riverpod
MedicineDoseDao medicineDoseDao(MedicineDoseDaoRef ref) {
  return ref.read(appDatabaseProvider).medicineDoseDao;
}

@riverpod
Future<List<Medicine>> medicineList(MedicineListRef ref) async {
  final dao = ref.read(medicineDaoProvider);
  return dao.getAllMedicines();
}

@riverpod
Stream<List<Medicine>> activeMedicines(ActiveMedicinesRef ref) {
  return ref.read(medicineDaoProvider).watchActiveMedicines();
}

@riverpod
Stream<List<Medicine>> inactiveMedicines(InactiveMedicinesRef ref) {
  return ref.read(medicineDaoProvider).watchInactiveMedicines();
}

class DoseWithMedicine {
  final MedicineDose dose;
  final Medicine medicine;
  const DoseWithMedicine({required this.dose, required this.medicine});
}

final todaysDosesProvider = FutureProvider<List<DoseWithMedicine>>((ref) async {
  final doseDao = ref.read(medicineDoseDaoProvider);
  final medDao = ref.read(medicineDaoProvider);

  final medicines = await medDao.getActiveMedicines();
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  for (final med in medicines) {
    final times = (jsonDecode(med.scheduledTimes) as List).cast<String>();
    for (final t in times) {
      final parts = t.split(':');
      final scheduledAt = DateTime(
        today.year,
        today.month,
        today.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
      if (scheduledAt.isBefore(now)) continue;
      final existing = await doseDao.getDose(med.id, scheduledAt);
      if (existing == null) {
        await doseDao.createDose(MedicineDosesCompanion(
          medicineId: Value(med.id),
          scheduledAt: Value(scheduledAt),
        ));
      }
    }
  }

  final doses = await doseDao.getTodaysDoses();
  final medMap = {for (final m in medicines) m.id: m};

  return doses
      .where((d) => medMap.containsKey(d.medicineId))
      .map((d) => DoseWithMedicine(dose: d, medicine: medMap[d.medicineId]!))
      .toList();
});
