import 'package:flutter/material.dart';

import '../widgets/profile_form.dart';

class ProfileSetupScreen extends StatelessWidget {
  const ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: ProfileForm()),
    );
  }
}
