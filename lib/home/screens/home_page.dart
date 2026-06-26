import 'package:flutter/material.dart';

import '../widgets/companion_section.dart';
import '../widgets/pending_actions_card.dart';
import '../widgets/streak_counter_widget.dart';
import '../widgets/todays_doses_card.dart';
import '../widgets/upcoming_visit_card.dart';
import '../../features/companion/widgets/vita_message_banner.dart';
import '../widgets/vitals_summary_row.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: CompanionSection()),
        const SliverToBoxAdapter(child: VitaMessageBanner()),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: VitalsSummaryRow(),
          ),
        ),
        const SliverToBoxAdapter(child: TodaysDosesCard()),
        const SliverToBoxAdapter(child: PendingActionsCard()),
        const SliverToBoxAdapter(child: UpcomingVisitCard()),
        const SliverToBoxAdapter(child: StreakCounterWidget()),
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }
}
