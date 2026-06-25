import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/app_database.dart';
import '../daos/medicine_dao.dart';
import '../models/medicine.dart';

part 'medicine_provider.g.dart';

@riverpod
MedicineDao medicineDao(MedicineDaoRef ref) {
  return ref.read(appDatabaseProvider).medicineDao;
}

@riverpod
Future<List<Medicine>> medicineList(MedicineListRef ref) async {
  final dao = ref.read(medicineDaoProvider);
  return dao.getAllMedicines();
}
