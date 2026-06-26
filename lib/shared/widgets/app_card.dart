import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final Color? accentColor;
  final EdgeInsetsGeometry? padding;

  const AppCard({
    super.key,
    required this.child,
    this.accentColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: accentColor != null
            ? Border(
                left: BorderSide(color: accentColor!, width: 3),
              )
            : null,
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}
