import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/health_thresholds.dart';

class ChartService {
  static ExtraLinesData bpRangeBands() {
    return ExtraLinesData(horizontalLines: [
      HorizontalLine(
        y: BPThreshold.normalSystolicMax.toDouble(),
        color: AppColors.normal.withValues(alpha: 0.25),
        strokeWidth: 1,
        dashArray: [5, 5],
        label: HorizontalLineLabel(
          show: true,
          labelResolver: (_) => 'Normal',
          style: const TextStyle(color: AppColors.normal, fontSize: 10),
        ),
      ),
      HorizontalLine(
        y: BPThreshold.borderlineSystolicMax.toDouble(),
        color: AppColors.borderline.withValues(alpha: 0.25),
        strokeWidth: 1,
        dashArray: [5, 5],
      ),
    ]);
  }

  static SideTitles dateSideTitles(List<DateTime> dates, {int interval = 1}) {
    return SideTitles(
      showTitles: true,
      interval: interval.toDouble(),
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
    );
  }
}
