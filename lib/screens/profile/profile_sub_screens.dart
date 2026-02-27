import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_decorations.dart';
import '../../components/primary_button.dart';
import '../../data/bakery_data.dart';

// ── Edit Profile ──────────────────────────────────────────────────────────────

class EditProfileScreen extends StatefulWidget {
  final VoidCallback onBack;

  const EditProfileScreen({super.key, required this.onBack});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String _selectedDiet = 'None';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      body: SafeArea(
        child: Column(
          children: [
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
                  Text('Edit Profile', style: AppTextStyles.headlineLarge),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [
                                AppColors.golden,
                                AppColors.caramel
                              ]),
                              borderRadius: BorderRadius.circular(28),
                            ),
                            alignment: Alignment.center,
                            child: Text('S',
                                style: AppTextStyles.displayLarge.copyWith(
                                    color: Colors.white, fontSize: 32)),
                          ),
                          const SizedBox(height: 8),
                          Text('Change photo',
                              style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.caramel,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _FieldLabel('FULL NAME'),
                    _FieldInput(hint: 'Sophie Martin'),
                    const SizedBox(height: 14),
                    _FieldLabel('EMAIL'),
                    _FieldInput(hint: 'sophie.martin@email.com'),
                    const SizedBox(height: 14),
                    _FieldLabel('PHONE'),
                    _FieldInput(hint: '+44 7700 900 123'),
                    const SizedBox(height: 14),
                    _FieldLabel('BIRTHDAY'),
                    _FieldInput(
                        hint: 'March 14, 1990',
                        suffixIcon: Icons.calendar_today_outlined),
                    const SizedBox(height: 14),
                    _FieldLabel('BIO'),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.beige, width: 1.5),
                      ),
                      child: TextField(
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Pastry enthusiast and weekend baker...',
                          hintStyle: AppTextStyles.bodyMedium
                              .copyWith(color: AppColors.textLight),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _FieldLabel('DIETARY PREFERENCE'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: BakeryData.dietaryPreferenceOptions.map((d) {
                        final active = d == _selectedDiet;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedDiet = d),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 9),
                            decoration: BoxDecoration(
                              color: active
                                  ? AppColors.darkBrown
                                  : AppColors.beige,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(d,
                                style: AppTextStyles.label.copyWith(
                                  color: active
                                      ? AppColors.cream
                                      : AppColors.softBrown,
                                  fontSize: 13,
                                )),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: PrimaryButton(label: 'Save Changes', onTap: widget.onBack),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text,
          style: AppTextStyles.labelSmall
              .copyWith(fontSize: 11, letterSpacing: 0.5)),
    );
  }
}

class _FieldInput extends StatelessWidget {
  final String hint;
  final IconData? suffixIcon;

  const _FieldInput({required this.hint, this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.beige, width: 1.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(hint,
                style:
                    AppTextStyles.bodyMedium.copyWith(color: AppColors.text)),
          ),
          if (suffixIcon != null)
            Icon(suffixIcon, color: AppColors.textLight, size: 18),
        ],
      ),
    );
  }
}

// ── Saved Addresses ──────────────────────────────────────────────────────────

class SavedAddressesScreen extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onAddNew;

  const SavedAddressesScreen(
      {super.key, required this.onBack, required this.onAddNew});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: onBack,
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
                  Text('Saved Addresses', style: AppTextStyles.headlineLarge),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                children: [
                  ...BakeryData.savedAddresses.map((a) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: AppDecorations.card,
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.beige,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            alignment: Alignment.center,
                            child: Text(a.icon,
                                style: const TextStyle(fontSize: 20)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(a.label,
                                        style: AppTextStyles.bodyLarge.copyWith(
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 7, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: a.type == 'Pickup'
                                            ? AppColors.sage.withOpacity(0.12)
                                            : AppColors.golden
                                                .withOpacity(0.14),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(a.type,
                                          style: AppTextStyles.caption.copyWith(
                                            color: a.type == 'Pickup'
                                                ? AppColors.sage
                                                : AppColors.softBrown,
                                            fontWeight: FontWeight.w500,
                                          )),
                                    ),
                                  ],
                                ),
                                Text(a.address,
                                    style: AppTextStyles.bodySmall
                                        .copyWith(fontSize: 12)),
                              ],
                            ),
                          ),
                          const Icon(Icons.more_vert_rounded,
                              color: AppColors.textLight, size: 20),
                        ],
                      ),
                    );
                  }),
                  GestureDetector(
                    onTap: onAddNew,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.beige, width: 2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_rounded,
                              color: AppColors.softBrown),
                          const SizedBox(width: 8),
                          Text('Add New Address',
                              style: AppTextStyles.bodyMedium
                                  .copyWith(color: AppColors.softBrown)),
                        ],
                      ),
                    ),
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

// ── Payment Methods ──────────────────────────────────────────────────────────

class PaymentMethodsScreen extends StatelessWidget {
  final VoidCallback onBack;

  const PaymentMethodsScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: onBack,
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
                  Text('Payment Methods', style: AppTextStyles.headlineLarge),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                children: [
                  // Card
                  _PaymentCard(
                    icon: '💳',
                    label: 'Visa ending in 4289',
                    sub: 'Expires 09/27',
                    isDefault: true,
                  ),
                  const SizedBox(height: 10),
                  _PaymentCard(
                    icon: '🍎',
                    label: 'Apple Pay',
                    sub: 'Express checkout',
                  ),
                  const SizedBox(height: 10),
                  _PaymentCard(
                    icon: '🅿️',
                    label: 'PayPal',
                    sub: 'sophie@email.com',
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.beige, width: 2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_rounded,
                              color: AppColors.softBrown),
                          const SizedBox(width: 8),
                          Text('Add Payment Method',
                              style: AppTextStyles.bodyMedium
                                  .copyWith(color: AppColors.softBrown)),
                        ],
                      ),
                    ),
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

class _PaymentCard extends StatelessWidget {
  final String icon;
  final String label;
  final String sub;
  final bool isDefault;

  const _PaymentCard(
      {required this.icon,
      required this.label,
      required this.sub,
      this.isDefault = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.card,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.beige,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(icon, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(label,
                        style: AppTextStyles.bodyLarge
                            .copyWith(fontWeight: FontWeight.w500)),
                    if (isDefault) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.sage.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text('Default',
                            style: AppTextStyles.caption.copyWith(
                                color: AppColors.sage,
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ],
                ),
                Text(sub,
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.more_vert_rounded,
              color: AppColors.textLight, size: 20),
        ],
      ),
    );
  }
}

// ── Notifications ──────────────────────────────────────────────────────────

class NotificationsScreen extends StatefulWidget {
  final VoidCallback onBack;

  const NotificationsScreen({super.key, required this.onBack});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _orderUpdates = true;
  bool _promotions = true;
  bool _newItems = false;
  bool _emailNotifs = true;
  bool _smsNotifs = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
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
                  Text('Notifications', style: AppTextStyles.headlineLarge),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _SectionLabel('PUSH NOTIFICATIONS'),
                  const SizedBox(height: 8),
                  _ToggleCard(children: [
                    _Toggle(
                        '🔔',
                        'Order Updates',
                        'Status updates for your orders',
                        _orderUpdates,
                        (v) => setState(() => _orderUpdates = v)),
                    _Toggle('🎁', 'Promotions', 'Special offers and discounts',
                        _promotions, (v) => setState(() => _promotions = v)),
                    _Toggle(
                        '✨',
                        'New Items',
                        'Be first to know about new bakes',
                        _newItems,
                        (v) => setState(() => _newItems = v),
                        showDivider: false),
                  ]),
                  const SizedBox(height: 16),
                  _SectionLabel('OTHER CHANNELS'),
                  const SizedBox(height: 8),
                  _ToggleCard(children: [
                    _Toggle(
                        '📧',
                        'Email Notifications',
                        'Receive updates via email',
                        _emailNotifs,
                        (v) => setState(() => _emailNotifs = v)),
                    _Toggle(
                        '💬',
                        'SMS Notifications',
                        'Receive updates via SMS',
                        _smsNotifs,
                        (v) => setState(() => _smsNotifs = v),
                        showDivider: false),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _Toggle(String icon, String label, String sub, bool value,
      ValueChanged<bool> onChanged,
      {bool showDivider = true}) {
    return _ToggleRow(
      icon: icon,
      label: label,
      sub: sub,
      value: value,
      onChanged: onChanged,
      showDivider: showDivider,
    );
  }
}

// ── Settings ──────────────────────────────────────────────────────────────────

class SettingsScreen extends StatefulWidget {
  final VoidCallback onBack;

  const SettingsScreen({super.key, required this.onBack});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _haptics = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
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
                  Text('Settings', style: AppTextStyles.headlineLarge),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                children: [
                  _SectionLabel('APPEARANCE'),
                  const SizedBox(height: 8),
                  _ToggleCard(children: [
                    _Toggle('🌙', 'Dark Mode', 'Coming soon', _darkMode,
                        (v) => setState(() => _darkMode = v),
                        disabled: true),
                    _Toggle('📱', 'Haptic Feedback', null, _haptics,
                        (v) => setState(() => _haptics = v),
                        showDivider: false),
                  ]),
                  const SizedBox(height: 16),
                  _SectionLabel('DATA'),
                  const SizedBox(height: 8),
                  _ToggleCard(children: [
                    _LinkRow('🗑️', 'Clear Cache', '2.3 MB'),
                    _LinkRow('📊', 'Data & Privacy', null, showDivider: false),
                  ]),
                  const SizedBox(height: 16),
                  _SectionLabel('ABOUT'),
                  const SizedBox(height: 8),
                  _ToggleCard(children: [
                    _LinkRow('✨', 'Version', '2.1.0'),
                    _LinkRow('📋', 'Terms of Service', null),
                    _LinkRow('🔒', 'Privacy Policy', null, showDivider: false),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _Toggle(String icon, String label, String? sub, bool value,
      ValueChanged<bool> onChanged,
      {bool showDivider = true, bool disabled = false}) {
    return _ToggleRow(
      icon: icon,
      label: label,
      sub: sub,
      value: value,
      onChanged: onChanged,
      showDivider: showDivider,
      disabled: disabled,
    );
  }

  Widget _LinkRow(String icon, String label, String? valueText,
      {bool showDivider = true}) {
    return Padding(
      padding: EdgeInsets.only(bottom: showDivider ? 0 : 0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.beige,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Text(icon, style: const TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(label, style: AppTextStyles.bodyLarge),
                ),
                if (valueText != null)
                  Text(valueText,
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 13))
                else
                  const Icon(Icons.chevron_right_rounded,
                      color: AppColors.textLight, size: 20),
              ],
            ),
          ),
          if (showDivider) const Divider(height: 0),
        ],
      ),
    );
  }
}

// ── Add New Address ──────────────────────────────────────────────────────────

class AddNewAddressScreen extends StatelessWidget {
  final VoidCallback onBack;

  const AddNewAddressScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: onBack,
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
                  Text('New Address', style: AppTextStyles.headlineLarge),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Map placeholder
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: AppColors.beige,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🗺️', style: TextStyle(fontSize: 40)),
                          const SizedBox(height: 8),
                          Text('Tap to set location',
                              style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _Lbl('LABEL'),
                    _Inp(hint: 'e.g. Home, Office'),
                    const SizedBox(height: 14),
                    _Lbl('STREET ADDRESS'),
                    _Inp(hint: '123 Baker Street'),
                    const SizedBox(height: 14),
                    _Lbl('CITY'),
                    _Inp(hint: 'London'),
                    const SizedBox(height: 14),
                    _Lbl('POSTCODE'),
                    _Inp(hint: 'W1F 0TH'),
                    const SizedBox(height: 20),
                    _Lbl('ADDRESS TYPE'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.darkBrown,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text('🏠 Delivery',
                                style: AppTextStyles.label.copyWith(
                                    color: AppColors.cream, fontSize: 13)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.beige,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text('🏪 Pickup',
                                style: AppTextStyles.label.copyWith(
                                    color: AppColors.softBrown, fontSize: 13)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: PrimaryButton(label: 'Save Address', onTap: onBack),
            ),
          ],
        ),
      ),
    );
  }

  Widget _Lbl(String t) => Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(t,
          style: AppTextStyles.labelSmall
              .copyWith(fontSize: 11, letterSpacing: 0.5)));

  Widget _Inp({required String hint}) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.beige, width: 1.5),
        ),
        child: Text(hint,
            style:
                AppTextStyles.bodyMedium.copyWith(color: AppColors.textLight)),
      );
}

// ── Shared private ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style:
            AppTextStyles.labelSmall.copyWith(letterSpacing: 1, fontSize: 11));
  }
}

class _ToggleCard extends StatelessWidget {
  final List<Widget> children;

  const _ToggleCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.beige),
      ),
      child: Column(children: children),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String icon;
  final String label;
  final String? sub;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showDivider;
  final bool disabled;

  const _ToggleRow({
    required this.icon,
    required this.label,
    required this.sub,
    required this.value,
    required this.onChanged,
    this.showDivider = true,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
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
                            style:
                                AppTextStyles.bodySmall.copyWith(fontSize: 12)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: disabled ? null : () => onChanged(!value),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 48,
                    height: 28,
                    decoration: BoxDecoration(
                      color: value ? AppColors.sage : AppColors.beige,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 250),
                      alignment:
                          value ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.all(3),
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(11),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 3,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (showDivider) const Divider(height: 0),
        ],
      ),
    );
  }
}
