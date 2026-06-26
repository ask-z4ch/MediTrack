import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../features/doctor_visits/providers/doctor_visit_provider.dart';
import '../../shared/widgets/app_card.dart';

final _upcomingVisitProvider = FutureProvider.autoDispose((ref) async {
  final dao = ref.read(doctorVisitDaoProvider);
  return dao.getNextUpcomingFollowUp();
});

class UpcomingVisitCard extends ConsumerWidget {
  const UpcomingVisitCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitAsync = ref.watch(_upcomingVisitProvider);

    return visitAsync.when(
      data: (visit) {
        if (visit == null || visit.followUpDate == null) {
          return const SizedBox.shrink();
        }

        final daysUntil = visit.followUpDate!
            .difference(DateTime.now().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0))
            .inDays;
        if (daysUntil > 7) return const SizedBox.shrink();

        final dateStr = DateFormat('EEEE, d MMMM').format(visit.followUpDate!);
        final isUrgent = daysUntil <= 3;
        final badgeText = daysUntil == 0 ? 'Today' : 'in $daysUntil days';

        return AppCard(
          accentColor: AppColors.borderline,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Upcoming Follow-Up',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isUrgent
                          ? AppColors.borderline.withValues(alpha: 0.15)
                          : Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badgeText,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isUrgent ? AppColors.borderline : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                visit.doctorName,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                dateStr,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => context.push('/generate-report', extra: visit.visitDate),
                icon: const Icon(Icons.description, size: 16),
                label: const Text('Prepare Report'),
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
