import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../features/medicines/providers/medicine_provider.dart';
import '../../features/vitals/providers/vitals_provider.dart';

class PendingActionsCard extends ConsumerWidget {
  const PendingActionsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vitalsAsync = ref.watch(todaysVitalsProvider);
    final dosesAsync = ref.watch(todaysDosesProvider);

    if (vitalsAsync.isLoading || dosesAsync.isLoading) {
      return const _ShimmerCard();
    }

    final actions = <Widget>[];

    if (vitalsAsync.valueOrNull == null) {
      actions.add(_ActionItem(
        icon: Icons.monitor_heart_outlined,
        label: "Log today's vitals",
        onTap: () => context.go('/vitals'),
      ));
    }

    final doses = dosesAsync.valueOrNull ?? [];
    final now = DateTime.now();
    final overdueDoses = doses.where((d) =>
        d.dose.status == 'pending' && d.dose.scheduledAt.isBefore(now));

    for (final dwm in overdueDoses) {
      actions.add(_ActionItem(
        icon: Icons.medication_outlined,
        label: 'Take ${dwm.medicine.name}',
        onTap: () => context.go('/medicines'),
      ));
    }

    if (actions.isEmpty) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        color: AppColors.normal.withValues(alpha: 0.08),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.normal, size: 20),
              SizedBox(width: 10),
              Text(
                'All done for today \u2713',
                style: TextStyle(
                  color: AppColors.normal,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Pending Actions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          ...actions,
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryTeal),
      title: Text(label, style: const TextStyle(fontSize: 14)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
      dense: true,
    );
  }
}

class _ShimmerCard extends StatefulWidget {
  const _ShimmerCard();

  @override
  State<_ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<_ShimmerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final opacity = Tween<double>(begin: 0.3, end: 0.6).evaluate(_controller);
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 140,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: opacity),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: opacity),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 200,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: opacity),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
