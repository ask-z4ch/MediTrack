import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../vitals/providers/vitals_provider.dart';
import '../widgets/blood_sugar_chart.dart';
import '../widgets/bp_chart.dart';

class ChartsScreen extends ConsumerStatefulWidget {
  const ChartsScreen({super.key});
  @override
  ConsumerState<ChartsScreen> createState() => _ChartsScreenState();
}

class _ChartsScreenState extends ConsumerState<ChartsScreen> {
  bool _isWeekly = true;

  @override
  Widget build(BuildContext context) {
    final days = _isWeekly ? 7 : 30;
    final titleInterval = _isWeekly ? 2 : 5;
    final vitalsAsync = ref.watch(recentVitalsProvider(days));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Charts'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child:             ToggleButtons(
              isSelected: [_isWeekly, !_isWeekly],
              onPressed: (index) => setState(() => _isWeekly = index == 0),
              borderRadius: BorderRadius.circular(8),
              constraints: const BoxConstraints(minWidth: 100, minHeight: 36),
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
              selectedColor: AppColors.primary,
              fillColor: AppColors.primary.withValues(alpha: 0.15),
              color: AppColors.textSecondary,
              children: const [Text('Weekly'), Text('Monthly')],
            ),
          ),
          Expanded(
            child: vitalsAsync.when(
              data: (entries) {
                if (entries.isEmpty) {
                  return const Center(child: Text('No vitals logged yet', style: TextStyle(color: AppColors.textSecondary)));
                }
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Blood Pressure',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.textPrimary)),
                      const SizedBox(height: 8),
                      BpChart(entries: entries, titleInterval: titleInterval),
                      const SizedBox(height: 24),
                      const Text('Blood Sugar',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.textPrimary)),
                      const SizedBox(height: 8),
                      BloodSugarChart(entries: entries, titleInterval: titleInterval),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
