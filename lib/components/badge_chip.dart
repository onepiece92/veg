import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        badge.toUpperCase(),
        style: AppTextStyles.caption.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
