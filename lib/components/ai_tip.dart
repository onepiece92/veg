import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../providers/nav_provider.dart';

class AiTip extends StatefulWidget {
  const AiTip({super.key});

  @override
  State<AiTip> createState() => _AiTipState();
}

class _AiTipState extends State<AiTip> with SingleTickerProviderStateMixin {
  late String _currentTip;
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  final List<String> _tips = [
    "Leafy greens like spinach and kale are rich in iron, calcium and folate — order in bulk for consistent supply to your restaurant or retail clients.",
    "Tomatoes are best stored at room temperature before sale. Refrigeration below 10°C can diminish flavour and soften texture.",
    "Seasonal produce costs up to 40% less than out-of-season imports. Plan your menu around what's harvested now for better margins.",
    "Organic certification adds value to your offering — consumers are willing to pay 20–30% more for certified organic fruits and vegetables.",
    "Broccoli and cruciferous vegetables retain more nutrients when stored dry and cool. Avoid ethylene-producing fruits nearby in cold storage.",
    "Fresh herbs like basil and coriander are high-margin add-ons. A small weekly order can significantly boost your average basket value.",
    "Ripe mangoes and tropical fruit emit ethylene gas, which accelerates ripening of nearby produce. Store separately in your cold room.",
    "Proper hydration of leafy greens during transport can extend shelf life by 2–3 days, reducing shrinkage and waste for your business.",
  ];

  NavProvider? _navProvider;

  @override
  void initState() {
    super.initState();
    _currentTip = _tips[Random().nextInt(_tips.length)];
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut);
    _animCtrl.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _navProvider ??= context.read<NavProvider>()..addListener(_generateNewTip);
  }

  @override
  void dispose() {
    _navProvider?.removeListener(_generateNewTip);
    _animCtrl.dispose();
    super.dispose();
  }

  void _generateNewTip() {
    if (_animCtrl.isAnimating) return;
    _animCtrl.reverse().then((_) {
      setState(() {
        String newTip;
        do {
          newTip = _tips[Random().nextInt(_tips.length)];
        } while (newTip == _currentTip && _tips.length > 1);
        _currentTip = newTip;
      });
      _animCtrl.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _generateNewTip,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .tertiary
                    .withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.auto_awesome_rounded,
                  color: Theme.of(context).colorScheme.tertiary, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Wholesale Produce Tip',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontWeight: FontWeight.w600,
                          )),
                  const SizedBox(height: 6),
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: Text(
                      _currentTip,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            height: 1.4,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
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
