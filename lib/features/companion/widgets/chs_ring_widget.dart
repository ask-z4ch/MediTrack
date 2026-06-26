import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../providers/chs_provider.dart';

class ChsRingWidget extends ConsumerStatefulWidget {
  const ChsRingWidget({super.key});

  @override
  ConsumerState<ChsRingWidget> createState() => _ChsRingWidgetState();
}

class _ChsRingWidgetState extends ConsumerState<ChsRingWidget>
    with TickerProviderStateMixin {
  late AnimationController _scoreController;
  late Animation<double> _scoreAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  double _lastNormalized = 0;

  @override
  void initState() {
    super.initState();

    _scoreController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scoreAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _scoreController, curve: Curves.easeOut),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _pulseAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scoreController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _updatePulse(double score) {
    if (score < 30) {
      if (!_pulseController.isAnimating) {
        _pulseController.repeat(reverse: true);
      }
    } else {
      _pulseController.stop();
      _pulseController.value = 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final score = ref.watch(cHSNotifierProvider).value?.score ?? 0;
    final normalized = score / 100;

    if (normalized != _lastNormalized) {
      _lastNormalized = normalized;
      final begin = _scoreAnimation.value;
      final end = normalized;
      _scoreAnimation = Tween<double>(begin: begin, end: end).animate(
        CurvedAnimation(parent: _scoreController, curve: Curves.easeOut),
      );
      _scoreController.forward(from: 0);
    }

    _updatePulse(score);

    return SizedBox(
      width: 120,
      height: 120,
      child: AnimatedBuilder(
        animation: _scoreAnimation,
        builder: (context, child) {
          final progress = _scoreAnimation.value;
          final displayScore = (progress * 100).round();
          final arcColor = Color.lerp(
            AppColors.critical,
            AppColors.normal,
            progress,
          )!;

          return Opacity(
            opacity: _pulseAnimation.value,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(120, 120),
                  painter: _RingPainter(
                    progress: progress,
                    arcColor: arcColor,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$displayScore',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      '/ 100',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const Text(
                      'Companion Health',
                      style: TextStyle(fontSize: 9, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color arcColor;

  _RingPainter({required this.progress, required this.arcColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 8) / 2;
    const strokeWidth = 6.0;

    final bgPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

    final scorePaint = Paint()
      ..color = arcColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      scorePaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.arcColor != arcColor;
}
