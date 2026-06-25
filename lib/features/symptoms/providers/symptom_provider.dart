import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/app_database.dart';
import '../daos/symptom_dao.dart';
import '../models/symptom_entry.dart';

part 'symptom_provider.g.dart';

@riverpod
SymptomDao symptomDao(SymptomDaoRef ref) {
  return ref.read(appDatabaseProvider).symptomDao;
}

final symptomListProvider = FutureProvider<List<SymptomEntry>>((ref) async {
  final dao = ref.read(symptomDaoProvider);
  return dao.getSymptomsInRange(
    DateTime(2000),
    DateTime(2100),
  );
});
