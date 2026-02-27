import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_decorations.dart';
import '../../data/bakery_data.dart';
import '../../models/order.dart';

class RecentOrdersScreen extends StatefulWidget {
  final VoidCallback onBack;
  final ValueChanged<Order>? onReorder;

  const RecentOrdersScreen({super.key, required this.onBack, this.onReorder});

  @override
  State<RecentOrdersScreen> createState() => _RecentOrdersScreenState();
}

class _RecentOrdersScreenState extends State<RecentOrdersScreen>
    with TickerProviderStateMixin {
  late AnimationController _pageCtrl;
  late Animation<double> _pageFade;
  late Animation<Offset> _pageSlide;

  final List<AnimationController> _cardCtrls = [];

  @override
  void initState() {
    super.initState();

    _pageCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _pageFade = CurvedAnimation(parent: _pageCtrl, curve: Curves.easeOut);
    _pageSlide = Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero)
        .animate(CurvedAnimation(parent: _pageCtrl, curve: Curves.easeOut));

    final orders = BakeryData.recentOrders;
    for (var i = 0; i < orders.length; i++) {
      final ctrl = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 400));
      _cardCtrls.add(ctrl);
    }

    // Stagger card animations exactly like JSX (0.15 + i * 0.1s delay)
    Future.microtask(() async {
      _pageCtrl.forward();
      for (var i = 0; i < _cardCtrls.length; i++) {
        await Future.delayed(Duration(milliseconds: 150 + i * 100));
        if (mounted) _cardCtrls[i].forward();
      }
    });
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    for (final c in _cardCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orders = BakeryData.recentOrders;
    final totalSpent = orders.fold<double>(0, (sum, o) => sum + o.total);

    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.onBack,
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

            // ── Scrollable body ──────────────────────────────────
            Expanded(
              child: FadeTransition(
                opacity: _pageFade,
                child: SlideTransition(
                  position: _pageSlide,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                    children: [
                      // ── This Month summary card ──────────────────
                      Container(
                        padding: const EdgeInsets.all(24),
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppColors.darkBrown, AppColors.softBrown],
                          ),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('THIS MONTH',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.golden,
                                  letterSpacing: 1.5,
                                  fontSize: 11,
                                )),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${orders.length}',
                                      style:
                                          AppTextStyles.displayLarge.copyWith(
                                        color: AppColors.cream,
                                        fontSize: 32,
                                      ),
                                    ),
                                    Text(
                                      'orders placed',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color:
                                            Colors.white.withValues(alpha: 0.5),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '\$${totalSpent.toStringAsFixed(2)}',
                                      style:
                                          AppTextStyles.displayLarge.copyWith(
                                        color: AppColors.cream,
                                        fontSize: 24,
                                      ),
                                    ),
                                    Text(
                                      'total spent',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color:
                                            Colors.white.withValues(alpha: 0.5),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // ── Order cards ──────────────────────────────
                      ...orders.asMap().entries.map((entry) {
                        final i = entry.key;
                        final order = entry.value;
                        final ctrl = _cardCtrls[i];
                        return FadeTransition(
                          opacity: CurvedAnimation(
                              parent: ctrl, curve: Curves.easeOut),
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.08),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                                parent: ctrl, curve: Curves.easeOut)),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _OrderCard(
                                order: order,
                                onReorder: widget.onReorder != null
                                    ? () => widget.onReorder!(order)
                                    : null,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Individual order card matching JSX exactly ────────────────────────────────

class _OrderCard extends StatelessWidget {
  final dynamic order;
  final VoidCallback? onReorder;

  const _OrderCard({required this.order, this.onReorder});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.beige, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order header — id, date, status badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order ${order.id}',
                    style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.darkBrown,
                        fontWeight: FontWeight.w400,
                        fontSize: 15),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    order.date,
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.sage.withValues(alpha: 0.095),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '✓ ${order.status}',
                  style: AppTextStyles.label.copyWith(
                      color: AppColors.sage,
                      fontSize: 11,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Item list
          ...order.items.map<Widget>((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.name,
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.darkBrown, fontSize: 14),
                  ),
                  Text(
                    '× ${item.qty}',
                    style: AppTextStyles.bodySmall
                        .copyWith(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 14),

          // Footer — total + reorder button
          Container(
            padding: const EdgeInsets.only(top: 12),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.beige)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${order.total.toStringAsFixed(2)}',
                  style: AppTextStyles.displayMedium.copyWith(fontSize: 17),
                ),
                GestureDetector(
                  onTap: onReorder,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: AppColors.darkBrown, width: 1.5),
                    ),
                    child: Text(
                      'Reorder',
                      style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.darkBrown,
                          fontWeight: FontWeight.w500,
                          fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
