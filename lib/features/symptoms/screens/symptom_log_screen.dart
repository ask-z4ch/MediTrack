import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart';

import '../daos/symptom_dao.dart';
import '../models/symptom_entry.dart';
import '../providers/symptom_provider.dart';

const _commonSymptoms = [
  'Headache', 'Fatigue', 'Dizziness', 'Nausea',
  'Chest Pain', 'Shortness of Breath', 'Back Pain',
  'Joint Pain', 'Fever', 'Sweating',
];

const _severityLabels = {
  1: 'Mild',
  2: 'Uncomfortable',
  3: 'Moderate',
  4: 'Severe',
  5: 'Unbearable',
};

class SymptomLogScreen extends ConsumerStatefulWidget {
  const SymptomLogScreen({super.key});

  @override
  ConsumerState<SymptomLogScreen> createState() => _SymptomLogScreenState();
}

class _SymptomLogScreenState extends ConsumerState<SymptomLogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  double _severity = 1;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final dao = ref.read(symptomDaoProvider);
    await dao.insertSymptom(SymptomEntriesCompanion(
      symptomName: Value(_nameCtrl.text.trim()),
      severity: Value(_severity.round()),
      notes: Value(_notesCtrl.text.trim()),
      loggedAt: Value(DateTime.now()),
    ));

    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final severityLabel = _severityLabels[_severity.round()] ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Log Symptom')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Symptom Name'),
              validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: _commonSymptoms.map((symptom) {
                final selected = _nameCtrl.text == symptom;
                return FilterChip(
                  label: Text(symptom, style: const TextStyle(fontSize: 13)),
                  selected: selected,
                  onSelected: (_) => setState(() => _nameCtrl.text = _nameCtrl.text == symptom ? '' : symptom),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                const Text('Severity', style: TextStyle(fontSize: 16)),
                const Spacer(),
                Text(
                  severityLabel,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Slider(
              value: _severity,
              min: 1,
              max: 5,
              divisions: 4,
              label: severityLabel,
              onChanged: (v) => setState(() => _severity = v),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _notesCtrl,
              maxLines: 4,
              maxLength: 500,
              decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'Describe your symptoms...',
                border: OutlineInputBorder(),
              ),
              buildCounter: (context, {required int currentLength, required bool isFocused, required int? maxLength}) {
                return Text(
                  '$currentLength / $maxLength',
                  style: TextStyle(
                    fontSize: 12,
                    color: currentLength > (maxLength ?? 500) - 50 ? Colors.orange : Colors.grey,
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Log Symptom'),
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
