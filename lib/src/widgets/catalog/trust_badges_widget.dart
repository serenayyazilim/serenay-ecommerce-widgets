import 'package:flutter/material.dart';

import '../../core/theme/ecommerce_widget_theme.dart';

/// TRUSTBADGES: a static row of reassurance icons (secure payment, free
/// shipping, easy returns, ...) with a caption under each — purely
/// informational, no tap contract. Reads its entries straight from
/// `params['list']` (`{"icon": "shipping", "label": "Free Shipping"}`), the
/// same inline-list contract as CATEGORYMENU/REVIEWS.
class TrustBadgesWidget extends StatelessWidget {
  const TrustBadgesWidget({
    super.key,
    required this.params,
    this.theme = const EcommerceWidgetTheme(),
  });

  final Map<String, dynamic> params;
  final EcommerceWidgetTheme theme;

  static const Map<String, IconData> _icons = {
    'shipping': Icons.local_shipping_outlined,
    'secure': Icons.lock_outline,
    'payment': Icons.credit_card,
    'returns': Icons.assignment_return_outlined,
    'support': Icons.support_agent_outlined,
    'guarantee': Icons.verified_outlined,
  };

  List<Map<String, dynamic>> get _items => ((params['list'] as List?) ?? const [])
      .whereType<Map>()
      .map((e) => Map<String, dynamic>.from(e))
      .toList();

  @override
  Widget build(BuildContext context) {
    final items = _items;
    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: theme.spaceM, vertical: theme.spaceS),
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        spacing: theme.spaceM,
        runSpacing: theme.spaceS,
        children: [for (final item in items) _Badge(item: item, theme: theme)],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.item, required this.theme});

  final Map<String, dynamic> item;
  final EcommerceWidgetTheme theme;

  @override
  Widget build(BuildContext context) {
    final iconKey = item['icon'] as String?;
    final label = (item['label'] as String?) ?? '';
    final icon = TrustBadgesWidget._icons[iconKey] ?? Icons.check_circle_outline;

    return SizedBox(
      width: 76,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: theme.primaryColor),
          SizedBox(height: theme.spaceXs),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.captionStyle.copyWith(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
