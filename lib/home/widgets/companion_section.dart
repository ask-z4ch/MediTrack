import 'package:flutter/material.dart';

import '../../features/companion/widgets/chs_ring_widget.dart';
import '../../features/companion/widgets/vita_companion_view.dart';

class CompanionSection extends StatelessWidget {
  const CompanionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      clipBehavior: Clip.none,
      children: [
        VitaCompanionView(),
        Positioned(
          bottom: -20,
          right: 16,
          child: ChsRingWidget(),
        ),
      ],
    );
  }
}
