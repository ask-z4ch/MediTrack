import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../models/doctor_visit.dart';

part 'doctor_visit_dao.g.dart';

@DriftAccessor(tables: [DoctorVisits])
class DoctorVisitDao extends DatabaseAccessor<AppDatabase>
    with _$DoctorVisitDaoMixin {
  DoctorVisitDao(super.db);

  Future<int> insertVisit(DoctorVisitsCompanion entry) =>
      into(doctorVisits).insert(entry);

  Future<List<DoctorVisit>> getAllVisits() =>
      (select(doctorVisits)
            ..orderBy([(t) => OrderingTerm.desc(t.visitDate)]))
          .get();

  Stream<List<DoctorVisit>> watchAllVisits() =>
      (select(doctorVisits)
            ..orderBy([(t) => OrderingTerm.desc(t.visitDate)]))
          .watch();

  Future<DoctorVisit?> getNextUpcomingFollowUp() async {
    final now = DateTime.now();
    return (select(doctorVisits)
          ..where((t) => t.followUpDate.isBiggerOrEqualValue(now))
          ..orderBy([(t) => OrderingTerm.asc(t.followUpDate)])
          ..limit(1))
        .getSingleOrNull();
  }
}
