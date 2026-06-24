import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/app_database.dart';
import '../daos/profile_dao.dart';

part 'profile_provider.g.dart';

@riverpod
ProfileDao profileDao(ProfileDaoRef ref) {
  return ref.read(appDatabaseProvider).profileDao;
}

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  Future<UserProfile?> build() async {
    final dao = ref.read(profileDaoProvider);
    return dao.getProfile();
  }

  Future<void> saveProfile(UserProfilesCompanion profile) async {
    final dao = ref.read(profileDaoProvider);
    final existing = await dao.getProfile();
    if (existing == null) {
      await dao.insertProfile(profile);
    } else {
      await dao.updateProfile(
        profile.copyWith(id: Value(existing.id)),
      );
    }
    ref.invalidateSelf();
  }
}
