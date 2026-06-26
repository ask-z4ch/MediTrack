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
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _lastNormalized = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final score = ref.watch(chsNotifierProvider).value?.score ?? 0;
    final normalized = score / 100;

    if (normalized != _lastNormalized) {
      _lastNormalized = normalized;
      final begin = _animation.value;
      final end = normalized;
      _animation = Tween<double>(begin: begin, end: end).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
      _controller.forward(from: 0);
    }

    return SizedBox(
      width: 110,
      height: 110,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final progress = _animation.value;
          final displayScore = (progress * 100).round();
          final arcColor = Color.lerp(
            AppColors.critical,
            AppColors.normal,
            progress,
          )!;

          return Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(110, 110),
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
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const Text(
                    'Companion Health',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ],
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
