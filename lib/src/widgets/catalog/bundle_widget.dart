import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/product_card_data.dart';
import '../../contracts/product_query.dart';
import '../../core/theme/ecommerce_widget_theme.dart';
import 'mini_product_tile.dart';

/// BUNDLE: a "frequently bought together" row — the product-query contract
/// shared with CAROUSEL/GRID (typically `is_bundle_product: true`), rendered
/// as a horizontal strip of [MiniProductTile]s joined by "+" separators,
/// with a combined price and a single button that adds every item to the
/// cart at once.
class BundleWidget extends StatefulWidget {
  const BundleWidget({
    super.key,
    required this.params,
    required this.callbacks,
    this.theme = const EcommerceWidgetTheme(),
  });

  final Map<String, dynamic> params;
  final WidgetCallbacks callbacks;
  final EcommerceWidgetTheme theme;

  @override
  State<BundleWidget> createState() => _BundleWidgetState();
}

class _BundleWidgetState extends State<BundleWidget> {
  late final Future<List<ProductCardData>> _future =
      widget.callbacks.fetchProducts(ProductQuery.fromParams(widget.params));

  bool _adding = false;

  Future<void> _addAll(List<ProductCardData> products) async {
    final onAddToCart = widget.callbacks.onAddToCart;
    if (onAddToCart == null || _adding) return;
    setState(() => _adding = true);
    for (final product in products) {
      if (product.saleDisabled) continue;
      await onAddToCart(product, null, 1);
    }
    if (mounted) setState(() => _adding = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return FutureBuilder<List<ProductCardData>>(
      future: _future,
      builder: (context, snapshot) {
        final products = snapshot.data ?? const [];
        if (products.length < 2) return const SizedBox.shrink();

        final title = (widget.params['title'] as String?) ?? theme.bundleTitleLabel;
        final total = products.fold<num>(0, (sum, p) => sum + (p.price ?? 0));

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
                Text(title, style: theme.productTitleStyle.copyWith(fontSize: 15)),
                SizedBox(height: theme.spaceM),
                SizedBox(
                  height: 170,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (var i = 0; i < products.length; i++) ...[
                        if (i > 0)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(Icons.add, color: theme.textSecondaryColor, size: 18),
                          ),
                        SizedBox(
                          width: 100,
                          child: MiniProductTile(
                            data: products[i],
                            callbacks: widget.callbacks,
                            imageSize: 80,
                            theme: theme,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: theme.spaceM),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${total.toStringAsFixed(2)} ${_currencySymbol(products.first.currency)}',
                        style: theme.priceStyle,
                      ),
                    ),
                    if (widget.callbacks.onAddToCart != null)
                      ElevatedButton(
                        onPressed: _adding ? null : () => _addAll(products),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(theme.radiusS)),
                        ),
                        child: _adding
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : Text(theme.addAllToCartLabel, style: theme.buttonLabelStyle),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _currencySymbol(String currency) {
    switch (currency.toLowerCase()) {
      case 'usd':
        return '\$';
      case 'eur':
        return '€';
      case 'rub':
        return '₽';
      default:
        return '₺';
    }
  }
}
