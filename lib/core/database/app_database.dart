import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'package:meditrack/features/profile/daos/profile_dao.dart';
import 'package:meditrack/features/profile/models/user_profile.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [UserProfiles], daos: [ProfileDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
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
