import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _lastSynced = '';

  @override
  void initState() {
    super.initState();
    _loadSyncTimestamp();
  }

  Future<void> _loadSyncTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('last_sync_at');
    if (stored == null) {
      setState(() => _lastSynced = 'Not synced yet');
      return;
    }
    final dt = DateTime.tryParse(stored);
    if (dt == null) {
      setState(() => _lastSynced = 'Not synced yet');
      return;
    }
    setState(() => _lastSynced = _relativeTime(dt));
  }

  String _relativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    return '${diff.inDays} days ago';
  }

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
          const Divider(),
          ListTile(
            leading: const Icon(Icons.sync),
            title: const Text('Sync Status'),
            subtitle: Text(_lastSynced),
          ),
        ],
      ),
    );
  }
}
