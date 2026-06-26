import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/health_thresholds.dart';
import '../../features/vitals/providers/vitals_provider.dart';
import '../../settings/providers/settings_provider.dart';

class VitalsSummaryRow extends ConsumerWidget {
  const VitalsSummaryRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entry = ref.watch(todaysVitalsProvider).valueOrNull;
    final unit = ref.watch(settingsNotifierProvider).valueOrNull?.sugarUnit ?? 'mgdl';

    final chips = <Widget>[];

    if (entry == null) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16),
        child: GestureDetector(
          onTap: () => context.go('/vitals'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.cardSurface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.textSecondary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Tap to log vitals \u2192',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

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
      final sugarValue = formatSugar(entry.bloodSugarFasting!, unit);
      chips.add(_chip(
        label: 'Sugar',
        value: sugarValue,
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
      padding: const EdgeInsets.only(left: 16),
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
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  )),
              Text(value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Color _bpStatus(int systolic, int diastolic) {
    if (systolic >= 140 || diastolic >= 90) return AppColors.critical;
    if (systolic > 120 || diastolic > 80) return AppColors.borderline;
    return AppColors.normal;
  }

  Color _sugarFastingStatus(double value) {
    if (value >= 126 || value < 70) return AppColors.critical;
    if (value > 100) return AppColors.borderline;
    return AppColors.normal;
  }

  Color _spo2Status(int value) {
    if (value < 90) return AppColors.critical;
    if (value < 95) return AppColors.borderline;
    return AppColors.normal;
  }
}
