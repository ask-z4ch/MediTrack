import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/app_database.dart';
import '../daos/chs_dao.dart';
import '../services/chs_calculator_service.dart';

part 'chs_provider.g.dart';

@riverpod
CHSDao chsDao(ChsDaoRef ref) {
  return ref.read(appDatabaseProvider).cHSDao;
}

@riverpod
CHSCalculatorService chsCalculatorService(ChsCalculatorServiceRef ref) {
  return CHSCalculatorService(
    ref.read(appDatabaseProvider).vitalsDao,
    ref.read(appDatabaseProvider).medicineDoseDao,
  );
}

@riverpod
class CHSNotifier extends _$CHSNotifier {
  @override
  Future<CompanionHealthScore?> build() async {
    return ref.read(chsDaoProvider).getLatest();
  }

  Future<void> recalculate() async {
    state = const AsyncLoading();
    final calculator = ref.read(chsCalculatorServiceProvider);
    final dao = ref.read(chsDaoProvider);

    final companion = await calculator.calculate();
    await dao.insertScore(companion);
    state = AsyncData(await dao.getLatest());
  }
}
