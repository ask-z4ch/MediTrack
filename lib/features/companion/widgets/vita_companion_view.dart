import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../vitals/providers/vitals_provider.dart';
import '../providers/chs_provider.dart';
import '../providers/vita_message_provider.dart';

class VitaCompanionView extends ConsumerStatefulWidget {
  const VitaCompanionView({super.key});

  @override
  ConsumerState<VitaCompanionView> createState() =>
      _VitaCompanionViewState();
}

class _VitaCompanionViewState extends ConsumerState<VitaCompanionView>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.92,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  String _lottieAsset(double score) {
    if (score >= 90) return 'assets/lottie/vita_thriving.json';
    if (score >= 70) return 'assets/lottie/vita_stable.json';
    if (score >= 50) return 'assets/lottie/vita_concerned.json';
    if (score >= 30) return 'assets/lottie/vita_struggling.json';
    return 'assets/lottie/vita_critical.json';
  }

  List<Color> _backgroundGradient(double score) {
    if (score >= 90) return [const Color(0xFF1B5E20), const Color(0xFF121212)];
    if (score >= 70) return [const Color(0xFF0D47A1), const Color(0xFF121212)];
    if (score >= 50) return [const Color(0xFFE65100), const Color(0xFF121212)];
    if (score >= 30) return [const Color(0xFF4A148C), const Color(0xFF121212)];
    return [const Color(0xFFB71C1C), const Color(0xFF121212)];
  }

  Future<void> _onTap() async {
    await _scaleController.reverse();
    await _scaleController.forward();

    final chs = ref.read(cHSNotifierProvider).value;
    final todayVitals = ref.read(todaysVitalsProvider).valueOrNull;
    ref.read(vitaMessageNotifierProvider.notifier).showContextualMessage(chs, todayVitals);
  }

  @override
  Widget build(BuildContext context) {
    final chs = ref.watch(cHSNotifierProvider).value;
    final score = chs?.score ?? 75.0;
    final gradientColors = _backgroundGradient(score);

    return GestureDetector(
      onTap: _onTap,
      child: ScaleTransition(
        scale: _scaleController,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          height: 260,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors,
            ),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            child: Lottie.asset(
              _lottieAsset(score),
              key: ValueKey(_lottieAsset(score)),
              width: double.infinity,
              height: 260,
              fit: BoxFit.contain,
              repeat: true,
            ),
          ),
        ),
      ),
    );
  }
}
