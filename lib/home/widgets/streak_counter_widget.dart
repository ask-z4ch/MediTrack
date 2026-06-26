import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/app_colors.dart';
import '../../features/vitals/providers/vitals_provider.dart';

part 'streak_counter_widget.g.dart';

@riverpod
Future<int> vitalsStreak(VitalsStreakRef ref) async {
  final dao = ref.read(vitalsDaoProvider);
  int streak = 0;
  var day = DateTime.now();
  for (int i = 0; i < 365; i++) {
    final entry = await dao.getVitalsForDate(
      DateTime(day.year, day.month, day.day),
    );
    if (entry == null) break;
    streak++;
    day = day.subtract(const Duration(days: 1));
  }
  return streak;
}

class StreakCounterWidget extends ConsumerWidget {
  const StreakCounterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakAsync = ref.watch(vitalsStreakProvider);

    return streakAsync.when(
      data: (streak) {
        if (streak == 0) {
          return _buildRow(
            icon: Icons.local_fire_department_outlined,
            text: 'Start your streak today',
            color: Colors.grey,
          );
        }

        String suffix;
        if (streak >= 30) {
          suffix = ' — incredible month-long streak!';
        } else if (streak >= 14) {
          suffix = ' — two-week streak!';
        } else if (streak >= 7) {
          suffix = ' — one week streak!';
        } else if (streak >= 3) {
          suffix = ' — keep going!';
        } else {
          suffix = '';
        }

        return _buildRow(
          icon: Icons.local_fire_department,
          text: '$streak-day streak$suffix',
          color: streak >= 7 ? AppColors.borderline : AppColors.primary,
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildRow({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 13,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
