import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/database/app_database.dart';
import '../../../core/services/notification_service.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../models/medicine.dart';
import '../providers/medicine_provider.dart';

class MedicineListScreen extends ConsumerWidget {
  const MedicineListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Medicines'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'Inactive'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _MedicineTab(isActive: true),
            _MedicineTab(isActive: false),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push('/add-medicine'),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _MedicineTab extends ConsumerWidget {
  final bool isActive;

  const _MedicineTab({required this.isActive});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = isActive
        ? ref.watch(activeMedicinesProvider)
        : ref.watch(inactiveMedicinesProvider);

    return stream.when(
      data: (medicines) {
        if (medicines.isEmpty) {
          return EmptyStateWidget(
            emoji: '💊',
            title: 'No medicines added',
            subtitle: isActive
                ? 'Tap + to add your first medicine'
                : 'No inactive medicines — toggle a medicine off to see it here',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: medicines.length,
          itemBuilder: (_, i) => _MedicineTile(medicine: medicines[i]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Something went wrong')),
    );
  }
}

class _MedicineTile extends ConsumerWidget {
  final Medicine medicine;

  const _MedicineTile({required this.medicine});

  String _nextDoseTime(List<String> times) {
    if (times.isEmpty) return 'No times set';
    final now = TimeOfDay.now();
    final nowMinutes = now.hour * 60 + now.minute;

    String? next;
    int minDiff = 24 * 60;

    for (final t in times) {
      final parts = t.split(':');
      final totalMinutes = int.parse(parts[0]) * 60 + int.parse(parts[1]);
      int diff = totalMinutes - nowMinutes;
      if (diff < 0) diff += 24 * 60;
      if (diff < minDiff) {
        minDiff = diff;
        next = t;
      }
    }

    return next ?? times.first;
  }

  String _daysRemaining(DateTime? endDate) {
    if (endDate == null) return '';
    final remaining = endDate.difference(DateTime.now()).inDays;
    if (remaining < 0) return '';
    if (remaining == 0) return 'Last day';
    return '$remaining days left';
  }

  Future<void> _toggle(WidgetRef ref, bool active) async {
    final dao = ref.read(medicineDaoProvider);
    await dao.toggleActive(medicine.id, active);

    final times = (jsonDecode(medicine.scheduledTimes) as List).cast<String>();

    if (!active) {
      for (var i = 0; i < times.length; i++) {
        await NotificationService.cancelReminder(medicine.id * 100 + i);
      }
    } else {
      for (var i = 0; i < times.length; i++) {
        final parts = times[i].split(':');
        await NotificationService.scheduleDailyReminder(
          notificationId: medicine.id * 100 + i,
          medicineName: medicine.name,
          dosage: medicine.dosage,
          time: TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1])),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final times = (jsonDecode(medicine.scheduledTimes) as List).cast<String>();
    final nextDose = _nextDoseTime(times);
    final daysLeft = _daysRemaining(medicine.endDate);

    return AppCard(
      accentColor: medicine.isActive ? AppColors.primary : null,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicine.name,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(medicine.dosage, style: const TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text('Next: $nextDose', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    if (daysLeft.isNotEmpty) ...[
                      const SizedBox(width: 12),
                      Text(daysLeft, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Switch(
            value: medicine.isActive,
            onChanged: (v) => _toggle(ref, v),
          ),
        ],
      ),
    );
  }
}
