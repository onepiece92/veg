import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/cart_provider.dart';
import '../../providers/address_provider.dart';
import '../../data/bakery_data.dart';
import '../../components/address_selector.dart';
import '../../components/primary_button.dart';

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

    final cartIds = cart.items.map((i) => i.product.id).toSet();
    final suggestions = BakeryData.products
        .where((p) => !cartIds.contains(p.id))
        .take(4)
        .toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: const Icon(Icons.chevron_left_rounded, size: 24),
            onPressed: () => context.pop(),
          ),
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
                                height: 140,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: suggestions.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 10),
                                  itemBuilder: (_, i) {
                                    final p = suggestions[i];
                                    return GestureDetector(
                                      onTap: () {
                                        context
                                            .read<CartProvider>()
                                            .addProduct(p);
                                      },
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 56,
                                                decoration: BoxDecoration(
                                                    gradient: Theme.of(context)
                                                        .extension<
                                                            AppThemeExtension>()
                                                        ?.productImageGradient,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                alignment: Alignment.center,
                                                child: Text(p.image,
                                                    style: const TextStyle(
                                                        fontSize: 28)),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(p.name,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          fontSize: 12),
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              const SizedBox(height: 4),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      '\$${p.price.toStringAsFixed(2)}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelSmall
                                                          ?.copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary,
                                                              fontSize: 13)),
                                                  const SizedBox(width: 6),
                                                  Container(
                                                    width: 22,
                                                    height: 22,
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Icon(
                                                        Icons.add_rounded,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onPrimary,
                                                        size: 14),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
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
                    children: [
                      Expanded(
                        child: Text(item.name,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w400)),
                      ),
                      GestureDetector(
                        onTap: onRemove,
                        child: Icon(Icons.delete_outline_rounded,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                            size: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('\$${total.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _SmallQtyBtn(
                          icon: Icons.remove_rounded, onTap: onDecrement),
                      const SizedBox(width: 12),
                      Text('$quantity',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                      const SizedBox(width: 12),
                      _SmallQtyBtn(
                          icon: Icons.add_rounded,
                          onTap: onIncrement,
                          filled: true),
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

class _SmallQtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  const _SmallQtyBtn(
      {required this.icon, required this.onTap, this.filled = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: filled
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          border:
              filled ? null : Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Icon(icon,
            color: filled
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.primary,
            size: 14),
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
          const Text('🧺', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text('Your cart is empty',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 6),
          Text("Looks like you haven't added anything yet",
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center),
          const SizedBox(height: 24),
          PrimaryButton(label: 'Browse Menu', onTap: onBack),
        ],
      ),
    );
  }
}
