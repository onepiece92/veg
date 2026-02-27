import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_decorations.dart';
import '../models/product.dart';
import 'badge_chip.dart';

/// Grid-view product card.
class GridProductCard extends StatefulWidget {
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
  State<GridProductCard> createState() => _GridProductCardState();
}

class _GridProductCardState extends State<GridProductCard> {
  bool _added = false;

  void _handleAdd() {
    if (_added) return;
    setState(() => _added = true);
    widget.onQuickAdd();
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _added = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: AppDecorations.card,
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
                  decoration: const BoxDecoration(
                    gradient: AppColors.productImageGradient,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    widget.product.image,
                    style: const TextStyle(fontSize: 50),
                  ),
                ),
                if (widget.product.badge != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: BadgeChip(badge: widget.product.badge!),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: widget.onToggleFavourite,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        widget.isFavourite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: widget.isFavourite
                            ? AppColors.terracotta
                            : AppColors.softBrown,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Info
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.darkBrown,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.product.time,
                    style: AppTextStyles.labelSmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '\$${widget.product.price.toStringAsFixed(2)}',
                        style: AppTextStyles.price.copyWith(fontSize: 16),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: _handleAdd,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color:
                                _added ? AppColors.sage : AppColors.darkBrown,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: _added
                                ? const Icon(Icons.check_rounded,
                                    color: AppColors.white,
                                    size: 14,
                                    key: ValueKey('check'))
                                : const Icon(Icons.add_rounded,
                                    color: AppColors.cream,
                                    size: 16,
                                    key: ValueKey('add')),
                          ),
                        ),
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
