import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/vitals/providers/vitals_provider.dart';

class VitalsSummaryRow extends ConsumerWidget {
  const VitalsSummaryRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entry = ref.watch(todaysVitalsProvider).valueOrNull;

    if (entry == null) return const SizedBox.shrink();

    final chips = <Widget>[];

    if (entry.bpSystolic != null && entry.bpDiastolic != null) {
      final status = _bpStatus(entry.bpSystolic!, entry.bpDiastolic!);
      chips.add(_chip(
        label: 'BP',
        value: '${entry.bpSystolic}/${entry.bpDiastolic}',
        statusColor: status,
      ));
    }
    if (entry.bloodSugarFasting != null) {
      final status = _sugarFastingStatus(entry.bloodSugarFasting!);
      chips.add(_chip(
        label: 'Sugar',
        value: '${entry.bloodSugarFasting!.toStringAsFixed(0)}',
        statusColor: status,
      ));
    }
    if (entry.spo2Percent != null) {
      final status = _spo2Status(entry.spo2Percent!);
      chips.add(_chip(
        label: 'SpO2',
        value: '${entry.spo2Percent}%',
        statusColor: status,
      ));
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 10,
        children: chips,
      ),
    );
  }

  Widget _chip({required String label, required String value, required Color statusColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: statusColor),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: statusColor, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(fontSize: 12, color: statusColor, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Color _bpStatus(int systolic, int diastolic) {
    if (systolic >= 140 || diastolic >= 90) return const Color(0xFFEA4335);
    if (systolic > 120 || diastolic > 80) return const Color(0xFFFBBC04);
    return const Color(0xFF34A853);
  }

  Color _sugarFastingStatus(double value) {
    if (value >= 126 || value < 70) return const Color(0xFFEA4335);
    if (value > 100) return const Color(0xFFFBBC04);
    return const Color(0xFF34A853);
  }

  Color _spo2Status(int value) {
    if (value < 90) return const Color(0xFFEA4335);
    if (value < 95) return const Color(0xFFFBBC04);
    return const Color(0xFF34A853);
  }
}
