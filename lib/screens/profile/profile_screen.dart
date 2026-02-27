import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../components/loyalty_card.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onOrders;
  final VoidCallback onFavourites;
  final VoidCallback onAddresses;
  final VoidCallback onPayments;
  final VoidCallback onNotifications;
  final VoidCallback onSettings;

  const ProfileScreen({
    super.key,
    required this.onEditProfile,
    required this.onOrders,
    required this.onFavourites,
    required this.onAddresses,
    required this.onPayments,
    required this.onNotifications,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
        children: [
          Text('My Profile', style: AppTextStyles.displayMedium),
          const SizedBox(height: 20),

          // Profile card
          GestureDetector(
            onTap: onEditProfile,
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFFAF3), Color(0x66F5E6D3)],
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.lightGold),
              ),
              child: Row(
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [AppColors.golden, AppColors.caramel]),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    alignment: Alignment.center,
                    child: Text('S',
                        style: AppTextStyles.displayLarge
                            .copyWith(color: AppColors.white, fontSize: 28)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sophie Martin',
                            style: AppTextStyles.headlineLarge),
                        Text('sophie.martin@email.com',
                            style:
                                AppTextStyles.bodySmall.copyWith(fontSize: 13)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.golden.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('🥐 Croissant Member',
                              style: AppTextStyles.label.copyWith(
                                  color: AppColors.caramel, fontSize: 11)),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded,
                      color: AppColors.textLight, size: 22),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Loyalty card
          const LoyaltyCard(),
          const SizedBox(height: 24),

          // Menu sections
          _SectionHeader(label: 'ORDERS & HISTORY'),
          const SizedBox(height: 8),
          _MenuTile(
              icon: '📦',
              label: 'My Orders',
              sub: '4 recent orders',
              onTap: onOrders),
          _MenuTile(
              icon: '❤️',
              label: 'Favourites',
              sub: 'Saved items',
              onTap: onFavourites),
          const SizedBox(height: 16),
          _SectionHeader(label: 'ACCOUNT'),
          const SizedBox(height: 8),
          _MenuTile(
              icon: '📍',
              label: 'Saved Addresses',
              sub: 'Manage delivery locations',
              onTap: onAddresses),
          _MenuTile(
              icon: '💳',
              label: 'Payment Methods',
              sub: 'Cards & digital wallets',
              onTap: onPayments),
          const SizedBox(height: 16),
          _SectionHeader(label: 'PREFERENCES'),
          const SizedBox(height: 8),
          _MenuTile(
              icon: '🔔',
              label: 'Notifications',
              sub: 'Push & email settings',
              onTap: onNotifications),
          _MenuTile(
              icon: '⚙️',
              label: 'Settings',
              sub: 'App preferences',
              onTap: onSettings),
          const SizedBox(height: 20),

          // Sign out
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.terracotta.withOpacity(0.07),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.terracotta.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: const Text('👋', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(width: 14),
                  Text('Sign Out',
                      style: AppTextStyles.bodyLarge
                          .copyWith(color: AppColors.terracotta)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;

  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label,
        style:
            AppTextStyles.labelSmall.copyWith(letterSpacing: 1, fontSize: 11));
  }
}

class _MenuTile extends StatelessWidget {
  final String icon;
  final String label;
  final String? sub;
  final VoidCallback? onTap;

  const _MenuTile(
      {required this.icon, required this.label, this.sub, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.beige,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Text(icon, style: const TextStyle(fontSize: 18)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.bodyLarge),
                  if (sub != null)
                    Text(sub!,
                        style: AppTextStyles.bodySmall.copyWith(fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textLight, size: 20),
          ],
        ),
      ),
    );
  }
}
