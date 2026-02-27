import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_decorations.dart';
import '../../data/bakery_data.dart';
import '../../providers/favourites_provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/product.dart';
import '../../components/badge_chip.dart';

class FavouritesScreen extends StatelessWidget {
  final ValueChanged<Product> onProductTap;

  const FavouritesScreen({super.key, required this.onProductTap});

  @override
  Widget build(BuildContext context) {
    final favProv = context.watch<FavouritesProvider>();
    final cart = context.read<CartProvider>();
    final favs =
        BakeryData.products.where((p) => favProv.isFavourite(p.id)).toList();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('My Favourites', style: AppTextStyles.displayMedium),
                const SizedBox(height: 4),
                Text('${favs.length} saved item${favs.length != 1 ? 's' : ''}',
                    style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Expanded(
            child: favs.isEmpty
                ? _EmptyFavourites()
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 80),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.78,
                    ),
                    itemCount: favs.length,
                    itemBuilder: (_, i) {
                      final p = favs[i];
                      return GestureDetector(
                        onTap: () => onProductTap(p),
                        child: Container(
                          decoration: AppDecorations.card,
                          clipBehavior: Clip.hardEdge,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 120,
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                        gradient:
                                            AppColors.productImageGradient),
                                    alignment: Alignment.center,
                                    child: Text(p.image,
                                        style: const TextStyle(fontSize: 52)),
                                  ),
                                  if (p.badge != null)
                                    Positioned(
                                      top: 8,
                                      left: 8,
                                      child: BadgeChip(badge: p.badge!),
                                    ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () => favProv.toggle(p.id),
                                      child: Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.88),
                                          borderRadius:
                                              BorderRadius.circular(9),
                                        ),
                                        alignment: Alignment.center,
                                        child: const Icon(
                                            Icons.favorite_rounded,
                                            color: AppColors.terracotta,
                                            size: 15),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(p.name,
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                                color: AppColors.darkBrown,
                                                fontSize: 13),
                                        overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text('\$${p.price.toStringAsFixed(2)}',
                                            style: AppTextStyles.label.copyWith(
                                                color: AppColors.darkBrown,
                                                fontSize: 14)),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () => cart.addProduct(p),
                                          child: Container(
                                            width: 26,
                                            height: 26,
                                            decoration: BoxDecoration(
                                              color: AppColors.darkBrown,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            alignment: Alignment.center,
                                            child: const Icon(Icons.add_rounded,
                                                color: AppColors.cream,
                                                size: 15),
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
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _EmptyFavourites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('❤️', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            Text('No favourites yet', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 8),
            Text("Tap the ♡ on any item to save it here",
                style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
