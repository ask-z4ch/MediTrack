import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../models/user_profile.dart';

part 'profile_dao.g.dart';

@DriftAccessor(tables: [UserProfiles])
class ProfileDao extends DatabaseAccessor<AppDatabase> with _$ProfileDaoMixin {
  ProfileDao(super.db);

  Future<UserProfile?> getProfile() =>
      (select(userProfiles)..limit(1)).getSingleOrNull();

  Future<int> insertProfile(UserProfilesCompanion entry) =>
      into(userProfiles).insert(entry);

  Future<int> updateProfile(UserProfilesCompanion entry) =>
      (update(userProfiles)..where((t) => t.id.equals(entry.id.value))).write(entry);
}
