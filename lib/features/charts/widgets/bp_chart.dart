import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/health_thresholds.dart';
import '../../../core/database/app_database.dart';
import '../../charts/services/chart_service.dart';

class BpChart extends StatelessWidget {
  final List<VitalsEntry> entries;
  final int titleInterval;
  const BpChart({super.key, required this.entries, this.titleInterval = 1});

  @override
  Widget build(BuildContext context) {
    final systolicSpots = <FlSpot>[];
    final diastolicSpots = <FlSpot>[];

    for (int i = 0; i < entries.length; i++) {
      final e = entries[i];
      if (e.bpSystolic != null) {
        systolicSpots.add(FlSpot(i.toDouble(), e.bpSystolic!.toDouble()));
        diastolicSpots.add(FlSpot(i.toDouble(), e.bpDiastolic!.toDouble()));
      }
    }

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: systolicSpots,
              color: const Color(0xFF1565C0),
              barWidth: 2,
              dotData: const FlDotData(show: false),
            ),
            LineChartBarData(
              spots: diastolicSpots,
              color: const Color(0xFF3F51B5),
              barWidth: 2,
              dotData: const FlDotData(show: false),
            ),
          ],
          extraLinesData: ChartService.bpRangeBands(),
          rangeAnnotations: RangeAnnotations(horizontalRangeAnnotations: [
            HorizontalRangeAnnotation(
              y1: 0,
              y2: BPThreshold.normalSystolicMax.toDouble(),
              color: AppColors.normal.withValues(alpha: 0.08),
            ),
            HorizontalRangeAnnotation(
              y1: BPThreshold.normalSystolicMax.toDouble(),
              y2: BPThreshold.borderlineSystolicMax.toDouble(),
              color: AppColors.borderline.withValues(alpha: 0.08),
            ),
            HorizontalRangeAnnotation(
              y1: BPThreshold.borderlineSystolicMax.toDouble(),
              y2: 180,
              color: AppColors.critical.withValues(alpha: 0.08),
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
              sideTitles: ChartService.dateSideTitles(
                entries.map((e) => e.loggedAt).toList(),
                interval: titleInterval,
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            horizontalInterval: 20,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.withValues(alpha: 0.15),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          minY: 40,
          maxY: 180,
        ),
      ),
    );
  }
}
