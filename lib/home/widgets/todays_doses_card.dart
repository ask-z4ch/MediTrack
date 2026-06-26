import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../features/companion/providers/chs_provider.dart';
import '../../features/medicines/providers/medicine_provider.dart';

class TodaysDosesCard extends ConsumerWidget {
  const TodaysDosesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dosesAsync = ref.watch(todaysDosesProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Today's Doses", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const Divider(),
            dosesAsync.when(
              data: (doses) {
                if (doses.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text('No doses scheduled for today'),
                  );
                }
                return Column(
                  children: doses.map((d) => _DoseTile(doseWithMedicine: d)).toList(),
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, __) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('Could not load doses'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoseTile extends ConsumerWidget {
  final DoseWithMedicine doseWithMedicine;

  const _DoseTile({required this.doseWithMedicine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dose = doseWithMedicine.dose;
    final medicine = doseWithMedicine.medicine;
    final time = TimeOfDay.fromDateTime(dose.scheduledAt);
    final isPending = dose.status == 'pending';
    final isTaken = dose.status == 'taken';
    final isSkipped = dose.status == 'skipped';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(medicine.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(
                  '${medicine.dosage} at ${time.format(context)}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),
          if (isPending) ...[
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.normal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                textStyle: const TextStyle(fontSize: 13),
              ),
              onPressed: () async {
                await ref.read(medicineDoseDaoProvider).markTaken(dose.id);
                ref.invalidate(todaysDosesProvider);
                ref.read(cHSNotifierProvider.notifier).recalculate();
              },
              child: const Text('Taken'),
            ),
            const SizedBox(width: 8),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                textStyle: const TextStyle(fontSize: 13),
              ),
              onPressed: () async {
                await ref.read(medicineDoseDaoProvider).markSkipped(dose.id);
                ref.invalidate(todaysDosesProvider);
                ref.read(cHSNotifierProvider.notifier).recalculate();
              },
              child: const Text('Skip'),
            ),
          ] else ...[
            Chip(
              label: Text(
                isTaken ? 'Taken' : 'Skipped',
                style: const TextStyle(fontSize: 12),
              ),
              backgroundColor: isTaken ? Colors.green[50] : Colors.grey[100],
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ],
      ),
    );
  }
}
