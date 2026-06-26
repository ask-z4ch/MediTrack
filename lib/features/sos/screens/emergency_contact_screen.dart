import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../profile/providers/profile_provider.dart';
import '../services/sos_service.dart';

class EmergencyContactScreen extends ConsumerStatefulWidget {
  const EmergencyContactScreen({super.key});

  @override
  ConsumerState<EmergencyContactScreen> createState() =>
      _EmergencyContactScreenState();
}

class _EmergencyContactScreenState
    extends ConsumerState<EmergencyContactScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _myPhoneController = TextEditingController();
  String _relation = '';

  bool _saving = false;

  static const _relations = [
    'Spouse',
    'Parent',
    'Child',
    'Sibling',
    'Friend',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileNotifierProvider).valueOrNull;
    if (profile != null) {
      _nameController.text = profile.emergencyContactName ?? '';
      _phoneController.text = profile.emergencyContactPhone ?? '';
      _myPhoneController.text = profile.phoneNumber ?? '';
      _relation = profile.emergencyContactRelation ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _myPhoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final myPhone = _myPhoneController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a contact name.')),
      );
      return;
    }
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a phone number.')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      await ref
          .read(profileNotifierProvider.notifier)
          .saveEmergencyContact(
            name: name,
            phone: phone,
            relation: _relation,
            myPhone: myPhone.isNotEmpty ? myPhone : null,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Emergency contact saved.')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _testSos() async {
    final profile = ref.read(profileNotifierProvider).valueOrNull;
    final myPhone = profile?.phoneNumber ?? _myPhoneController.text.trim();

    if (myPhone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter your phone number above to send a test.'),
        ),
      );
      return;
    }

    if (profile == null) return;
    await SOSService().sendSOS(
      profile: profile,
      contactPhone: myPhone,
      isTest: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contact'),
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Set a contact to notify in case of an emergency.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Contact Name',
                hintText: 'e.g. Jane Doe',
                prefixIcon: Icon(Icons.person),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Emergency Contact Phone',
                hintText: 'e.g. +1 555 123 4567',
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _relation.isEmpty ? null : _relation,
              decoration: const InputDecoration(
                labelText: 'Relationship',
                prefixIcon: Icon(Icons.family_restroom),
              ),
              items: _relations
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: (v) => setState(() => _relation = v ?? ''),
            ),
            const SizedBox(height: 20),
            Text(
              'Your Phone Number (for test SOS)',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _myPhoneController,
              decoration: const InputDecoration(
                hintText: 'e.g. +1 555 987 6543',
                prefixIcon: Icon(Icons.person_outline),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(_saving ? 'Saving...' : 'Save Emergency Contact'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _testSos,
                icon: const Icon(Icons.warning_amber, color: Colors.orange),
                label: const Text('Send Test SOS to Yourself'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.orange,
                  side: const BorderSide(color: Colors.orange),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
