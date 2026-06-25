import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/database/app_database.dart';
import '../../charts/services/chart_service.dart';

class BpChart extends StatelessWidget {
  final List<VitalsEntry> entries;
  const BpChart({super.key, required this.entries});

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
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            horizontalInterval: 20,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.withOpacity(0.15),
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
