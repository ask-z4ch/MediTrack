import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/app_database.dart';
import '../daos/vitals_dao.dart';
import '../models/vitals_entry.dart';

part 'vitals_provider.g.dart';

@riverpod
VitalsDao vitalsDao(VitalsDaoRef ref) {
  return ref.read(appDatabaseProvider).vitalsDao;
}

@riverpod
Future<VitalsEntry?> todaysVitals(TodaysVitalsRef ref) async {
  final dao = ref.read(vitalsDaoProvider);
  return dao.getVitalsForDate(DateTime.now());
}

@riverpod
Stream<List<VitalsEntry>> recentVitals(RecentVitalsRef ref, int days) {
  return ref.read(vitalsDaoProvider).watchRecentVitals(days);
}
