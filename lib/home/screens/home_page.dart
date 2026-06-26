import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
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
        SliverAppBar(
          expandedHeight: 0,
          floating: true,
          pinned: false,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          title: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.favorite, size: 16, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Text('MediTrack',
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: AppColors.textPrimary,
                  )),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: AppColors.textSecondary),
              onPressed: () => context.push('/settings'),
            ),
          ],
        ),
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
