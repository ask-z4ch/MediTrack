import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart';

import '../../../core/services/notification_service.dart';
import '../daos/medicine_dao.dart';
import '../models/medicine.dart';
import '../providers/medicine_provider.dart';

class AddMedicineScreen extends ConsumerStatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  ConsumerState<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends ConsumerState<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _dosageCtrl = TextEditingController();
  final _hoursCtrl = TextEditingController();

  String _frequency = 'once_daily';
  int _timesPerDay = 1;
  List<TimeOfDay> _times = [];
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  bool _noEndDate = true;

  static const _freqOptions = [
    ('once_daily', 'Once Daily', 1),
    ('twice_daily', 'Twice Daily', 2),
    ('three_times_daily', 'Three Times Daily', 3),
    ('every_x_hours', 'Every X Hours', 1),
  ];

  @override
  void initState() {
    super.initState();
    _times = [TimeOfDay.now()];
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dosageCtrl.dispose();
    _hoursCtrl.dispose();
    super.dispose();
  }

  void _onFrequencyChanged(String value) {
    final entry = _freqOptions.firstWhere((e) => e.$1 == value);
    final count = entry.$3;
    setState(() {
      _frequency = value;
      _timesPerDay = count;
      _times = List.generate(count, (_) => TimeOfDay.now());
    });
  }

  void _onHoursChanged(String val) {
    final hours = int.tryParse(val);
    if (hours == null || hours <= 0) return;
    final count = (24 / hours).ceil();
    setState(() {
      _timesPerDay = count;
      _times = List.generate(count, (i) {
        if (i < _times.length) return _times[i];
        final base = _times.isNotEmpty ? _times[0] : TimeOfDay.now();
        final totalMinutes = base.hour * 60 + base.minute + i * hours * 60;
        return TimeOfDay(hour: (totalMinutes ~/ 60) % 24, minute: totalMinutes % 60);
      });
    });
  }

  Future<void> _pickTime(int index) async {
    final t = await showTimePicker(context: context, initialTime: _times[index]);
    if (t != null) {
      setState(() => _times[index] = t);
    }
  }

  Future<void> _pickStartDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (d != null) setState(() => _startDate = d);
  }

  Future<void> _pickEndDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate.add(const Duration(days: 30)),
      firstDate: _startDate.add(const Duration(days: 1)),
      lastDate: _startDate.add(const Duration(days: 365 * 5)),
    );
    if (d != null) setState(() => _endDate = d);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (!await NotificationService.requestExactAlarmPermission()) {
      final granted = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Exact Alarm Permission'),
          content: const Text(
            'MediTrack needs exact alarm permission to deliver medicine reminders on time. '
            'Please toggle it on in the next screen.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Open Settings'),
            ),
          ],
        ),
      );
      if (!granted || !await NotificationService.requestExactAlarmPermission()) return;
    }

    final timesStr = jsonEncode(_times.map((t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}').toList());

    final dao = ref.read(medicineDaoProvider);
    await dao.insertMedicine(
      MedicinesCompanion(
        name: Value(_nameCtrl.text.trim()),
        dosage: Value(_dosageCtrl.text.trim()),
        frequency: Value(_frequency),
        timesPerDay: Value(_timesPerDay),
        scheduledTimes: Value(timesStr),
        startDate: Value(_startDate),
        endDate: _noEndDate ? const Value(null) : Value(_endDate),
      ),
    );

    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Medicine')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Medicine Name'),
              validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _dosageCtrl,
              decoration: const InputDecoration(
                labelText: 'Dosage',
                hintText: 'e.g. 500mg, 1 tablet',
              ),
              validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null,
            ),
            const SizedBox(height: 24),
            Text('Frequency', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: _freqOptions.map((e) {
                final selected = _frequency == e.$1;
                return FilterChip(
                  label: Text(e.$2),
                  selected: selected,
                  onSelected: (_) => _onFrequencyChanged(e.$1),
                );
              }).toList(),
            ),
            if (_frequency == 'every_x_hours') ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _hoursCtrl,
                decoration: const InputDecoration(
                  labelText: 'Hours between doses',
                  hintText: 'e.g. 8',
                ),
                keyboardType: TextInputType.number,
                onChanged: _onHoursChanged,
              ),
            ],
            const SizedBox(height: 24),
            Text('Scheduled Times', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            ...List.generate(_times.length, (i) {
              return ListTile(
                title: Text(_times[i].format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: () => _pickTime(i),
              );
            }),
            const SizedBox(height: 24),
            Text('Duration', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            ListTile(
              title: const Text('Start Date'),
              subtitle: Text(
                '${_startDate.day}/${_startDate.month}/${_startDate.year}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickStartDate,
            ),
            SwitchListTile(
              title: const Text('No end date'),
              value: _noEndDate,
              onChanged: (v) => setState(() => _noEndDate = v),
            ),
            if (!_noEndDate)
              ListTile(
                title: const Text('End Date'),
                subtitle: Text(
                  _endDate != null
                      ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                      : 'Select end date',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickEndDate,
              ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Save Medicine'),
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
