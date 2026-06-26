import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/health_thresholds.dart';
import '../../features/companion/widgets/chs_ring_widget.dart';
import '../../features/companion/widgets/vita_companion_view.dart';
import '../../features/companion/widgets/vita_message_banner.dart';
import '../../features/vitals/providers/vitals_provider.dart';
import '../widgets/todays_doses_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const VitaCompanionView(),
              const Positioned(
                bottom: -20,
                right: 16,
                child: ChsRingWidget(),
              ),
            ],
          ),
        ),
        const SliverToBoxAdapter(child: VitaMessageBanner()),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _MiniVitalsRow(),
          ),
        ),
        const SliverToBoxAdapter(child: TodaysDosesCard()),
        SliverToBoxAdapter(child: _stubCard('Pending Actions')),
        SliverToBoxAdapter(child: _stubCard('Upcoming Visit')),
        SliverToBoxAdapter(child: _stubCard('Streak Counter')),
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }

  static Card _stubCard(String label) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text(label, style: const TextStyle(color: Colors.grey)),
        ),
      ),
    );
  }
}

class _MiniVitalsRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entry = ref.watch(todaysVitalsProvider).valueOrNull;

    if (entry == null) {
      return const SizedBox.shrink();
    }

    final chips = <Widget>[];

    if (entry.bpSystolic != null && entry.bpDiastolic != null) {
      final status = _bpStatus(entry.bpSystolic!, entry.bpDiastolic!);
      chips.add(_chip(
        label: 'BP',
        value: '${entry.bpSystolic}/${entry.bpDiastolic}',
        statusColor: status,
      ));
    }
    if (entry.bloodSugarFasting != null) {
      final status = _sugarFastingStatus(entry.bloodSugarFasting!);
      chips.add(_chip(
        label: 'Sugar',
        value: '${entry.bloodSugarFasting!.toStringAsFixed(0)}',
        statusColor: status,
      ));
    }
    if (entry.spo2Percent != null) {
      final status = _spo2Status(entry.spo2Percent!);
      chips.add(_chip(
        label: 'SpO2',
        value: '${entry.spo2Percent}%',
        statusColor: status,
      ));
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 10,
        children: chips,
      ),
    );
  }

  Widget _chip({required String label, required String value, required Color statusColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: statusColor),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: statusColor, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(fontSize: 12, color: statusColor, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Color _bpStatus(int systolic, int diastolic) {
    if (systolic >= 140 || diastolic >= 90) return const Color(0xFFEA4335);
    if (systolic > 120 || diastolic > 80) return const Color(0xFFFBBC04);
    return const Color(0xFF34A853);
  }

  Color _sugarFastingStatus(double value) {
    if (value >= 126 || value < 70) return const Color(0xFFEA4335);
    if (value > 100) return const Color(0xFFFBBC04);
    return const Color(0xFF34A853);
  }

  Color _spo2Status(int value) {
    if (value < 90) return const Color(0xFFEA4335);
    if (value < 95) return const Color(0xFFFBBC04);
    return const Color(0xFF34A853);
  }
}
