import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../models/product.dart';
import '../data/bakery_data.dart';
import '../providers/cart_provider.dart';
import '../components/bottom_nav_bar.dart';
import '../screens/home/home_screen.dart';
import '../screens/product/product_detail_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/checkout/checkout_screen.dart';
import '../screens/order_success/order_success_screen.dart';
import '../screens/orders/recent_orders_screen.dart';
import '../screens/favourites/favourites_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/profile_sub_screens.dart';

/// Named enum for all possible app screens.
enum _AppRoute {
  home,
  productDetail,
  cart,
  checkout,
  orderSuccess,
  recentOrders,
  favourites,
  profile,
  editProfile,
  savedAddresses,
  addAddress,
  payments,
  notifications,
  settings,
}

/// Root app shell — manages bottom nav and screen stack.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  _AppRoute _currentRoute = _AppRoute.home;
  int _navIndex = 0;

  // Bottom nav tabs
  static const _navTabs = [
    _AppRoute.home,
    _AppRoute.favourites,
    _AppRoute.cart,
    _AppRoute.profile,
  ];

  // Screens that show the bottom nav bar
  static const _tabRoutes = {
    _AppRoute.home,
    _AppRoute.favourites,
    _AppRoute.cart,
    _AppRoute.profile,
  };

  Product? _selectedProduct;

  void _navigate(_AppRoute route) {
    HapticFeedback.selectionClick();
    setState(() {
      _currentRoute = route;
      if (_tabRoutes.contains(route)) {
        _navIndex = _navTabs.indexOf(route);
      }
    });
  }

  void _onNavTap(int index) {
    _navigate(_navTabs[index]);
  }

  void _onProductTap(Product p) {
    setState(() {
      _selectedProduct = p;
      _currentRoute = _AppRoute.productDetail;
    });
  }

  Widget _buildCurrentScreen() {
    switch (_currentRoute) {
      case _AppRoute.home:
        return HomeScreen(
          onProductTap: _onProductTap,
          onOrdersTab: () => _navigate(_AppRoute.recentOrders),
        );
      case _AppRoute.productDetail:
        return ProductDetailScreen(
          product: _selectedProduct!,
          onBack: () => setState(() => _currentRoute = _AppRoute.home),
          onAddToCart: (p, qty) {
            context.read<CartProvider>().addProduct(p, quantity: qty);
            setState(() => _currentRoute = _AppRoute.home);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${p.name} added to cart',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.cream)),
                backgroundColor: AppColors.darkBrown,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                duration: const Duration(milliseconds: 1500),
              ),
            );
          },
          onProductTap: _onProductTap,
        );
      case _AppRoute.cart:
        return CartScreen(
          onBack: () => _navigate(_AppRoute.home),
          onCheckout: () => _navigate(_AppRoute.checkout),
          onQuickAdd: (p) => context.read<CartProvider>().addProduct(p),
        );
      case _AppRoute.checkout:
        return CheckoutScreen(
          onBack: () => _navigate(_AppRoute.cart),
          onPlaceOrder: () {
            context.read<CartProvider>().clear();
            _navigate(_AppRoute.orderSuccess);
          },
        );
      case _AppRoute.orderSuccess:
        return OrderSuccessScreen(
          onContinueShopping: () => _navigate(_AppRoute.home),
          onTrackOrder: () => _navigate(_AppRoute.recentOrders),
        );
      case _AppRoute.recentOrders:
        return RecentOrdersScreen(
          onBack: () => _navigate(_AppRoute.home),
          onReorder: (order) {
            final cart = context.read<CartProvider>();
            for (final item in order.items) {
              final product = BakeryData.products
                  .where((p) => p.name == item.name)
                  .firstOrNull;
              if (product != null) {
                cart.addProduct(product, quantity: item.qty);
              }
            }
            _navigate(_AppRoute.cart);
          },
        );
      case _AppRoute.favourites:
        return FavouritesScreen(onProductTap: _onProductTap);
      case _AppRoute.profile:
        return ProfileScreen(
          onEditProfile: () => _navigate(_AppRoute.editProfile),
          onOrders: () => _navigate(_AppRoute.recentOrders),
          onFavourites: () => _navigate(_AppRoute.favourites),
          onAddresses: () => _navigate(_AppRoute.savedAddresses),
          onPayments: () => _navigate(_AppRoute.payments),
          onNotifications: () => _navigate(_AppRoute.notifications),
          onSettings: () => _navigate(_AppRoute.settings),
        );
      case _AppRoute.editProfile:
        return EditProfileScreen(onBack: () => _navigate(_AppRoute.profile));
      case _AppRoute.savedAddresses:
        return SavedAddressesScreen(
          onBack: () => _navigate(_AppRoute.profile),
          onAddNew: () => _navigate(_AppRoute.addAddress),
        );
      case _AppRoute.addAddress:
        return AddNewAddressScreen(
            onBack: () => _navigate(_AppRoute.savedAddresses));
      case _AppRoute.payments:
        return PaymentMethodsScreen(onBack: () => _navigate(_AppRoute.profile));
      case _AppRoute.notifications:
        return NotificationsScreen(onBack: () => _navigate(_AppRoute.profile));
      case _AppRoute.settings:
        return SettingsScreen(onBack: () => _navigate(_AppRoute.profile));
    }
  }

  bool get _showNav => _tabRoutes.contains(_currentRoute);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, anim) =>
            FadeTransition(opacity: anim, child: child),
        child: KeyedSubtree(
          key: ValueKey(_currentRoute),
          child: _buildCurrentScreen(),
        ),
      ),
      bottomNavigationBar: _showNav
          ? AppBottomNavBar(
              currentIndex: _navIndex,
              onTap: _onNavTap,
            )
          : null,
    );
  }
}
