import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../providers/doctor_visit_provider.dart';

class AddDoctorVisitScreen extends ConsumerStatefulWidget {
  const AddDoctorVisitScreen({super.key});

  @override
  ConsumerState<AddDoctorVisitScreen> createState() => _AddDoctorVisitScreenState();
}

class _AddDoctorVisitScreenState extends ConsumerState<AddDoctorVisitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _specialtyCtrl = TextEditingController();
  final _clinicCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  DateTime _visitDate = DateTime.now();
  DateTime? _followUpDate;
  bool _noFollowUp = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _specialtyCtrl.dispose();
    _clinicCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickVisitDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _visitDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (d != null) setState(() => _visitDate = d);
  }

  Future<void> _pickFollowUpDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _followUpDate ?? _visitDate.add(const Duration(days: 30)),
      firstDate: _visitDate.add(const Duration(days: 1)),
      lastDate: _visitDate.add(const Duration(days: 365 * 5)),
    );
    if (d != null) setState(() => _followUpDate = d);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final dao = ref.read(doctorVisitDaoProvider);
    await dao.insertVisit(
      DoctorVisitsCompanion(
        doctorName: Value(_nameCtrl.text.trim()),
        specialty: Value(_specialtyCtrl.text.trim()),
        clinicOrHospital: Value(_clinicCtrl.text.trim()),
        visitDate: Value(_visitDate),
        followUpDate: _noFollowUp ? const Value(null) : Value(_followUpDate),
        notes: Value(_notesCtrl.text.trim()),
      ),
    );

    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Doctor Visit')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Doctor Name'),
              validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _specialtyCtrl,
              decoration: const InputDecoration(
                labelText: 'Specialty',
                hintText: 'e.g. Cardiologist, GP',
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _clinicCtrl,
              decoration: const InputDecoration(
                labelText: 'Clinic / Hospital',
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 24),
            Text('Visit Date', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            ListTile(
              title: Text(
                '${_visitDate.day}/${_visitDate.month}/${_visitDate.year}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickVisitDate,
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('No follow-up'),
              value: _noFollowUp,
              onChanged: (v) => setState(() => _noFollowUp = v),
            ),
            if (!_noFollowUp)
              ListTile(
                title: Text(
                  _followUpDate != null
                      ? '${_followUpDate!.day}/${_followUpDate!.month}/${_followUpDate!.year}'
                      : 'Select follow-up date',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickFollowUpDate,
              ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _notesCtrl,
              decoration: const InputDecoration(
                labelText: 'Notes',
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 24),
            // Prescriptions section (coming in next commits)
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Save Visit'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
