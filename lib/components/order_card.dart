import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../models/order.dart';

/// Compact order history card widget.
class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback? onReorder;
  final bool featured;

  const OrderCard({
    super.key,
    required this.order,
    this.onReorder,
    this.featured = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: featured
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.darkBrown, AppColors.softBrown],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFFAF3), Color(0x66F5E6D3)],
              ),
        borderRadius: BorderRadius.circular(18),
        border: featured ? null : Border.all(color: AppColors.beige),
        boxShadow: featured
            ? [
                BoxShadow(
                  color: AppColors.darkBrown.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                )
              ]
            : [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 14,
                  offset: const Offset(0, 3),
                )
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                order.id,
                style: AppTextStyles.label.copyWith(
                  color: featured ? AppColors.golden : AppColors.softBrown,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '· ${order.date.split(',').first}',
                style: AppTextStyles.caption.copyWith(
                  color: featured
                      ? Colors.white.withOpacity(0.5)
                      : AppColors.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...order.items.map((item) => Text(
                '${item.name} × ${item.qty}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: featured
                      ? Colors.white.withOpacity(0.8)
                      : AppColors.textLight,
                  fontSize: 13,
                ),
              )),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                '\$${order.total.toStringAsFixed(2)}',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: featured ? AppColors.cream : AppColors.darkBrown,
                  fontSize: 15,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: featured
                      ? Colors.white.withOpacity(0.12)
                      : AppColors.sage.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  order.status,
                  style: AppTextStyles.caption.copyWith(
                    color: featured ? AppColors.golden : AppColors.sage,
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
