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
    final today = _dayStart(now);

    if (await _vitalsDao.getVitalsForDate(today) != null) return 1.0;

    final yesterday = today.subtract(const Duration(days: 1));
    if (await _vitalsDao.getVitalsForDate(yesterday) != null) return 0.7;

    final twoDaysAgo = today.subtract(const Duration(days: 2));
    if (await _vitalsDao.getVitalsForDate(twoDaysAgo) != null) return 0.4;

    return 0.0;
  }

  DateTime _dayStart(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day);

  Future<double> _vitalsFactor() async {
    final from = DateTime.now().subtract(const Duration(days: 7));
    final entries = await _vitalsDao.getVitalsInRange(from, DateTime.now());

    if (entries.isEmpty) return 0.5;

    final scores = <double>[];

    for (final e in entries) {
      if (e.bpSystolic != null && e.bpDiastolic != null) {
        scores.add(_bpScore(e.bpSystolic!, e.bpDiastolic!));
      }
      if (e.bloodSugarFasting != null) {
        scores.add(_sugarScore(e.bloodSugarFasting!, fasting: true));
      }
      if (e.bloodSugarPostMeal != null) {
        scores.add(_sugarScore(e.bloodSugarPostMeal!, fasting: false));
      }
      if (e.spo2Percent != null) scores.add(_spo2Score(e.spo2Percent!));
      if (e.temperatureCelsius != null) {
        scores.add(_tempScore(e.temperatureCelsius!));
      }
    }

    if (scores.isEmpty) return 0.5;
    return scores.reduce((a, b) => a + b) / scores.length;
  }

  double _bpScore(int sys, int dia) {
    if (sys < 120 && dia < 80) return 1.0;
    if (sys < 140 && dia < 90) return 0.5;
    return 0.0;
  }

  double _sugarScore(double val, {required bool fasting}) {
    if (val < BloodSugarThreshold.hypoMin) return 0.0;
    final normalMax = fasting
        ? BloodSugarThreshold.fastingNormalMax
        : BloodSugarThreshold.postMealNormalMax;
    final borderMax = fasting
        ? BloodSugarThreshold.fastingBorderlineMax
        : BloodSugarThreshold.postMealBorderlineMax;
    if (val <= normalMax) return 1.0;
    if (val <= borderMax) return 0.5;
    return 0.0;
  }

  double _spo2Score(int val) {
    if (val >= SpO2Threshold.normalMin) return 1.0;
    if (val >= SpO2Threshold.borderlineMin) return 0.5;
    return 0.0;
  }

  double _tempScore(double val) {
    if (val >= TemperatureThreshold.normalMinC &&
        val <= TemperatureThreshold.normalMaxC) return 1.0;
    if (val > TemperatureThreshold.criticalLowC &&
        val <= TemperatureThreshold.borderlineMaxC) return 0.5;
    return 0.0;
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
