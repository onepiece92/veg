import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_text_styles.dart';
import '../../data/bakery_data.dart';
import '../../providers/favourites_provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/product.dart';
import '../../components/grid_product_card.dart';

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
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.95,
                    ),
                    itemCount: favs.length,
                    itemBuilder: (_, i) {
                      final p = favs[i];
                      return GridProductCard(
                        product: p,
                        onTap: () => onProductTap(p),
                        onQuickAdd: () => cart.addProduct(p),
                        isFavourite: favProv.isFavourite(p.id),
                        onToggleFavourite: () => favProv.toggle(p.id),
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
