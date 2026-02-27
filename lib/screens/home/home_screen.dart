import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                IconButton(
                  onPressed: () {},
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).dividerColor,
                    foregroundColor:
                        Theme.of(context).colorScheme.onSurfaceVariant,
                    minimumSize: const Size(44, 44),
                  ),
                  icon: const Icon(Icons.notifications_outlined, size: 22),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ── Search + Filter ──────────────────────────────────────
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.only(bottom: _showFilter ? 12 : 20),
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
                            style: Theme.of(context).textTheme.labelSmall),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: BakeryData.dietaryFilterOptions.map((f) {
                            final active = _activeFilters.contains(f);
                            final label = f.replaceAll(' Option', '');
                            return FilterChip(
                              label: Text(label),
                              selected: active,
                              onSelected: (selected) => setState(() {
                                if (selected) {
                                  _activeFilters.add(f);
                                } else {
                                  _activeFilters.remove(f);
                                }
                              }),
                              selectedColor:
                                  Theme.of(context).colorScheme.primary,
                              checkmarkColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              side: BorderSide(
                                color: active
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).dividerColor,
                                width: 1.5,
                              ),
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    color: active
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onPrimary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                    fontSize: 12,
                                  ),
                            );
                          }).toList(),
                        ),
                        if (_activeFilters.isNotEmpty)
                          TextButton(
                            onPressed: () =>
                                setState(() => _activeFilters.clear()),
                            child: Text('Clear all filters',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        fontSize: 12)),
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
                      Text('Recent Orders',
                          style: Theme.of(context).textTheme.headlineSmall),
                      GestureDetector(
                        onTap: widget.onOrdersTab,
                        child: Text('View all →',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
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
                      itemBuilder: (_, i) => GestureDetector(
                        onTap: widget.onOrdersTab,
                        child: SizedBox(
                          width: 200,
                          child: OrderCard(
                            order: BakeryData.recentOrders[i],
                            featured: i == 0,
                            onReorder: () => widget.onOrdersTab(),
                          ),
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
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),

                // Section title + Sort + View toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Fresh Today',
                        style: Theme.of(context).textTheme.headlineMedium),
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
                      childAspectRatio: 0.95,
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
        ],
      ),
    );
  }
}

// ── Private helper widgets ────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
      decoration: InputDecoration(
        hintText: 'Search breads, pastries...',
        prefixIcon: Icon(Icons.search_rounded,
            color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                onPressed: onClear,
                icon: Icon(Icons.close_rounded,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 16),
              )
            : null,
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
    return Badge(
      isLabelVisible: badge > 0,
      label: Text('$badge',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onTertiary, fontSize: 9)),
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      offset: const Offset(-4, 4),
      child: IconButton(
        isSelected: active,
        onPressed: onTap,
        icon: const Icon(Icons.tune_rounded, size: 20),
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
    return TextButton.icon(
      onPressed: () {
        showModalBottomSheet(
          context: context,
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
                      color: Theme.of(context).dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Sort by',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 12),
                ..._options.map((opt) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        onChanged(opt.$1);
                        Navigator.pop(context);
                      },
                      title: Text(opt.$2,
                          style: Theme.of(context).textTheme.bodyLarge),
                      trailing: sortBy == opt.$1
                          ? Icon(Icons.check_rounded,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer)
                          : null,
                    )),
              ],
            ),
          ),
        );
      },
      statesController:
          WidgetStatesController({if (isActive) WidgetState.selected}),
      icon: const Icon(Icons.sort_rounded, size: 14),
      label: Text(
        isActive
            ? _options.firstWhere((o) => o.$1 == sortBy).$2.split(':').first
            : 'Sort',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 12),
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
    return SegmentedButton<bool>(
      showSelectedIcon: false,
      segments: const [
        ButtonSegment(value: false, icon: Icon(Icons.view_list_rounded)),
        ButtonSegment(value: true, icon: Icon(Icons.grid_view_rounded)),
      ],
      selected: {isGrid},
      onSelectionChanged: (set) => onToggle(set.first),
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
          Text('No items found',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 6),
          Text('Try adjusting your search or filters',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: onClear,
            child: const Text('Clear all'),
          ),
        ],
      ),
    );
  }
}
