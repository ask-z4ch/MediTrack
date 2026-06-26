import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../vitals/models/vitals_entry.dart';
import '../../vitals/providers/vitals_provider.dart';
import '../models/companion_health_score.dart';

part 'vita_message_provider.g.dart';

@riverpod
class VitaMessageNotifier extends _$VitaMessageNotifier {
  @override
  String build() => "How are you feeling today?";

  void showContextualMessage(CompanionHealthScore? chs, VitalsEntry? todayVitals) {
    state = _generate(chs, todayVitals);
  }

  String _generate(CompanionHealthScore? chs, VitalsEntry? todayVitals) {
    if (chs == null) return "Log your first vitals to get started.";
    if (todayVitals == null) return "Haven't heard from you today — log your vitals when you can.";
    if (chs.adherenceFactor < 0.6) return "Some medicines were missed recently. Consistency matters.";
    if (chs.vitalsFactor < 0.5) return "Your recent readings need attention. Worth discussing with your doctor.";
    if (chs.score >= 90) return "Everything looks great. Keep it up!";
    if (chs.score >= 70) return "Doing well. A few more consistent days and we'll be thriving.";
    return "Let's work on getting back on track together.";
  }
}
