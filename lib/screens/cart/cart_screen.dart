import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../../theme/app_theme.dart';
import '../../providers/cart_provider.dart';
import '../../providers/address_provider.dart';
import '../../data/bakery_data.dart';
import '../../components/address_selector.dart';
import '../../components/primary_button.dart';
import '../../components/product_card.dart';
import '../../components/grid_product_card.dart';
import '../../components/bakery_back_button.dart';
import '../../providers/favourites_provider.dart';

import 'package:go_router/go_router.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  void _showAddressSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => AddressBottomSheet(
        selectedId: context.read<AddressProvider>().selectedId,
        onSelect: (id) => context.read<AddressProvider>().select(id),
        onAddNew: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final addrProv = context.watch<AddressProvider>();
    final favProv = context.watch<FavouritesProvider>();

    final cartIds = cart.items.map((i) => i.product.id).toSet();
    final suggestions = BakeryData.products
        .where((p) => !cartIds.contains(p.id))
        .take(4)
        .toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: BakeryBackButton(),
        ),
        title: const Text('Your Cart'),
        actions: [
          if (cart.items.isNotEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 24),
                child: Text(
                  '${cart.totalCount} item${cart.totalCount != 1 ? 's' : ''}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: cart.items.isEmpty
                      ? _EmptyCart(onBack: () => context.pop())
                      : ListView(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 150),
                          children: [
                            // Cart items
                            ...cart.items.asMap().entries.map((entry) {
                              final i = entry.key;
                              final item = entry.value;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _CartItemRow(
                                  item: item.product,
                                  quantity: item.quantity,
                                  total: item.product.price * item.quantity,
                                  onDecrement: () => context
                                      .read<CartProvider>()
                                      .updateQuantity(i, item.quantity - 1),
                                  onIncrement: () => context
                                      .read<CartProvider>()
                                      .updateQuantity(i, item.quantity + 1),
                                  onRemove: () => context
                                      .read<CartProvider>()
                                      .updateQuantity(i, 0),
                                ),
                              );
                            }),

                            // Suggestions
                            if (suggestions.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text('Add something extra?',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 260,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: suggestions.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 10),
                                  itemBuilder: (_, i) {
                                    final p = suggestions[i];
                                    return SizedBox(
                                      width: 160,
                                      child: GridProductCard(
                                        product: p,
                                        onTap: () => context
                                            .push('/home/product', extra: p),
                                        onQuickAdd: () => context
                                            .read<CartProvider>()
                                            .addProduct(p),
                                        isFavourite: favProv.isFavourite(p.id),
                                        onToggleFavourite: () => context
                                            .read<FavouritesProvider>()
                                            .toggle(p.id),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Address
                            Text('DELIVER TO',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                        fontSize: 11, letterSpacing: 0.5)),
                            const SizedBox(height: 8),
                            AddressSelector(
                              selectedId: addrProv.selectedId,
                              onTap: () => _showAddressSheet(context),
                              variant: AddressSelectorVariant.compact,
                            ),
                            const SizedBox(height: 16),

                            // Price summary
                            Card(
                              color: Theme.of(context).dividerColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    _PriceRow('Subtotal',
                                        '\$${cart.subtotal.toStringAsFixed(2)}'),
                                    const SizedBox(height: 10),
                                    _PriceRow('Baking fee', '\$2.50'),
                                    const Divider(
                                        height: 24, color: Color(0x4DD4A574)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Total',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall),
                                        Text(
                                            '\$${cart.total.toStringAsFixed(2)}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  fontSize: 20,
                                                )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),

            // Checkout button
            if (cart.items.isNotEmpty)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: PrimaryButton(
                  label: 'Checkout — \$${cart.total.toStringAsFixed(2)}',
                  onTap: () {
                    if (cart.items.isNotEmpty) {
                      context.push('/cart/checkout');
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CartItemRow extends StatelessWidget {
  final dynamic item;
  final int quantity;
  final double total;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onRemove;

  const _CartItemRow({
    required this.item,
    required this.quantity,
    required this.total,
    required this.onDecrement,
    required this.onIncrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                gradient: Theme.of(context)
                    .extension<AppThemeExtension>()
                    ?.productImageGradient,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Text(item.image, style: const TextStyle(fontSize: 34)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(item.name,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500)),
                      ),
                      GestureDetector(
                        onTap: onRemove,
                        child: Icon(Icons.close_rounded,
                            color: Theme.of(context).dividerColor, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          '\$${total.toStringAsFixed(2)}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 15,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Spacer(),
                      AddCounter(
                        qty: quantity,
                        productId: item.id,
                        onAdd: onIncrement,
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

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;

  const _PriceRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color)),
        Text(value,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.primary)),
      ],
    );
  }
}

class _EmptyCart extends StatelessWidget {
  final VoidCallback onBack;

  const _EmptyCart({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Lottie.asset('assets/animations/empty_cart.json',
                width: 250, repeat: false, fit: BoxFit.contain),
          ),
          const SizedBox(height: 16),
          Text('Your cart is empty',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 6),
          Text("Looks like you haven't added anything yet",
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center),
          PrimaryButton(
            label: 'Browse Menu',
            onTap: () => context.go('/home'),
          ),
        ],
      ),
    );
  }
}
