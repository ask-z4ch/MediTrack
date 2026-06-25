import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/health_thresholds.dart';
import '../../../core/database/app_database.dart';
import '../providers/vitals_provider.dart';

class VitalsSummaryCard extends ConsumerStatefulWidget {
  const VitalsSummaryCard({super.key});

  @override
  ConsumerState<VitalsSummaryCard> createState() => _VitalsSummaryCardState();
}

class _VitalsSummaryCardState extends ConsumerState<VitalsSummaryCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  VitalStatus _bpSystolicStatus(int v) {
    if (v >= 140) return VitalStatus.critical;
    if (v > BPThreshold.normalSystolicMax) return VitalStatus.borderline;
    return VitalStatus.normal;
  }

  VitalStatus _bpDiastolicStatus(int v) {
    if (v >= 90) return VitalStatus.critical;
    if (v > BPThreshold.normalDiastolicMax) return VitalStatus.borderline;
    return VitalStatus.normal;
  }

  VitalStatus _sugarFastingStatus(double v) {
    if (v < BloodSugarThreshold.hypoMin) return VitalStatus.critical;
    if (v >= 126) return VitalStatus.critical;
    if (v > BloodSugarThreshold.fastingNormalMax) return VitalStatus.borderline;
    return VitalStatus.normal;
  }

  VitalStatus _sugarPostMealStatus(double v) {
    if (v < BloodSugarThreshold.hypoMin) return VitalStatus.critical;
    if (v >= 200) return VitalStatus.critical;
    if (v > BloodSugarThreshold.postMealNormalMax) return VitalStatus.borderline;
    return VitalStatus.normal;
  }

  VitalStatus _tempStatus(double v) {
    if (v <= TemperatureThreshold.criticalLowC || v > TemperatureThreshold.borderlineMaxC) {
      return VitalStatus.critical;
    }
    if (v < TemperatureThreshold.normalMinC || v > TemperatureThreshold.normalMaxC) {
      return VitalStatus.borderline;
    }
    return VitalStatus.normal;
  }

  VitalStatus _spo2Status(int v) {
    if (v < SpO2Threshold.borderlineMin) return VitalStatus.critical;
    if (v < SpO2Threshold.normalMin) return VitalStatus.borderline;
    return VitalStatus.normal;
  }

  Color _dotColor(VitalStatus status) {
    return switch (status) {
      VitalStatus.normal => AppColors.normal,
      VitalStatus.borderline => AppColors.borderline,
      VitalStatus.critical => AppColors.critical,
    };
  }

  Widget _dot(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _vitalRow(String label, String value, Color dotColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          _dot(dotColor),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 14)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todaysVitalsAsync = ref.watch(todaysVitalsProvider);

    return todaysVitalsAsync.when(
      data: (entry) => entry == null ? _buildEmptyState() : _buildVitalsCard(entry),
      loading: () => _buildEmptyState(),
      error: (_, __) => _buildEmptyState(),
    );
  }

  Widget _buildEmptyState() {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (context, child) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: AppColors.primaryTeal.withValues(alpha: _pulseAnim.value),
              width: 2,
            ),
          ),
          child: InkWell(
            onTap: () => context.go('/vitals'),
            borderRadius: BorderRadius.circular(12),
            child: const Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(Icons.monitor_heart_outlined, size: 48, color: AppColors.primaryTeal),
                  SizedBox(height: 12),
                  Text(
                    "Tap to log today's vitals",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVitalsCard(VitalsEntry entry) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Today's Vitals", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const Divider(),
            if (entry.bpSystolic != null && entry.bpDiastolic != null)
              _vitalRow(
                'Blood Pressure',
                '${entry.bpSystolic}/${entry.bpDiastolic} mmHg',
                _dotColor(_bpSystolicStatus(entry.bpSystolic!)),
              ),
            if (entry.bloodSugarFasting != null)
              _vitalRow(
                'Blood Sugar (fasting)',
                '${entry.bloodSugarFasting!.toStringAsFixed(1)} mg/dL',
                _dotColor(_sugarFastingStatus(entry.bloodSugarFasting!)),
              ),
            if (entry.bloodSugarPostMeal != null)
              _vitalRow(
                'Blood Sugar (post-meal)',
                '${entry.bloodSugarPostMeal!.toStringAsFixed(1)} mg/dL',
                _dotColor(_sugarPostMealStatus(entry.bloodSugarPostMeal!)),
              ),
            if (entry.temperatureCelsius != null)
              _vitalRow(
                'Temperature',
                '${entry.temperatureCelsius!.toStringAsFixed(1)} °C',
                _dotColor(_tempStatus(entry.temperatureCelsius!)),
              ),
            if (entry.weightKg != null)
              _vitalRow('Weight', '${entry.weightKg!.toStringAsFixed(1)} kg', AppColors.normal),
            if (entry.spo2Percent != null)
              _vitalRow('SpO2', '${entry.spo2Percent}%', _dotColor(_spo2Status(entry.spo2Percent!))),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => context.go('/vitals'),
                child: const Text('Tap for details ›'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
