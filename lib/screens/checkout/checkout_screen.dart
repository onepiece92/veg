import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_decorations.dart';
import '../../models/address.dart';
import '../../providers/cart_provider.dart';
import '../../providers/address_provider.dart';
import '../../components/primary_button.dart';

class CheckoutScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onPlaceOrder;

  const CheckoutScreen({
    super.key,
    required this.onBack,
    required this.onPlaceOrder,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _step = 1; // 1 = delivery, 2 = payment, 3 = confirm
  int _selectedPayment = 0;

  static const _paymentMethods = [
    (icon: '💳', label: '•••• 4289', sub: 'Visa ending in 4289'),
    (icon: '🍎', label: 'Apple Pay', sub: 'Express checkout'),
  ];

  String _stepLabel(Address addr) =>
      addr.type == 'Pickup' ? 'Pickup' : 'Delivery';

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final addr = context.watch<AddressProvider>().selected;
    final step1Label = _stepLabel(addr);

    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: widget.onBack,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: AppDecorations.beigeRounded,
                          alignment: Alignment.center,
                          child: const Icon(Icons.chevron_left_rounded,
                              color: AppColors.darkBrown, size: 24),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text('Checkout', style: AppTextStyles.headlineLarge),
                    ],
                  ),
                ),

                // Step indicator
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                  child: Row(
                    children: [
                      _StepIndicator(
                          label: step1Label, step: 1, current: _step),
                      const SizedBox(width: 6),
                      _StepIndicator(label: 'Payment', step: 2, current: _step),
                      const SizedBox(width: 6),
                      _StepIndicator(label: 'Confirm', step: 3, current: _step),
                    ],
                  ),
                ),

                // Step content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 140),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _step == 1
                          ? _Step1(addr: addr, key: const ValueKey(1))
                          : _step == 2
                              ? _Step2(
                                  methods: _paymentMethods,
                                  selected: _selectedPayment,
                                  onSelect: (i) =>
                                      setState(() => _selectedPayment = i),
                                  key: const ValueKey(2),
                                )
                              : _Step3(
                                  cart: cart,
                                  addr: addr,
                                  key: const ValueKey(3),
                                ),
                    ),
                  ),
                ),
              ],
            ),

            // CTA Button
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
                      AppColors.warmWhite.withValues(alpha: 0),
                      AppColors.warmWhite
                    ],
                  ),
                ),
                child: PrimaryButton(
                  label: _step < 3
                      ? 'Continue'
                      : 'Place Order — \$${cart.total.toStringAsFixed(2)}',
                  onTap: () {
                    if (_step < 3) {
                      setState(() => _step++);
                    } else {
                      widget.onPlaceOrder();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final String label;
  final int step;
  final int current;

  const _StepIndicator(
      {required this.label, required this.step, required this.current});

  @override
  Widget build(BuildContext context) {
    final active = step <= current;
    final isCurrent = step == current;
    return Expanded(
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            height: 3,
            decoration: BoxDecoration(
              color: active ? AppColors.darkBrown : AppColors.beige,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: active ? AppColors.darkBrown : AppColors.textLight,
              fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _Step1 extends StatelessWidget {
  final dynamic addr;

  const _Step1({required this.addr, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${addr.type == 'Pickup' ? 'Pickup' : 'Delivery'} Details',
            style: AppTextStyles.headlineSmall),
        const SizedBox(height: 16),
        _InfoTile(
          label: addr.type == 'Pickup' ? 'PICKUP LOCATION' : 'DELIVERY ADDRESS',
          icon: addr.icon,
          title: addr.label,
          subtitle: addr.address,
        ),
        const SizedBox(height: 12),
        _InfoTile(
          label: '${addr.type == 'Pickup' ? 'PICKUP' : 'DELIVERY'} TIME',
          icon: '🕐',
          title: 'Today, 11:00 AM – 11:30 AM',
          subtitle: null,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.beige, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('SPECIAL INSTRUCTIONS',
                  style: AppTextStyles.labelSmall
                      .copyWith(fontSize: 11, letterSpacing: 0.5)),
              const SizedBox(height: 8),
              TextField(
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'Any special requests for your order...',
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String icon;
  final String title;
  final String? subtitle;

  const _InfoTile({
    required this.label,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.beige, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppTextStyles.labelSmall
                  .copyWith(fontSize: 11, letterSpacing: 0.5)),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkBrown)),
                    if (subtitle != null)
                      Text(subtitle!,
                          style:
                              AppTextStyles.bodySmall.copyWith(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Step2 extends StatelessWidget {
  final List<({String icon, String label, String sub})> methods;
  final int selected;
  final ValueChanged<int> onSelect;

  const _Step2(
      {required this.methods,
      required this.selected,
      required this.onSelect,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Method', style: AppTextStyles.headlineSmall),
        const SizedBox(height: 16),
        ...methods.asMap().entries.map((e) {
          final i = e.key;
          final m = e.value;
          final isSelected = selected == i;
          return GestureDetector(
            onTap: () => onSelect(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: isSelected ? AppColors.darkBrown : AppColors.beige,
                    width: 1.5),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.darkBrown.withValues(alpha: 0.1)
                          : AppColors.beige,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Text(m.icon, style: const TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m.label,
                            style: AppTextStyles.bodyLarge
                                .copyWith(fontWeight: FontWeight.w500)),
                        Text(m.sub,
                            style:
                                AppTextStyles.bodySmall.copyWith(fontSize: 12)),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                          color: AppColors.darkBrown, shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: const Icon(Icons.check_rounded,
                          color: AppColors.cream, size: 12),
                    )
                  else
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.beige, width: 2)),
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _Step3 extends StatelessWidget {
  final CartProvider cart;
  final dynamic addr;

  const _Step3({required this.cart, required this.addr, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order Summary', style: AppTextStyles.headlineSmall),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: AppDecorations.card,
          child: Column(
            children: [
              ...cart.items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Text(item.product.image,
                            style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.product.name,
                                  style: AppTextStyles.bodyMedium
                                      .copyWith(color: AppColors.darkBrown)),
                              Text('× ${item.quantity}',
                                  style: AppTextStyles.bodySmall
                                      .copyWith(fontSize: 12)),
                            ],
                          ),
                        ),
                        Text(
                          '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                          style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.darkBrown),
                        ),
                      ],
                    ),
                  )),
              const Divider(color: AppColors.beige, height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total', style: AppTextStyles.headlineSmall),
                  Text('\$${cart.total.toStringAsFixed(2)}',
                      style: AppTextStyles.priceLarge.copyWith(fontSize: 20)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
