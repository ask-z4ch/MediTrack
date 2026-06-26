import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/app_colors.dart';
import '../../features/vitals/providers/vitals_provider.dart';
import '../../shared/widgets/app_card.dart';

part 'streak_counter_widget.g.dart';

class StreakData {
  final int current;
  final int best;
  const StreakData({required this.current, required this.best});
}

@riverpod
Future<StreakData> vitalsStreak(VitalsStreakRef ref) async {
  final dao = ref.read(vitalsDaoProvider);
  int current = 0;
  int best = 0;
  int temp = 0;
  bool currentBroken = false;

  for (int i = 0; i < 365; i++) {
    final date = DateTime.now().subtract(Duration(days: i));
    final entry = await dao.getVitalsForDate(
      DateTime(date.year, date.month, date.day),
    );
    if (entry != null) {
      if (!currentBroken) current++;
      temp++;
      if (temp > best) best = temp;
    } else {
      currentBroken = true;
      temp = 0;
    }
  }

  return StreakData(current: current, best: best);
}

class StreakCounterWidget extends ConsumerWidget {
  const StreakCounterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakAsync = ref.watch(vitalsStreakProvider);

    return streakAsync.when(
      data: (data) {
        final streak = data.current;
        final best = data.best;

        return AppCard(
          accentColor: AppColors.normal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFF2D1F00),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  streak > 0 ? Icons.local_fire_department : Icons.local_fire_department_outlined,
                  color: streak > 0 ? AppColors.borderline : AppColors.textSecondary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$streak',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text(
                        streak == 1 ? 'day streak' : 'day streak',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (best > 0)
                Text(
                  'Best: $best',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
