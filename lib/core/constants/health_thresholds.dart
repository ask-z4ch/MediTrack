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
