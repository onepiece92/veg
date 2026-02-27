import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_decorations.dart';
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
      backgroundColor: AppColors.warmWhite,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ── Hero Image ──────────────────────────────────────
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: AppColors.warmWhite,
                leading: GestureDetector(
                  onTap: widget.onBack,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.chevron_left_rounded,
                        color: AppColors.darkBrown, size: 24),
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
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        isFav
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: AppColors.terracotta,
                        size: 20,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.share_outlined,
                        color: AppColors.softBrown, size: 18),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.beige,
                          AppColors.lightGold,
                          AppColors.golden
                        ],
                        stops: [0.0, 0.5, 1.0],
                      ),
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
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text('✦ ${widget.product.badge}',
                                  style: AppTextStyles.label.copyWith(
                                      color: AppColors.darkBrown,
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
                                        ? AppColors.white
                                        : Colors.white.withOpacity(0.45),
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
                  decoration: const BoxDecoration(
                    color: AppColors.warmWhite,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(28)),
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
                                    style: AppTextStyles.displayMedium),
                                const SizedBox(height: 6),
                                Text(widget.product.time,
                                    style: AppTextStyles.bodySmall),
                              ],
                            ),
                          ),
                          Text(
                            '\$${widget.product.price.toStringAsFixed(2)}',
                            style:
                                AppTextStyles.priceLarge.copyWith(fontSize: 28),
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
                            style:
                                AppTextStyles.bodySmall.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Description
                      Text(widget.product.description,
                          style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textLight, height: 1.6)),
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
                                  ? AppColors.sage.withOpacity(0.13)
                                  : AppColors.roseDust.withOpacity(0.13),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              tag,
                              style: AppTextStyles.label.copyWith(
                                color: isGood
                                    ? AppColors.sage
                                    : AppColors.roseDust,
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
                            style: AppTextStyles.headlineSmall),
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
                                          ? AppColors.darkBrown
                                          : AppColors.beige,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      contextOpt.options[i],
                                      style: AppTextStyles.label.copyWith(
                                        color: _contextChoice == i
                                            ? AppColors.cream
                                            : AppColors.softBrown,
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
                            style: AppTextStyles.headlineSmall),
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
                                          ? AppColors.darkBrown
                                          : AppColors.beige,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      _sweetnessLabels[i],
                                      style: AppTextStyles.label.copyWith(
                                        color: _sweetness == i
                                            ? AppColors.cream
                                            : AppColors.softBrown,
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
                          color: AppColors.beige,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Text('Quantity', style: AppTextStyles.bodyLarge),
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
                              style: AppTextStyles.headlineSmall
                                  .copyWith(fontWeight: FontWeight.w700),
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
                          Text('Reviews', style: AppTextStyles.headlineSmall),
                          GestureDetector(
                            onTap: () => setState(
                                () => _showAllReviews = !_showAllReviews),
                            child: Text(
                              _showAllReviews
                                  ? 'Show less'
                                  : 'See all ${widget.product.reviews} →',
                              style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.caramel,
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
                          style: AppTextStyles.headlineSmall),
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
                              child: Container(
                                width: 140,
                                decoration: AppDecorations.card,
                                clipBehavior: Clip.hardEdge,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 90,
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
                                          gradient:
                                              AppColors.productImageGradient),
                                      alignment: Alignment.center,
                                      child: Text(p.image,
                                          style: const TextStyle(fontSize: 40)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            p.name,
                                            style: AppTextStyles.bodyMedium
                                                .copyWith(
                                                    color: AppColors.darkBrown,
                                                    fontSize: 13),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '\$${p.price.toStringAsFixed(2)}',
                                                style: AppTextStyles.label
                                                    .copyWith(
                                                        color:
                                                            AppColors.darkBrown,
                                                        fontSize: 13),
                                              ),
                                              Text(p.time,
                                                  style: AppTextStyles.caption),
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
                    AppColors.warmWhite.withOpacity(0),
                    AppColors.warmWhite,
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
          color: filled ? AppColors.darkBrown : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border:
              filled ? null : Border.all(color: AppColors.golden, width: 1.5),
        ),
        alignment: Alignment.center,
        child: Icon(icon,
            color: filled ? AppColors.cream : AppColors.darkBrown, size: 20),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [AppColors.golden, AppColors.caramel]),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  review.avatar,
                  style: const TextStyle(
                      color: AppColors.white,
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
                        style: AppTextStyles.bodyMedium
                            .copyWith(fontWeight: FontWeight.w500)),
                    Row(
                      children: [
                        StarRating(rating: review.rating.toDouble(), size: 10),
                        const SizedBox(width: 6),
                        Text(review.date, style: AppTextStyles.caption),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(review.text,
              style:
                  AppTextStyles.bodySmall.copyWith(height: 1.5, fontSize: 13)),
        ],
      ),
    );
  }
}
