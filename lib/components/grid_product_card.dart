import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import 'badge_chip.dart';

/// Grid-view product card with live qty counter on the add button.
class GridProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onQuickAdd;
  final bool isFavourite;
  final VoidCallback onToggleFavourite;

  const GridProductCard({
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area
            Stack(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration:
                      BoxDecoration(gradient: themeExt.productImageGradient),
                  alignment: Alignment.center,
                  child:
                      Text(product.image, style: const TextStyle(fontSize: 52)),
                ),
                if (product.badge != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: BadgeChip(badge: product.badge!),
                  ),
                // Favourite button
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onToggleFavourite,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        isFavourite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: isFavourite
                            ? AppColors.terracotta
                            : AppColors.softBrown,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Info + counter
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.darkBrown, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(product.time, style: AppTextStyles.labelSmall),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: AppTextStyles.price.copyWith(fontSize: 16),
                      ),
                      const Spacer(),
                      _GridAddCounter(
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
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
/// Compact "+" that expands to "−  N  +" once qty > 0 (grid variant).
class _GridAddCounter extends StatelessWidget {
  final int qty;
  final int productId;
  final VoidCallback onAdd;

  const _GridAddCounter({
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
      height: 28,
      width: hasItems ? 80 : 28,
      decoration: BoxDecoration(
        color: AppColors.darkBrown,
        borderRadius: BorderRadius.circular(10),
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
                        color: AppColors.cream, size: 12),
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
                      fontSize: 12,
                    ),
                  ),
                ),
                // + increment
                Expanded(
                  child: GestureDetector(
                    onTap: onAdd,
                    child: const Icon(Icons.add_rounded,
                        color: AppColors.cream, size: 12),
                  ),
                ),
              ],
            )
          : GestureDetector(
              onTap: onAdd,
              child: const Icon(Icons.add_rounded,
                  color: AppColors.cream, size: 16),
            ),
    );
  }
}
