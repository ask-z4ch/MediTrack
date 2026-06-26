import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../providers/chs_provider.dart';
import '../providers/vita_message_provider.dart';

class VitaMessageBanner extends ConsumerWidget {
  const VitaMessageBanner({super.key});

  Color _messageColor(double score) {
    if (score >= 90) return AppColors.normal;
    if (score >= 70) return AppColors.primaryTeal;
    if (score >= 50) return AppColors.borderline;
    if (score >= 30) return Colors.deepOrange;
    return AppColors.critical;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = ref.watch(vitaMessageNotifierProvider);
    final chs = ref.watch(chsNotifierProvider).value;
    final score = chs?.score ?? 75.0;
    final color = _messageColor(score);

    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: color.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(Icons.auto_awesome, size: 18, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: Text(
                  message,
                  key: ValueKey(message),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: color.withValues(alpha: 0.85),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
