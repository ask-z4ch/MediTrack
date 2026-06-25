import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/health_thresholds.dart';
import '../../../shared/widgets/color_coded_input.dart';

class VitalsLogScreen extends ConsumerStatefulWidget {
  const VitalsLogScreen({super.key});

  @override
  ConsumerState<VitalsLogScreen> createState() => _VitalsLogScreenState();
}

class _VitalsLogScreenState extends ConsumerState<VitalsLogScreen> {
  final _bpSystolicCtrl = TextEditingController();
  final _bpDiastolicCtrl = TextEditingController();
  final _sugarCtrl = TextEditingController();
  final _tempCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _spo2Ctrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  bool _sugarIsFasting = true;

  @override
  void dispose() {
    _bpSystolicCtrl.dispose();
    _bpDiastolicCtrl.dispose();
    _sugarCtrl.dispose();
    _tempCtrl.dispose();
    _weightCtrl.dispose();
    _spo2Ctrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  VitalStatus _bpDiastolicStatus(String val) {
    final v = int.tryParse(val);
    if (v == null) return VitalStatus.normal;
    if (v >= 90) return VitalStatus.critical;
    if (v > BPThreshold.normalDiastolicMax) return VitalStatus.borderline;
    return VitalStatus.normal;
  }

  VitalStatus _sugarStatus(String val) {
    final v = double.tryParse(val);
    if (v == null) return VitalStatus.normal;
    if (v < BloodSugarThreshold.hypoMin) return VitalStatus.critical;
    if (_sugarIsFasting) {
      if (v >= 126) return VitalStatus.critical;
      if (v > BloodSugarThreshold.fastingNormalMax) return VitalStatus.borderline;
    } else {
      if (v >= 200) return VitalStatus.critical;
      if (v > BloodSugarThreshold.postMealNormalMax) return VitalStatus.borderline;
    }
    return VitalStatus.normal;
  }

  VitalStatus _tempStatus(String val) {
    final v = double.tryParse(val);
    if (v == null) return VitalStatus.normal;
    if (v <= TemperatureThreshold.criticalLowC || v > TemperatureThreshold.borderlineMaxC) return VitalStatus.critical;
    if (v < TemperatureThreshold.normalMinC || v > TemperatureThreshold.normalMaxC) return VitalStatus.borderline;
    return VitalStatus.normal;
  }

  VitalStatus _spo2Status(String val) {
    final v = double.tryParse(val);
    if (v == null) return VitalStatus.normal;
    if (v < SpO2Threshold.borderlineMin) return VitalStatus.critical;
    if (v < SpO2Threshold.normalMin) return VitalStatus.borderline;
    return VitalStatus.normal;
  }

  VitalStatus _weightStatus(String val) {
    double.tryParse(val);
    return VitalStatus.normal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log Vitals')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _sectionLabel('Blood Pressure'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ColorCodedInput(
                    label: 'Systolic',
                    suffix: 'mmHg',
                    controller: _bpSystolicCtrl,
                    statusEvaluator: (val) {
                      final v = int.tryParse(val);
                      if (v == null) return VitalStatus.normal;
                      if (v < BPThreshold.normalSystolicMax) return VitalStatus.normal;
                      if (v <= BPThreshold.borderlineSystolicMax) return VitalStatus.borderline;
                      return VitalStatus.critical;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ColorCodedInput(
                    label: 'Diastolic',
                    suffix: 'mmHg',
                    controller: _bpDiastolicCtrl,
                    statusEvaluator: _bpDiastolicStatus,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _sectionLabel('Blood Sugar'),
            const SizedBox(height: 8),
            ColorCodedInput(
              label: 'Blood Sugar',
              suffix: _sugarIsFasting ? 'mg/dL (fasting)' : 'mg/dL (post-meal)',
              controller: _sugarCtrl,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              statusEvaluator: _sugarStatus,
            ),
            const SizedBox(height: 8),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Fasting')),
                ButtonSegment(value: false, label: Text('Post-Meal')),
              ],
              selected: {_sugarIsFasting},
              onSelectionChanged: (v) => setState(() => _sugarIsFasting = v.first),
            ),
            const SizedBox(height: 24),
            _sectionLabel('Temperature'),
            const SizedBox(height: 8),
            ColorCodedInput(
              label: 'Temperature',
              suffix: '°C',
              controller: _tempCtrl,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              statusEvaluator: _tempStatus,
            ),
            const SizedBox(height: 24),
            _sectionLabel('Weight'),
            const SizedBox(height: 8),
            ColorCodedInput(
              label: 'Weight',
              suffix: 'kg',
              controller: _weightCtrl,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              statusEvaluator: _weightStatus,
            ),
            const SizedBox(height: 24),
            _sectionLabel('SpO2'),
            const SizedBox(height: 8),
            ColorCodedInput(
              label: 'SpO2',
              suffix: '%',
              controller: _spo2Ctrl,
              statusEvaluator: _spo2Status,
            ),
            const SizedBox(height: 24),
            _sectionLabel('Notes'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _notesCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Optional notes...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.save),
              label: const Text('Log Vitals'),
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

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}
