import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../models/product.dart';
import '../../data/bakery_data.dart';
import '../../providers/cart_provider.dart';
import '../../providers/favourites_provider.dart';
import '../../providers/address_provider.dart';
import '../../components/category_pill.dart';
import '../../components/product_card.dart';
import '../../components/grid_product_card.dart';
import '../../components/address_selector.dart';
import '../../components/order_card.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<Product> onProductTap;
  final VoidCallback onOrdersTab;

  const HomeScreen({
    super.key,
    required this.onProductTap,
    required this.onOrdersTab,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String _selectedCategory = 'all';
  String _searchQuery = '';
  String _sortBy = 'default';
  bool _gridView = false;
  bool _showFilter = false;
  final Set<String> _activeFilters = {};
  String? _toast;
  final _searchCtrl = TextEditingController();
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _quickAdd(Product product) {
    context.read<CartProvider>().addProduct(product);
    setState(() => _toast = product.name);
    Future.delayed(const Duration(milliseconds: 1800),
        () => mounted ? setState(() => _toast = null) : null);
  }

  void _showAddressSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => AddressBottomSheet(
        selectedId: context.read<AddressProvider>().selectedId,
        onSelect: (id) => context.read<AddressProvider>().select(id),
        onAddNew: () {
          Navigator.pop(context);
          // navigate to add address handled by parent router
        },
      ),
    );
  }

  List<Product> get _filtered {
    List<Product> list = _selectedCategory == 'all'
        ? List.of(BakeryData.products)
        : BakeryData.products
            .where((p) => p.category == _selectedCategory)
            .toList();

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((p) {
        return p.name.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q) ||
            p.tags.any((t) => t.toLowerCase().contains(q));
      }).toList();
    }

    if (_activeFilters.isNotEmpty) {
      list = list
          .where((p) => _activeFilters.every((f) => p.tags.contains(f)))
          .toList();
    }

    switch (_sortBy) {
      case 'price_low':
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating':
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'popular':
        list.sort((a, b) => b.reviews.compareTo(a.reviews));
        break;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final favProv = context.watch<FavouritesProvider>();
    final addrProv = context.watch<AddressProvider>();
    final filtered = _filtered;
    final bool showRecent = _searchQuery.isEmpty &&
        _selectedCategory == 'all' &&
        _activeFilters.isEmpty;

    return FadeTransition(
      opacity: _fadeAnim,
      child: Column(
        children: [
          // ── Header ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
            child: Row(
              children: [
                Expanded(
                  child: AddressSelector(
                    selectedId: addrProv.selectedId,
                    onTap: _showAddressSheet,
                    variant: AddressSelectorVariant.header,
                  ),
                ),
                const SizedBox(width: 12),
                // Notification bell
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.beige,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.notifications_outlined,
                      color: AppColors.softBrown, size: 22),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ── Search + Filter ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: _SearchBar(
                    controller: _searchCtrl,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    onClear: () {
                      _searchCtrl.clear();
                      setState(() => _searchQuery = '');
                    },
                  ),
                ),
                const SizedBox(width: 10),
                _FilterButton(
                  active: _showFilter || _activeFilters.isNotEmpty,
                  badge: _activeFilters.length,
                  onTap: () => setState(() => _showFilter = !_showFilter),
                ),
              ],
            ),
          ),

          // ── Dietary Filter Panel ─────────────────────────────────
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: _showFilter
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('DIETARY FILTERS',
                            style: AppTextStyles.labelSmall),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: BakeryData.dietaryFilterOptions.map((f) {
                            final active = _activeFilters.contains(f);
                            final label = f.replaceAll(' Option', '');
                            return GestureDetector(
                              onTap: () => setState(() {
                                if (active) {
                                  _activeFilters.remove(f);
                                } else {
                                  _activeFilters.add(f);
                                }
                              }),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: active
                                      ? AppColors.darkBrown
                                      : AppColors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: active
                                        ? AppColors.darkBrown
                                        : AppColors.beige,
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  '${active ? '✓ ' : ''}$label',
                                  style: AppTextStyles.label.copyWith(
                                    color: active
                                        ? AppColors.cream
                                        : AppColors.softBrown,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        if (_activeFilters.isNotEmpty)
                          TextButton(
                            onPressed: () =>
                                setState(() => _activeFilters.clear()),
                            child: Text('Clear all filters',
                                style: AppTextStyles.label.copyWith(
                                    color: AppColors.terracotta, fontSize: 12)),
                          ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 12),

          // ── Category Pills ───────────────────────────────────────
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                CategoryPill(
                  label: 'All',
                  icon: '✦',
                  active: _selectedCategory == 'all',
                  onTap: () => setState(() => _selectedCategory = 'all'),
                ),
                const SizedBox(width: 10),
                ...BakeryData.categories.map((c) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: CategoryPill(
                      label: c.label,
                      icon: c.icon,
                      active: _selectedCategory == c.id,
                      onTap: () => setState(() => _selectedCategory = c.id),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Scrollable content ───────────────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
              children: [
                // Recent orders preview
                if (showRecent) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recent Orders', style: AppTextStyles.headlineSmall),
                      GestureDetector(
                        onTap: widget.onOrdersTab,
                        child: Text('View all →',
                            style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.caramel,
                                fontWeight: FontWeight.w500,
                                fontSize: 13)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 140,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: BakeryData.recentOrders.length.clamp(0, 3),
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, i) => SizedBox(
                        width: 200,
                        child: OrderCard(
                          order: BakeryData.recentOrders[i],
                          featured: i == 0,
                          onReorder: () => widget.onOrdersTab(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Search result info
                if (_searchQuery.isNotEmpty || _activeFilters.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      '${filtered.length} result${filtered.length != 1 ? 's' : ''}',
                      style: AppTextStyles.bodySmall,
                    ),
                  ),

                // Section title + Sort + View toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Fresh Today', style: AppTextStyles.headlineMedium),
                    Row(
                      children: [
                        _SortButton(
                          sortBy: _sortBy,
                          onChanged: (v) => setState(() => _sortBy = v),
                        ),
                        const SizedBox(width: 6),
                        _ViewToggle(
                          isGrid: _gridView,
                          onToggle: (v) => setState(() => _gridView = v),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Empty state
                if (filtered.isEmpty)
                  _EmptyState(
                    onClear: () => setState(() {
                      _searchQuery = '';
                      _searchCtrl.clear();
                      _activeFilters.clear();
                      _sortBy = 'default';
                      _selectedCategory = 'all';
                    }),
                  )
                else if (_gridView)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final p = filtered[i];
                      return GridProductCard(
                        product: p,
                        onTap: () => widget.onProductTap(p),
                        onQuickAdd: () => _quickAdd(p),
                        isFavourite: favProv.isFavourite(p.id),
                        onToggleFavourite: () => favProv.toggle(p.id),
                      );
                    },
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (_, i) {
                      final p = filtered[i];
                      return ProductCard(
                        product: p,
                        onTap: () => widget.onProductTap(p),
                        onQuickAdd: () => _quickAdd(p),
                        isFavourite: favProv.isFavourite(p.id),
                        onToggleFavourite: () => favProv.toggle(p.id),
                      );
                    },
                  ),
              ],
            ),
          ),

          // ── Toast ────────────────────────────────────────────────
          if (_toast != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.darkBrown,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: AppColors.sage,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.check_rounded,
                          color: AppColors.white, size: 14),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '$_toast added to cart',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.cream),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Private helper widgets ────────────────────────────────────────────────────

class _SearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _focused ? AppColors.white : AppColors.beige,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _focused ? AppColors.golden : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: _focused
            ? [BoxShadow(color: AppColors.shadow, blurRadius: 20)]
            : [],
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded,
              color: AppColors.softBrown, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Focus(
              onFocusChange: (f) => setState(() => _focused = f),
              child: TextField(
                controller: widget.controller,
                onChanged: widget.onChanged,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.text),
                decoration: InputDecoration(
                  hintText: 'Search breads, pastries...',
                  hintStyle: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textLight),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          if (widget.controller.text.isNotEmpty)
            GestureDetector(
              onTap: widget.onClear,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.softBrown.withOpacity(0.13),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.close_rounded,
                    color: AppColors.softBrown, size: 12),
              ),
            ),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final bool active;
  final int badge;
  final VoidCallback onTap;

  const _FilterButton({
    required this.active,
    required this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: active ? AppColors.darkBrown : AppColors.beige,
          borderRadius: BorderRadius.circular(16),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: AppColors.darkBrown.withOpacity(0.2),
                    blurRadius: 15,
                  )
                ]
              : [],
        ),
        alignment: Alignment.center,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(Icons.tune_rounded,
                color: active ? AppColors.cream : AppColors.softBrown,
                size: 20),
            if (badge > 0)
              Positioned(
                top: -6,
                right: -6,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                      color: AppColors.terracotta, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Text('$badge',
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.white, fontSize: 9)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  final String sortBy;
  final ValueChanged<String> onChanged;

  const _SortButton({required this.sortBy, required this.onChanged});

  static const _options = [
    ('default', 'Default'),
    ('price_low', 'Price: Low → High'),
    ('price_high', 'Price: High → Low'),
    ('rating', 'Top Rated'),
    ('popular', 'Most Popular'),
  ];

  @override
  Widget build(BuildContext context) {
    final isActive = sortBy != 'default';
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: AppColors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) => Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.beige,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Sort by', style: AppTextStyles.headlineSmall),
                const SizedBox(height: 12),
                ..._options.map((opt) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        onChanged(opt.$1);
                        Navigator.pop(context);
                      },
                      title: Text(opt.$2, style: AppTextStyles.bodyLarge),
                      trailing: sortBy == opt.$1
                          ? const Icon(Icons.check_rounded,
                              color: AppColors.sage)
                          : null,
                    )),
              ],
            ),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? AppColors.darkBrown : AppColors.beige,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(Icons.sort_rounded,
                color: isActive ? AppColors.cream : AppColors.softBrown,
                size: 14),
            const SizedBox(width: 5),
            Text(
              isActive
                  ? _options
                      .firstWhere((o) => o.$1 == sortBy)
                      .$2
                      .split(':')
                      .first
                  : 'Sort',
              style: AppTextStyles.label.copyWith(
                color: isActive ? AppColors.cream : AppColors.softBrown,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewToggle extends StatelessWidget {
  final bool isGrid;
  final ValueChanged<bool> onToggle;

  const _ViewToggle({required this.isGrid, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ToggleBtn(
          icon: Icons.view_list_rounded,
          active: !isGrid,
          onTap: () => onToggle(false),
        ),
        const SizedBox(width: 4),
        _ToggleBtn(
          icon: Icons.grid_view_rounded,
          active: isGrid,
          onTap: () => onToggle(true),
        ),
      ],
    );
  }
}

class _ToggleBtn extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _ToggleBtn(
      {required this.icon, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: active ? AppColors.darkBrown : AppColors.beige,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Icon(icon,
            color: active ? AppColors.cream : AppColors.softBrown, size: 16),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onClear;

  const _EmptyState({required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          const Text('🔍', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 14),
          Text('No items found', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 6),
          Text('Try adjusting your search or filters',
              style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onClear,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.darkBrown, width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('Clear all',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.darkBrown)),
            ),
          ),
        ],
      ),
    );
  }
}
