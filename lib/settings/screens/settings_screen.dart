import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.emergency),
            title: const Text('Emergency Contact'),
            subtitle: const Text('Set SOS contact and test the alert'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/emergency-contact'),
          ),
        ],
      ),
    );
  }
}
