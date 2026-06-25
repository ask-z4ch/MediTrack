import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'package:meditrack/features/medicines/daos/medicine_dao.dart';
import 'package:meditrack/features/medicines/daos/medicine_dose_dao.dart';
import 'package:meditrack/features/medicines/models/medicine.dart';
import 'package:meditrack/features/medicines/models/medicine_dose.dart';
import 'package:meditrack/features/profile/daos/profile_dao.dart';
import 'package:meditrack/features/profile/models/user_profile.dart';
import 'package:meditrack/features/symptoms/models/symptom_entry.dart';
import 'package:meditrack/features/vitals/daos/vitals_dao.dart';
import 'package:meditrack/features/vitals/models/vitals_entry.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [UserProfiles, VitalsEntries, Medicines, MedicineDoses, SymptomEntries],
  daos: [ProfileDao, VitalsDao, MedicineDao, MedicineDoseDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(medicines);
            await m.createTable(medicineDoses);
          }
          if (from < 3) {
            await m.createTable(symptomEntries);
          }
        },
      );
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'meditrack.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
