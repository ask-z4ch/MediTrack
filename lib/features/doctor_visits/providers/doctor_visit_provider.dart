import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/app_database.dart';
import '../daos/doctor_visit_dao.dart';

part 'doctor_visit_provider.g.dart';

@riverpod
DoctorVisitDao doctorVisitDao(DoctorVisitDaoRef ref) {
  return ref.read(appDatabaseProvider).doctorVisitDao;
}

final allVisitsProvider = StreamProvider<List<DoctorVisit>>((ref) {
  return ref.read(doctorVisitDaoProvider).watchAllVisits();
});
