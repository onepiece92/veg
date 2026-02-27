import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../models/product.dart';
import '../../data/bakery_data.dart';
import '../../providers/favourites_provider.dart';
import '../../components/star_rating.dart';
import '../../components/primary_button.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final VoidCallback onBack;
  final void Function(Product, int) onAddToCart;
  final ValueChanged<Product> onProductTap;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.onBack,
    required this.onAddToCart,
    required this.onProductTap,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  int _sweetness = 2;
  int _contextChoice = 0;
  int _activeImage = 0;
  bool _showAllReviews = false;

  static const _sweetnessLabels = ['None', 'Light', 'Regular', 'Extra'];
  static const _categoryOptions = {
    'breads': (
      label: 'Slice Preference',
      options: ['Unsliced', 'Thick Cut', 'Thin Cut', 'Half Loaf']
    ),
    'pastries': (
      label: 'Warm it Up?',
      options: ['Room Temp', 'Lightly Warmed', 'Toasty']
    ),
    'cakes': (
      label: 'Cake Size',
      options: ['6 inch', '8 inch', '10 inch', '12 inch']
    ),
    'cookies': (
      label: 'Pack Size',
      options: ['Single', 'Half Dozen', 'Dozen', "Baker's Dozen"]
    ),
  };

  static const _reviews = [
    (
      name: 'Sarah M.',
      rating: 5,
      date: '2 days ago',
      text:
          'Absolutely incredible! The crust is perfectly crispy and the inside is so soft. Will definitely order again.',
      avatar: 'S'
    ),
    (
      name: 'James K.',
      rating: 5,
      date: '1 week ago',
      text:
          'Best in the city, hands down. You can taste the quality in every bite.',
      avatar: 'J'
    ),
    (
      name: 'Amara T.',
      rating: 4,
      date: '2 weeks ago',
      text:
          'Really lovely. Slight wait for pickup but worth it for the freshness.',
      avatar: 'A'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final favProv = context.watch<FavouritesProvider>();
    final isFav = favProv.isFavourite(widget.product.id);
    final contextOpt = _categoryOptions[widget.product.category];
    final related = BakeryData.products
        .where((p) => p.id != widget.product.id)
        .take(4)
        .toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ── Hero Image ──────────────────────────────────────
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                leading: GestureDetector(
                  onTap: widget.onBack,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .scaffoldBackgroundColor
                          .withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Icon(Icons.chevron_left_rounded,
                        color: Theme.of(context).colorScheme.primary, size: 24),
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () => favProv.toggle(widget.product.id),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        isFav
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: Theme.of(context).colorScheme.tertiary,
                        size: 20,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .scaffoldBackgroundColor
                          .withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Icon(Icons.share_outlined,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        size: 18),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: Theme.of(context)
                          .extension<AppThemeExtension>()
                          ?.heroGradient,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(widget.product.image,
                            style: const TextStyle(fontSize: 110)),
                        if (widget.product.badge != null)
                          Positioned(
                            bottom: 50,
                            left: 20,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surface
                                    .withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text('✦ ${widget.product.badge}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.w600)),
                            ),
                          ),
                        // Gallery dots
                        Positioned(
                          bottom: 18,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(3, (i) {
                              return GestureDetector(
                                onTap: () => setState(() => _activeImage = i),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                  width: _activeImage == i ? 20 : 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    color: _activeImage == i
                                        ? Theme.of(context).colorScheme.surface
                                        : Theme.of(context)
                                            .colorScheme
                                            .surface
                                            .withValues(alpha: 0.45),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Content ─────────────────────────────────────────
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name + Price
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.product.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium),
                                const SizedBox(height: 6),
                                Text(widget.product.time,
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),
                          Text(
                            '\$${widget.product.price.toStringAsFixed(2)}',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(fontSize: 28),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Rating
                      Row(
                        children: [
                          StarRating(rating: widget.product.rating),
                          const SizedBox(width: 6),
                          Text(
                            '${widget.product.rating} (${widget.product.reviews} reviews)',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Description
                      Text(widget.product.description,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color,
                                  height: 1.6)),
                      const SizedBox(height: 18),

                      // Tags
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: widget.product.tags.map((tag) {
                          final isGood = tag.contains('Gluten') ||
                              tag.contains('Vegan') ||
                              tag.contains('Organic');
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: isGood
                                  ? Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer
                                  : Theme.of(context)
                                      .colorScheme
                                      .errorContainer,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              tag,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: isGood
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer
                                        : Theme.of(context)
                                            .colorScheme
                                            .onErrorContainer,
                                    fontSize: 12,
                                  ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // Context-aware option
                      if (contextOpt != null) ...[
                        Text(contextOpt.label,
                            style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 10),
                        Row(
                          children:
                              List.generate(contextOpt.options.length, (i) {
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    right: i < contextOpt.options.length - 1
                                        ? 8
                                        : 0),
                                child: GestureDetector(
                                  onTap: () =>
                                      setState(() => _contextChoice = i),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: BoxDecoration(
                                      color: _contextChoice == i
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context).dividerColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      contextOpt.options[i],
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                            color: _contextChoice == i
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                            fontSize: 11,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 22),
                      ],

                      // Sweetness (pastries/cakes/cookies)
                      if (widget.product.category != 'breads') ...[
                        Text('Sweetness Level',
                            style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 10),
                        Row(
                          children: List.generate(_sweetnessLabels.length, (i) {
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    right: i < _sweetnessLabels.length - 1
                                        ? 8
                                        : 0),
                                child: GestureDetector(
                                  onTap: () => setState(() => _sweetness = i),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: BoxDecoration(
                                      color: _sweetness == i
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context).dividerColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      _sweetnessLabels[i],
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                            color: _sweetness == i
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                            fontSize: 12,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 22),
                      ],

                      // Quantity
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .dividerColor
                              .withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Text('Quantity',
                                style: Theme.of(context).textTheme.bodyLarge),
                            const Spacer(),
                            _QtyButton(
                              icon: Icons.remove_rounded,
                              onTap: () => setState(() {
                                if (_quantity > 1) _quantity--;
                              }),
                            ),
                            const SizedBox(width: 18),
                            Text(
                              '$_quantity',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(width: 18),
                            _QtyButton(
                              icon: Icons.add_rounded,
                              onTap: () => setState(() => _quantity++),
                              filled: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Reviews section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Reviews',
                              style: Theme.of(context).textTheme.headlineSmall),
                          GestureDetector(
                            onTap: () => setState(
                                () => _showAllReviews = !_showAllReviews),
                            child: Text(
                              _showAllReviews
                                  ? 'Show less'
                                  : 'See all ${widget.product.reviews} →',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      RatingBar(
                          rating: widget.product.rating,
                          reviews: widget.product.reviews),
                      const SizedBox(height: 12),
                      ...(_showAllReviews ? _reviews : _reviews.take(2))
                          .map((r) => _ReviewCard(review: r)),
                      const SizedBox(height: 28),

                      // You May Also Like
                      Text('You May Also Like',
                          style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 190,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: related.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemBuilder: (_, i) {
                            final p = related[i];
                            return GestureDetector(
                              onTap: () => widget.onProductTap(p),
                              child: SizedBox(
                                width: 140,
                                child: Card(
                                  clipBehavior: Clip.hardEdge,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 90,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            gradient: Theme.of(context)
                                                .extension<AppThemeExtension>()
                                                ?.productImageGradient),
                                        alignment: Alignment.center,
                                        child: Text(p.image,
                                            style:
                                                const TextStyle(fontSize: 40)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              p.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      fontSize: 13),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '\$${p.price.toStringAsFixed(2)}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium
                                                      ?.copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          fontSize: 13),
                                                ),
                                                Text(p.time,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                            fontSize: 10)),
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
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Bottom CTA ───────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context)
                        .scaffoldBackgroundColor
                        .withValues(alpha: 0),
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
                ),
              ),
              child: PrimaryButton(
                label:
                    'Add to Cart — \$${(widget.product.price * _quantity).toStringAsFixed(2)}',
                onTap: () => widget.onAddToCart(widget.product, _quantity),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  const _QtyButton(
      {required this.icon, required this.onTap, this.filled = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: filled
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: filled
              ? null
              : Border.all(
                  color: Theme.of(context).colorScheme.tertiary, width: 1.5),
        ),
        alignment: Alignment.center,
        child: Icon(icon,
            color: filled
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.primary,
            size: 20),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final ({
    String name,
    int rating,
    String date,
    String text,
    String avatar
  }) review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: Theme.of(context)
                        .extension<AppThemeExtension>()
                        ?.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    review.avatar,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review.name,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w500)),
                      Row(
                        children: [
                          StarRating(
                              rating: review.rating.toDouble(), size: 10),
                          const SizedBox(width: 6),
                          Text(review.date,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(review.text,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(height: 1.5, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
