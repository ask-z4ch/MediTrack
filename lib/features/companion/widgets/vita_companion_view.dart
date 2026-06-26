import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../providers/chs_provider.dart';
import 'vita_message_banner.dart';

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

  Future<void> _onTap() async {
    await _scaleController.reverse();
    await _scaleController.forward();

    final chs = ref.read(chsNotifierProvider).value;
    ref.read(vitaMessageProvider.notifier).showContextualMessage(chs);
  }

  @override
  Widget build(BuildContext context) {
    final chs = ref.watch(chsNotifierProvider).value;
    final score = chs?.score ?? 75.0;

    return Column(
      children: [
        const VitaMessageBanner(),
        GestureDetector(
          onTap: _onTap,
          child: ScaleTransition(
            scale: _scaleController,
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
      ],
    );
  }
}
