import 'package:drift/drift.dart';

import '../../../core/constants/health_thresholds.dart';
import '../../../core/database/app_database.dart';
import '../../medicines/daos/medicine_dose_dao.dart';
import '../../vitals/daos/vitals_dao.dart';

class CHSCalculatorService {
  final VitalsDao _vitalsDao;
  final MedicineDoseDao _doseDao;

  CHSCalculatorService(this._vitalsDao, this._doseDao);

  Future<CompanionHealthScoresCompanion> calculate() async {
    final lf = await _loggingFactor();
    final vf = await _vitalsFactor();
    final af = await _adherenceFactor();
    final score = ((lf * 35) + (vf * 40) + (af * 25)).clamp(0.0, 100.0);

    return CompanionHealthScoresCompanion(
      calculatedAt: Value(DateTime.now()),
      score: Value(score),
      loggingFactor: Value(lf),
      vitalsFactor: Value(vf),
      adherenceFactor: Value(af),
    );
  }

  Future<double> _loggingFactor() async {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    final entries = await _vitalsDao.getVitalsInRange(sevenDaysAgo, now);
    if (entries.isEmpty) return 0.0;

    final loggedDays = <int>{};
    for (final e in entries) {
      loggedDays.add(DateTime(e.loggedAt.year, e.loggedAt.month, e.loggedAt.day)
          .millisecondsSinceEpoch);
    }
    return (loggedDays.length / 7).clamp(0.0, 1.0);
  }

  Future<double> _vitalsFactor() async {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    final entries = await _vitalsDao.getVitalsInRange(sevenDaysAgo, now);
    if (entries.isEmpty) return 0.0;

    final latest = entries.last;
    final scores = <double>[];

    if (latest.bpSystolic != null && latest.bpDiastolic != null) {
      if (latest.bpSystolic! <= BPThreshold.normalSystolicMax &&
          latest.bpDiastolic! <= BPThreshold.normalDiastolicMax) {
        scores.add(1.0);
      } else if (latest.bpSystolic! <= BPThreshold.borderlineSystolicMax &&
          latest.bpDiastolic! <= BPThreshold.borderlineDiastolicMax) {
        scores.add(0.5);
      } else {
        scores.add(0.0);
      }
    }

    if (latest.bloodSugarFasting != null) {
      if (latest.bloodSugarFasting! <= BloodSugarThreshold.fastingNormalMax) {
        scores.add(1.0);
      } else if (latest.bloodSugarFasting! <=
          BloodSugarThreshold.fastingBorderlineMax) {
        scores.add(0.5);
      } else {
        scores.add(0.0);
      }
    } else if (latest.bloodSugarPostMeal != null) {
      if (latest.bloodSugarPostMeal! <=
          BloodSugarThreshold.postMealNormalMax) {
        scores.add(1.0);
      } else if (latest.bloodSugarPostMeal! <=
          BloodSugarThreshold.postMealBorderlineMax) {
        scores.add(0.5);
      } else {
        scores.add(0.0);
      }
    }

    if (latest.spo2Percent != null) {
      if (latest.spo2Percent! >= SpO2Threshold.normalMin) {
        scores.add(1.0);
      } else if (latest.spo2Percent! >= SpO2Threshold.borderlineMin) {
        scores.add(0.5);
      } else {
        scores.add(0.0);
      }
    }

    if (latest.temperatureCelsius != null) {
      final t = latest.temperatureCelsius!;
      if (t >= TemperatureThreshold.normalMinC &&
          t <= TemperatureThreshold.normalMaxC) {
        scores.add(1.0);
      } else if (t >= TemperatureThreshold.criticalLowC &&
          t <= TemperatureThreshold.borderlineMaxC) {
        scores.add(0.5);
      } else {
        scores.add(0.0);
      }
    }

    if (scores.isEmpty) return 0.0;
    return scores.reduce((a, b) => a + b) / scores.length;
  }

  Future<double> _adherenceFactor() async {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    final doses = await _doseDao.getDosesInRange(sevenDaysAgo, now);
    if (doses.isEmpty) return 1.0;

    int taken = 0;
    for (final d in doses) {
      if (d.status == 'taken') taken++;
    }
    return (taken / doses.length).clamp(0.0, 1.0);
  }
}
