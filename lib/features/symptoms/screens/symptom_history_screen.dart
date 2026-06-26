import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/widgets/empty_state_widget.dart';
import '../models/symptom_entry.dart';
import '../providers/symptom_provider.dart';

Map<DateTime, List<SymptomEntry>> _groupByDate(List<SymptomEntry> entries) {
  final map = <DateTime, List<SymptomEntry>>{};
  for (final e in entries) {
    final day = DateTime(e.loggedAt.year, e.loggedAt.month, e.loggedAt.day);
    map.putIfAbsent(day, () => []).add(e);
  }
  return map;
}

Color _severityColor(int severity) {
  return switch (severity) {
    1 => Colors.green,
    2 => Colors.lime,
    3 => Colors.orange,
    4 => Colors.deepOrange,
    5 => Colors.red,
    _ => Colors.grey,
  };
}

double _severitySize(int severity) {
  return 12 + severity * 2.0;
}

class SymptomHistoryScreen extends ConsumerWidget {
  const SymptomHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(symptomListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Symptom History')),
      body: async.when(
        data: (entries) {
          if (entries.isEmpty) {
            return const EmptyStateWidget(
              emoji: '📝',
              title: 'No symptoms logged',
              subtitle: 'Your symptom entries will appear here',
            );
          }
          final grouped = _groupByDate(entries);
          final dates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

          return ListView.builder(
            itemCount: dates.length + entries.length,
            itemBuilder: (context, index) {
              int running = 0;
              for (final date in dates) {
                if (index == running) {
                  return _DateSeparator(date: date);
                }
                running++;
                final dayEntries = grouped[date]!;
                if (index < running + dayEntries.length) {
                  final entry = dayEntries[index - running];
                  return _SymptomCard(entry: entry);
                }
                running += dayEntries.length;
              }
              return null;
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Could not load symptoms')),
      ),
    );
  }
}

class _DateSeparator extends StatelessWidget {
  final DateTime date;
  const _DateSeparator({required this.date});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateDay = DateTime(date.year, date.month, date.day);

    String label;
    if (dateDay == today) {
      label = 'Today';
    } else if (dateDay == yesterday) {
      label = 'Yesterday';
    } else {
      label = '${date.day}/${date.month}/${date.year}';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}

class _SymptomCard extends StatelessWidget {
  final SymptomEntry entry;
  const _SymptomCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final severityColor = _severityColor(entry.severity);
    final severitySize = _severitySize(entry.severity);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: severitySize,
              height: severitySize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: severityColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.symptomName,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  if (entry.notes.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(entry.notes, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  ],
                ],
              ),
            ),
            Text(
              '${entry.loggedAt.hour.toString().padLeft(2, '0')}:${entry.loggedAt.minute.toString().padLeft(2, '0')}',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
