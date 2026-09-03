import 'dart:async';

import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/product_card_data.dart';
import '../../contracts/product_query.dart';
import '../../contracts/widget_action.dart';
import '../../core/theme/ecommerce_widget_theme.dart';
import 'mini_product_tile.dart';

/// ABANDONEDCART: a "you left items in your cart" card — the same
/// product-query contract as BUNDLE/CAROUSEL (typically the backend's
/// current cart/reservation contents), rendered as a horizontally-scrolling
/// row of [MiniProductTile]s under an optional reservation countdown, with a
/// single CTA that resolves through the shared action contract (usually
/// back to the cart/checkout screen).
///
/// Hides itself once the product list comes back empty, or once `end_time`
/// (the reservation expiry) has passed, matching COUPON/FLASHSALE's
/// disappear-on-expiry behavior.
class AbandonedCartWidget extends StatefulWidget {
  const AbandonedCartWidget({
    super.key,
    required this.params,
    required this.callbacks,
    this.theme = const EcommerceWidgetTheme(),
  });

  final Map<String, dynamic> params;
  final WidgetCallbacks callbacks;
  final EcommerceWidgetTheme theme;

  @override
  State<AbandonedCartWidget> createState() => _AbandonedCartWidgetState();
}

class _AbandonedCartWidgetState extends State<AbandonedCartWidget> {
  late final Future<List<ProductCardData>> _future =
      widget.callbacks.fetchProducts(ProductQuery.fromParams(widget.params));

  Timer? _ticker;
  DateTime? _endTime;

  @override
  void initState() {
    super.initState();
    _endTime = _parseDate(widget.params['end_time']);
    if (_endTime != null) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  DateTime? _parseDate(dynamic raw) {
    if (raw == null) return null;
    if (raw is num) return DateTime.fromMillisecondsSinceEpoch(raw.toInt() * 1000);
    if (raw is String) return DateTime.tryParse(raw);
    return null;
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  String _timerText(Duration remaining) {
    final h = remaining.inHours;
    final m = remaining.inMinutes % 60;
    final s = remaining.inSeconds % 60;
    if (h > 0) return '${_pad(h)}:${_pad(m)}:${_pad(s)}';
    return '${_pad(m)}:${_pad(s)}';
  }

  void _handleTap() {
    widget.callbacks.onAction(WidgetAction.fromParams(widget.params));
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final now = DateTime.now();
    if (_endTime != null && _endTime!.isBefore(now)) {
      return const SizedBox.shrink();
    }

    return FutureBuilder<List<ProductCardData>>(
      future: _future,
      builder: (context, snapshot) {
        final products = snapshot.data ?? const [];
        if (products.isEmpty) return const SizedBox.shrink();

        final title = (widget.params['title'] as String?) ?? theme.abandonedCartTitleLabel;
        final remaining = _endTime?.difference(now);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            padding: EdgeInsets.all(theme.spaceM),
            decoration: BoxDecoration(
              color: theme.surfaceColor,
              borderRadius: BorderRadius.circular(theme.radiusM),
              border: Border.all(color: theme.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: 18, color: theme.discountColor),
                    SizedBox(width: theme.spaceXs),
                    Expanded(
                      child: Text(title, style: theme.productTitleStyle.copyWith(fontSize: 15)),
                    ),
                  ],
                ),
                if (remaining != null) ...[
                  SizedBox(height: theme.spaceXs),
                  Text(
                    '${theme.abandonedCartReservedLabel} ${_timerText(remaining)}',
                    style: theme.captionStyle.copyWith(
                      color: theme.discountColor,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
                SizedBox(height: theme.spaceM),
                SizedBox(
                  height: 170,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    separatorBuilder: (_, _) => SizedBox(width: theme.spaceS),
                    itemBuilder: (context, index) => SizedBox(
                      width: 100,
                      child: MiniProductTile(
                        data: products[index],
                        callbacks: widget.callbacks,
                        imageSize: 80,
                        theme: theme,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: theme.spaceM),
                SizedBox(
                  width: double.infinity,
                  height: theme.buttonHeight,
                  child: ElevatedButton(
                    onPressed: _handleTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(theme.radiusS)),
                    ),
                    child: Text(theme.abandonedCartCtaLabel, style: theme.buttonLabelStyle),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
