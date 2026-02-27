import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import 'badge_chip.dart';

/// List-view product card with live qty counter on the add button.
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onQuickAdd;
  final bool isFavourite;
  final VoidCallback onToggleFavourite;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onQuickAdd,
    required this.isFavourite,
    required this.onToggleFavourite,
  });

  @override
  Widget build(BuildContext context) {
    final qty = context.select<CartProvider, int>((cart) => cart.items
        .where((i) => i.product.id == product.id)
        .fold(0, (sum, i) => sum + i.quantity));

    final themeExt = Theme.of(context).extension<AppThemeExtension>()!;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Emoji image + badge
              Stack(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: themeExt.productImageGradient,
                    ),
                    alignment: Alignment.center,
                    child: Text(product.image,
                        style: const TextStyle(fontSize: 40)),
                  ),
                  if (product.badge != null)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: BadgeChip(badge: product.badge!),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + favourite
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(product.name,
                              style: AppTextStyles.headlineSmall
                                  .copyWith(fontSize: 16)),
                        ),
                        GestureDetector(
                          onTap: onToggleFavourite,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              isFavourite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: isFavourite
                                  ? AppColors.terracotta
                                  : AppColors.beige,
                              size: 20,
                              key: ValueKey(isFavourite),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(product.time,
                        style: AppTextStyles.bodySmall.copyWith(fontSize: 12)),
                    const SizedBox(height: 6),

                    // Price + counter button
                    Row(
                      children: [
                        Text('\$${product.price.toStringAsFixed(2)}',
                            style: AppTextStyles.price),
                        const Spacer(),
                        _AddCounter(
                          qty: qty,
                          productId: product.id,
                          onAdd: onQuickAdd,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
/// Compact "+" that expands to "−  N  +" once qty > 0.
class _AddCounter extends StatelessWidget {
  final int qty;
  final int productId;
  final VoidCallback onAdd;

  const _AddCounter({
    required this.qty,
    required this.productId,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final hasItems = qty > 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
      height: 32,
      width: hasItems ? 88 : 32,
      decoration: BoxDecoration(
        color: AppColors.darkBrown,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBrown.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: hasItems
          ? Row(
              children: [
                // − decrement
                Expanded(
                  child: GestureDetector(
                    onTap: () => context
                        .read<CartProvider>()
                        .updateById(productId, qty - 1),
                    child: const Icon(Icons.remove_rounded,
                        color: AppColors.cream, size: 14),
                  ),
                ),
                // Animated count
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: Text(
                    '$qty',
                    key: ValueKey(qty),
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.cream,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
                // + increment
                Expanded(
                  child: GestureDetector(
                    onTap: onAdd,
                    child: const Icon(Icons.add_rounded,
                        color: AppColors.cream, size: 14),
                  ),
                ),
              ],
            )
          : GestureDetector(
              onTap: onAdd,
              child: const Icon(Icons.add_rounded,
                  color: AppColors.cream, size: 18),
            ),
    );
  }
}
