import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Badge chip for product cards (Bestseller, New, Popular).
class BadgeChip extends StatelessWidget {
  final String badge;

  const BadgeChip({super.key, required this.badge});

  Color get _color {
    switch (badge) {
      case 'New':
        return AppColors.sage;
      case 'Bestseller':
        return AppColors.terracotta;
      default:
        return AppColors.golden;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: _color,
      label: Text(badge.toUpperCase()),
      // Visual density reduces the default hardcoded Chip heights to match the legacy container look
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
