import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../providers/chs_provider.dart';

class ChsHistoryScreen extends ConsumerWidget {
  const ChsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(chsHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CHS History'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: historyAsync.when(
        data: (scores) {
          if (scores.isEmpty) {
            return const Center(
              child: Text('No health scores yet.'),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 260,
                  child: _buildChart(scores),
                ),
                const SizedBox(height: 20),
                const Text('Latest Breakdown',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                _buildFactorChips(scores.last),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Failed to load scores')),
      ),
    );
  }

  Widget _buildChart(List<CompanionHealthScore> scores) {
    final spots = <FlSpot>[];
    final dates = <DateTime>[];
    for (int i = 0; i < scores.length; i++) {
      spots.add(FlSpot(i.toDouble(), scores[i].score));
      dates.add(scores[i].calculatedAt);
    }

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            color: AppColors.primary,
            barWidth: 2.5,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.normal.withValues(alpha: 0.35),
                  AppColors.borderline.withValues(alpha: 0.2),
                  AppColors.critical.withValues(alpha: 0.1),
                ],
              ),
            ),
          ),
        ],
        extraLinesData: ExtraLinesData(horizontalLines: [
          _thresholdLine(90, '90'),
          _thresholdLine(70, '70'),
          _thresholdLine(50, '50'),
          _thresholdLine(30, '30'),
        ]),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36,
              getTitlesWidget: (value, meta) {
                if (value == meta.min || value == meta.max) {
                  return const SizedBox();
                }
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: (scores.length / 5).ceilToDouble().clamp(1, double.infinity),
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= dates.length) return const SizedBox();
                return Transform.rotate(
                  angle: -0.4,
                  child: Text(
                    DateFormat('dd/MM').format(dates[i]),
                    style: const TextStyle(fontSize: 9),
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          horizontalInterval: 10,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.withValues(alpha: 0.12),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        minY: 0,
        maxY: 100,
      ),
    );
  }

  HorizontalLine _thresholdLine(double y, String label) {
    return HorizontalLine(
      y: y,
      color: Colors.grey.withValues(alpha: 0.3),
      strokeWidth: 1,
      dashArray: [6, 4],
      label: HorizontalLineLabel(
        show: true,
        labelResolver: (_) => label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 9,
          ),
      ),
    );
  }

  Widget _buildFactorChips(CompanionHealthScore latest) {
    return Row(
      children: [
        _factorChip(
          'Logging',
          latest.loggingFactor,
          AppColors.primary,
        ),
        const SizedBox(width: 8),
        _factorChip(
          'Vitals',
          latest.vitalsFactor,
          AppColors.normal,
        ),
        const SizedBox(width: 8),
        _factorChip(
          'Adherence',
          latest.adherenceFactor,
          AppColors.borderline,
        ),
      ],
    );
  }

  Widget _factorChip(String label, double factor, Color color) {
    final pct = '${(factor * 100).round()}%';
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(label,
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            const SizedBox(height: 2),
            Text(pct,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color)),
          ],
        ),
      ),
    );
  }
}
