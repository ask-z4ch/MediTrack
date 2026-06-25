import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/health_thresholds.dart';
import '../../../core/database/app_database.dart';
import '../services/chart_service.dart';

class BloodSugarChart extends StatelessWidget {
  final List<VitalsEntry> entries;
  const BloodSugarChart({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    final grouped = <DateTime, List<VitalsEntry>>{};
    for (final e in entries) {
      final day = DateTime(e.loggedAt.year, e.loggedAt.month, e.loggedAt.day);
      grouped.putIfAbsent(day, () => []).add(e);
    }
    final dates = grouped.keys.toList()..sort();

    final barGroups = <BarChartGroupData>[];
    for (int i = 0; i < dates.length; i++) {
      final dayEntries = grouped[dates[i]]!;
      double? fasting, postMeal;
      for (final e in dayEntries) {
        fasting ??= e.bloodSugarFasting;
        postMeal ??= e.bloodSugarPostMeal;
      }
      final rods = <BarChartRodData>[];
      if (fasting != null) {
        rods.add(BarChartRodData(
          toY: fasting,
          color: const Color(0xFF009688),
          width: 10,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ));
      }
      if (postMeal != null) {
        rods.add(BarChartRodData(
          toY: postMeal,
          color: const Color(0xFFFFC107),
          width: 10,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ));
      }
      if (rods.isNotEmpty) {
        barGroups.add(BarChartGroupData(x: i, barRods: rods));
      }
    }

    return SizedBox(
      height: 220,
      child: BarChart(
        BarChartData(
          barGroups: barGroups,
          groupsSpace: 12,
          alignment: BarChartAlignment.center,
          maxY: 250,
          extraLinesData: ExtraLinesData(horizontalLines: [
            HorizontalLine(
              y: BloodSugarThreshold.fastingNormalMax,
              color: const Color(0xFF009688).withValues(alpha: 0.25),
              strokeWidth: 1,
              dashArray: [5, 5],
              label: HorizontalLineLabel(
                show: true,
                labelResolver: (_) => 'Fasting',
                style: const TextStyle(
                  color: Color(0xFF009688),
                  fontSize: 9,
                ),
              ),
            ),
            HorizontalLine(
              y: BloodSugarThreshold.postMealNormalMax,
              color: const Color(0xFFFFC107).withValues(alpha: 0.25),
              strokeWidth: 1,
              dashArray: [5, 5],
              label: HorizontalLineLabel(
                show: true,
                labelResolver: (_) => 'Post-meal',
                style: const TextStyle(
                  color: Color(0xFFFFC107),
                  fontSize: 9,
                ),
              ),
            ),
          ]),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                getTitlesWidget: (value, meta) {
                  if (value == meta.min) return const SizedBox();
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: ChartService.dateSideTitles(dates),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(
            show: true,
            horizontalInterval: 50,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.withValues(alpha: 0.15),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
