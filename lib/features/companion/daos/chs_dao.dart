import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../models/companion_health_score.dart';

part 'chs_dao.g.dart';

@DriftAccessor(tables: [CompanionHealthScores])
class CHSDao extends DatabaseAccessor<AppDatabase> with _$CHSDaoMixin {
  CHSDao(super.db);

  Future<int> insertScore(CompanionHealthScoresCompanion entry) =>
      into(companionHealthScores).insert(entry,
          mode: InsertMode.insertOrReplace);

  Future<CompanionHealthScore?> getLatest() =>
      (select(companionHealthScores)
            ..orderBy([(t) => OrderingTerm.desc(t.calculatedAt)])
            ..limit(1))
          .getSingleOrNull();

  Future<List<CompanionHealthScore>> getLast30Days() {
    final from = DateTime.now().subtract(const Duration(days: 30));
    return (select(companionHealthScores)
          ..where((t) => t.calculatedAt.isBiggerOrEqualValue(from))
          ..orderBy([(t) => OrderingTerm.asc(t.calculatedAt)]))
        .get();
  }
}
