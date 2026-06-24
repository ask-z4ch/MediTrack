import 'package:flutter/material.dart';

import '../../../core/database/app_database.dart';
import '../../../core/constants/app_colors.dart';
import '../widgets/profile_form.dart';

class EditProfileScreen extends StatelessWidget {
  final UserProfile profile;

  const EditProfileScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(child: ProfileForm(existingProfile: profile)),
    );
  }
}
