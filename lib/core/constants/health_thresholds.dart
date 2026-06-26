class BPThreshold {
  static const int normalSystolicMax = 120;
  static const int normalDiastolicMax = 80;
  static const int borderlineSystolicMax = 139;
  static const int borderlineDiastolicMax = 89;
}

class BloodSugarThreshold {
  static const double fastingNormalMax = 100.0;
  static const double fastingBorderlineMax = 125.0;
  static const double postMealNormalMax = 140.0;
  static const double postMealBorderlineMax = 199.0;
  static const double hypoMin = 70.0;

  static const double _mmolFactor = 18.0;

  static double _inUnit(double mgdl, String unit) =>
      unit == 'mmol' ? mgdl / _mmolFactor : mgdl;

  static double fastingNormalMaxFor(String unit) => _inUnit(fastingNormalMax, unit);
  static double fastingBorderlineMaxFor(String unit) => _inUnit(fastingBorderlineMax, unit);
  static double fastingCriticalFor(String unit) => _inUnit(126.0, unit);
  static double postMealNormalMaxFor(String unit) => _inUnit(postMealNormalMax, unit);
  static double postMealBorderlineMaxFor(String unit) => _inUnit(postMealBorderlineMax, unit);
  static double postMealCriticalFor(String unit) => _inUnit(200.0, unit);
  static double hypoMinFor(String unit) => _inUnit(hypoMin, unit);
  static double chartMaxYFor(String unit) => _inUnit(250.0, unit);
}

String formatSugar(double mgdl, String unit) {
  if (unit == 'mmol') {
    return '${(mgdl / 18.0).toStringAsFixed(1)} mmol/L';
  }
  return '${mgdl.toStringAsFixed(0)} mg/dL';
}

class SpO2Threshold {
  static const int normalMin = 95;
  static const int borderlineMin = 92;
}

class TemperatureThreshold {
  static const double normalMinC = 36.5;
  static const double normalMaxC = 37.5;
  static const double borderlineMaxC = 38.3;
  static const double criticalLowC = 35.5;
}

enum VitalStatus { normal, borderline, critical }
