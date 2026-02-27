import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_decorations.dart';
import '../../data/bakery_data.dart';
import '../../components/order_card.dart';

class RecentOrdersScreen extends StatelessWidget {
  final VoidCallback onBack;

  const RecentOrdersScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final orders = BakeryData.recentOrders;
    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: onBack,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: AppDecorations.beigeRounded,
                      alignment: Alignment.center,
                      child: const Icon(Icons.chevron_left_rounded,
                          color: AppColors.darkBrown, size: 24),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('Recent Orders', style: AppTextStyles.headlineLarge),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                itemCount: orders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (_, i) => Column(
                  children: [
                    OrderCard(
                        order: orders[i], featured: i == 0, onReorder: () {}),
                    if (i == 0) ...[
                      const SizedBox(height: 10),
                      _ReorderButton(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReorderButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.darkBrown, width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.replay_rounded,
              color: AppColors.darkBrown, size: 16),
          const SizedBox(width: 6),
          Text('Reorder',
              style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.darkBrown, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
