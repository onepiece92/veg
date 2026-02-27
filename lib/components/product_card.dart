import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_decorations.dart';
import '../models/product.dart';
import 'badge_chip.dart';

/// List-view product card.
class ProductCard extends StatefulWidget {
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
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
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
        padding: const EdgeInsets.all(14),
        decoration: AppDecorations.card,
        child: Row(
          children: [
            // Emoji image
            Stack(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: AppDecorations.productImage,
                  alignment: Alignment.center,
                  child: Text(
                    widget.product.image,
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
                if (widget.product.badge != null)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: BadgeChip(badge: widget.product.badge!),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.name,
                          style: AppTextStyles.headlineSmall.copyWith(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onToggleFavourite,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            widget.isFavourite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: widget.isFavourite
                                ? AppColors.terracotta
                                : AppColors.beige,
                            size: 20,
                            key: ValueKey(widget.isFavourite),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.product.time,
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '\$${widget.product.price.toStringAsFixed(2)}',
                        style: AppTextStyles.price,
                      ),
                      const Spacer(),
                      // Add button
                      GestureDetector(
                        onTap: _handleAdd,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.elasticOut,
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color:
                                _added ? AppColors.sage : AppColors.darkBrown,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.darkBrown.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: _added
                                ? const Icon(Icons.check_rounded,
                                    color: AppColors.white,
                                    size: 16,
                                    key: ValueKey('check'))
                                : const Icon(Icons.add_rounded,
                                    color: AppColors.cream,
                                    size: 18,
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
