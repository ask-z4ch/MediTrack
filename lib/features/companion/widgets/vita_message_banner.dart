import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/app_database.dart';

part 'vita_message_banner.g.dart';

class VitaMessage {
  final String title;
  final String body;
  final Color color;
  const VitaMessage({
    required this.title,
    required this.body,
    required this.color,
  });
}

@riverpod
class VitaMessageProvider extends _$VitaMessageProvider {
  @override
  VitaMessage? build() => null;

  void showContextualMessage(CompanionHealthScore? chs) {
    if (chs == null) {
      state = const VitaMessage(
        title: 'Welcome!',
        body: 'Start logging to see your health score.',
        color: Colors.teal,
      );
      return;
    }
    final s = chs.score;
    if (s >= 90) {
      state = const VitaMessage(
        title: 'Excellent!',
        body: 'You are thriving! Keep up the great habits.',
        color: Colors.green,
      );
    } else if (s >= 70) {
      state = const VitaMessage(
        title: 'Doing Well',
        body: 'Your health is stable. Stay consistent.',
        color: Colors.teal,
      );
    } else if (s >= 50) {
      state = const VitaMessage(
        title: 'Needs Attention',
        body: 'Consider improving your logging and vitals.',
        color: Colors.orange,
      );
    } else if (s >= 30) {
      state = const VitaMessage(
        title: 'Concerning',
        body: 'Your health score is low. Please consult a doctor.',
        color: Colors.deepOrange,
      );
    } else {
      state = const VitaMessage(
        title: 'Critical',
        body: 'Your health score is very low. Seek medical help immediately.',
        color: Colors.red,
      );
    }
  }
}

class VitaMessageBanner extends ConsumerWidget {
  const VitaMessageBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final msg = ref.watch(vitaMessageProvider);
    if (msg == null) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: msg.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: msg.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: msg.color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(msg.title,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: msg.color,
                        fontSize: 13)),
                Text(msg.body,
                    style: TextStyle(
                        color: msg.color.withValues(alpha: 0.8),
                        fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
