import 'package:flutter/material.dart';

import '../../features/vitals/widgets/vitals_summary_card.dart';
import '../widgets/todays_doses_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            VitalsSummaryCard(),
            SizedBox(height: 16),
            TodaysDosesCard(),
          ],
        ),
      ),
    );
  }
}
