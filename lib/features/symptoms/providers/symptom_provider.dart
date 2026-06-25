import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/app_database.dart';
import '../daos/symptom_dao.dart';

part 'symptom_provider.g.dart';

@riverpod
SymptomDao symptomDao(SymptomDaoRef ref) {
  return ref.read(appDatabaseProvider).symptomDao;
}
