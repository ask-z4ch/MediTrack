import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../core/constants/app_colors.dart';
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

  Color _stateColor(double score) {
    if (score >= 90) return AppColors.thriving;
    if (score >= 70) return AppColors.stable;
    if (score >= 50) return AppColors.concerned;
    if (score >= 30) return AppColors.struggling;
    return AppColors.criticalBg;
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
    final stateColor = _stateColor(score);

    return GestureDetector(
      onTap: _onTap,
      child: ScaleTransition(
        scale: _scaleController,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          height: 260,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [stateColor.withValues(alpha: 0.6), AppColors.background],
            ),
            boxShadow: [
              BoxShadow(
                color: stateColor.withValues(alpha: 0.3),
                blurRadius: 40,
                spreadRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              child: Lottie.asset(
                _lottieAsset(score),
                key: ValueKey(_lottieAsset(score)),
                fit: BoxFit.contain,
                repeat: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
