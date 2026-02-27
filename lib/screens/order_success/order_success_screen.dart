import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_decorations.dart';
import '../../components/primary_button.dart';

class OrderSuccessScreen extends StatefulWidget {
  final VoidCallback onContinueShopping;
  final VoidCallback onTrackOrder;

  const OrderSuccessScreen({
    super.key,
    required this.onContinueShopping,
    required this.onTrackOrder,
  });

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _confettiCtrl;
  late AnimationController _contentCtrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  static const _steps = [
    (icon: '✅', label: 'Order Confirmed', desc: 'We have received your order'),
    (icon: '👩‍🍳', label: 'Preparing', desc: 'Our bakers are at work'),
    (
      icon: '🎁',
      label: 'Ready for Pickup',
      desc: 'Your order will be ready at 11:00 AM'
    ),
  ];

  @override
  void initState() {
    super.initState();
    _confettiCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800))
      ..forward();
    _contentCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));

    _scaleAnim =
        CurvedAnimation(parent: _contentCtrl, curve: Curves.elasticOut);
    _fadeAnim = CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOut);

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _contentCtrl.forward();
    });
  }

  @override
  void dispose() {
    _confettiCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Success icon
              ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.sage, Color(0xFF88B07A)],
                    ),
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.sage.withOpacity(0.3),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text('✓',
                      style: TextStyle(
                          fontSize: 52,
                          color: Colors.white,
                          fontWeight: FontWeight.w300)),
                ),
              ),
              const SizedBox(height: 24),
              FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    Text('🎉 Order Placed!',
                        style:
                            AppTextStyles.displayLarge.copyWith(fontSize: 26)),
                    const SizedBox(height: 8),
                    Text(
                      '#OD-2849 • Est. ready at 11:00 AM',
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Progress
              Container(
                padding: const EdgeInsets.all(20),
                decoration: AppDecorations.card,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order Progress',
                            style: AppTextStyles.headlineSmall),
                        Text('Step 1 of 3',
                            style: AppTextStyles.label
                                .copyWith(color: AppColors.caramel)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ..._steps.asMap().entries.map((e) {
                      final i = e.key;
                      final s = e.value;
                      final isActive = i == 0;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppColors.sage.withOpacity(0.14)
                                    : AppColors.beige,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              alignment: Alignment.center,
                              child: Text(s.icon,
                                  style: const TextStyle(fontSize: 18)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(s.label,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: isActive
                                            ? AppColors.darkBrown
                                            : AppColors.textLight,
                                        fontWeight: isActive
                                            ? FontWeight.w500
                                            : FontWeight.w400,
                                      )),
                                  Text(s.desc,
                                      style: AppTextStyles.bodySmall
                                          .copyWith(fontSize: 12)),
                                ],
                              ),
                            ),
                            if (isActive)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                    color: AppColors.sage,
                                    shape: BoxShape.circle),
                              ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Track My Order',
                onTap: widget.onTrackOrder,
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: widget.onContinueShopping,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  alignment: Alignment.center,
                  child: Text('Continue Shopping',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.softBrown)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
