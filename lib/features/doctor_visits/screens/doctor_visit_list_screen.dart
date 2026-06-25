import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/database/app_database.dart';
import '../providers/doctor_visit_provider.dart';

class DoctorVisitListScreen extends ConsumerWidget {
  const DoctorVisitListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitsAsync = ref.watch(allVisitsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Visits')),
      body: visitsAsync.when(
        data: (visits) {
          if (visits.isEmpty) {
            return const Center(child: Text('No doctor visits logged yet'));
          }
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);

          final upcoming = <DoctorVisit>[];
          final past = <DoctorVisit>[];
          for (final v in visits) {
            if (v.followUpDate != null) {
              final fu = DateTime(v.followUpDate!.year, v.followUpDate!.month, v.followUpDate!.day);
              if (!fu.isBefore(today)) {
                upcoming.add(v);
                continue;
              }
            }
            past.add(v);
          }
          upcoming.sort((a, b) => a.followUpDate!.compareTo(b.followUpDate!));
          past.sort((a, b) => b.visitDate.compareTo(a.visitDate));

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              if (upcoming.isNotEmpty) ...[
                Text('Upcoming Follow-ups',
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                ...upcoming.map((v) => _VisitCard(
                      visit: v,
                      highlight: _isWithin7Days(v.followUpDate!),
                    )),
                const SizedBox(height: 24),
              ],
              if (past.isNotEmpty) ...[
                Text('Past Visits',
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                ...past.map((v) => _VisitCard(visit: v)),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  bool _isWithin7Days(DateTime date) {
    final now = DateTime.now();
    final target = DateTime(date.year, date.month, date.day);
    final diff = target.difference(DateTime(now.year, now.month, now.day)).inDays;
    return diff >= 0 && diff <= 7;
  }
}

class _VisitCard extends StatelessWidget {
  final DoctorVisit visit;
  final bool highlight;
  const _VisitCard({required this.visit, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    final paths = List<String>.from(jsonDecode(visit.prescriptionPaths));
    final dateFormat = DateFormat('d MMMM yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: highlight
            ? const BorderSide(color: Color(0xFFFFA726), width: 2)
            : BorderSide.none,
      ),
      child: GestureDetector(
        onTap: paths.isNotEmpty
            ? () => context.push('/prescription-viewer', extra: paths)
            : null,
        child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        visit.doctorName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      if (visit.specialty.isNotEmpty)
                        Text(
                          visit.specialty,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),
                ),
                if (paths.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${paths.length} ${paths.length == 1 ? 'prescription' : 'prescriptions'}',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              dateFormat.format(visit.visitDate),
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
            if (visit.followUpDate != null) ...[
              const SizedBox(height: 4),
              Chip(
                label: Text(
                  'Follow-up: ${dateFormat.format(visit.followUpDate!)}',
                  style: const TextStyle(fontSize: 12),
                ),
                backgroundColor:
                    highlight ? const Color(0xFFFFF3E0) : null,
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ],
        ),
      ),
      ),
    );
  }
}
