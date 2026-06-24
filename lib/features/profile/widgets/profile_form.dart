import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/database/app_database.dart';
import '../daos/profile_dao.dart';

class ProfileForm extends ConsumerStatefulWidget {
  final UserProfile? existingProfile;

  const ProfileForm({super.key, this.existingProfile});

  @override
  ConsumerState<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends ConsumerState<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _conditionController = TextEditingController();
  final _allergyController = TextEditingController();

  late DateTime? _dateOfBirth;
  late String? _bloodGroup;
  late List<String> _conditions;
  late List<String> _allergies;

  bool get _isEditMode => widget.existingProfile != null;

  @override
  void initState() {
    super.initState();
    final p = widget.existingProfile;
    _nameController.text = p?.name ?? '';
    _dateOfBirth = p?.dateOfBirth;
    _bloodGroup = p?.bloodGroup;
    _conditions = (p?.activeConditions ?? '').split(',').where((s) => s.isNotEmpty).toList();
    _allergies = (p?.allergies ?? '').split(',').where((s) => s.isNotEmpty).toList();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _conditionController.dispose();
    _allergyController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? now,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() => _dateOfBirth = picked);
    }
  }

  void _addCondition() {
    final text = _conditionController.text.trim();
    if (text.isNotEmpty && !_conditions.contains(text)) {
      setState(() => _conditions.add(text));
      _conditionController.clear();
    }
  }

  void _addAllergy() {
    final text = _allergyController.text.trim();
    if (text.isNotEmpty && !_allergies.contains(text)) {
      setState(() => _allergies.add(text));
      _allergyController.clear();
    }
  }

  UserProfilesCompanion _buildCompanion() {
    final existing = widget.existingProfile;
    return UserProfilesCompanion(
      id: existing != null ? Value(existing.id) : const Value.absent(),
      name: Value(_nameController.text.trim()),
      dateOfBirth: _dateOfBirth != null
          ? Value(DateTime(_dateOfBirth!.year, _dateOfBirth!.month, _dateOfBirth!.day))
          : const Value(null),
      bloodGroup: Value(_bloodGroup),
      activeConditions: Value(_conditions.join(',')),
      allergies: Value(_allergies.join(',')),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final dao = ProfileDao(ref.read(appDatabaseProvider));
    final companion = _buildCompanion();

    if (_isEditMode) {
      await dao.updateProfile(companion);
      if (mounted) context.pop();
    } else {
      await dao.insertProfile(companion);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('has_completed_profile', true);
      if (mounted) context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_isEditMode) ...[
              const SizedBox(height: 32),
              Icon(Icons.favorite, size: 64, color: AppColors.primaryTeal),
              const SizedBox(height: 16),
              Text(
                'Welcome to MediTrack',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Set up your profile to get started',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
            ],
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Name is required';
                if (v.trim().length < 2) return 'Name must be at least 2 characters';
                return null;
              },
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Date of Birth',
                prefixIcon: const Icon(Icons.calendar_today),
                border: const OutlineInputBorder(),
                hintText: _dateOfBirth != null
                    ? DateFormat('MM/dd/yyyy').format(_dateOfBirth!)
                    : 'Tap to select',
              ),
              onTap: _pickDate,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _bloodGroup,
              decoration: const InputDecoration(
                labelText: 'Blood Group',
                prefixIcon: Icon(Icons.bloodtype),
                border: OutlineInputBorder(),
              ),
              items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                  .map((bg) => DropdownMenuItem(value: bg, child: Text(bg)))
                  .toList(),
              onChanged: (v) => setState(() => _bloodGroup = v),
            ),
            const SizedBox(height: 24),
            Text('Active Conditions', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                ..._conditions.map((c) => Chip(
                  label: Text(c),
                  onDeleted: () => setState(() => _conditions.remove(c)),
                )),
                SizedBox(
                  width: 140,
                  child: TextField(
                    controller: _conditionController,
                    decoration: const InputDecoration(
                      hintText: 'Add condition',
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    onSubmitted: (_) => _addCondition(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  color: AppColors.primaryTeal,
                  onPressed: _addCondition,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Allergies', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                ..._allergies.map((a) => Chip(
                  label: Text(a),
                  onDeleted: () => setState(() => _allergies.remove(a)),
                )),
                SizedBox(
                  width: 140,
                  child: TextField(
                    controller: _allergyController,
                    decoration: const InputDecoration(
                      hintText: 'Add allergy',
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    onSubmitted: (_) => _addAllergy(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  color: AppColors.primaryTeal,
                  onPressed: _addAllergy,
                ),
              ],
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _save,
              icon: Icon(_isEditMode ? Icons.update : Icons.save),
              label: Text(_isEditMode ? 'Update Profile' : 'Save Profile'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
