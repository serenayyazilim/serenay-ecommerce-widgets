import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/product_card_data.dart';
import '../../contracts/product_query.dart';
import '../../contracts/widget_action.dart';
import '../../core/theme/ecommerce_widget_theme.dart';
import 'catalog_network_image.dart';

/// COMPARISON: fetches products through the shared product-query contract
/// (like CAROUSEL/GRID) and lays the first few out side by side in a spec
/// table — image, title, price and subtitle rows — so a shopper can compare
/// them at a glance instead of tapping in and out of each product.
class ComparisonWidget extends StatefulWidget {
  const ComparisonWidget({
    super.key,
    required this.params,
    required this.callbacks,
    this.theme = const EcommerceWidgetTheme(),
  });

  final Map<String, dynamic> params;
  final WidgetCallbacks callbacks;
  final EcommerceWidgetTheme theme;

  @override
  State<ComparisonWidget> createState() => _ComparisonWidgetState();
}

class _ComparisonWidgetState extends State<ComparisonWidget> {
  late final Future<List<ProductCardData>> _future =
      widget.callbacks.fetchProducts(ProductQuery.fromParams(widget.params));

  static const int _maxColumns = 3;

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

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return FutureBuilder<List<ProductCardData>>(
      future: _future,
      builder: (context, snapshot) {
        final products = (snapshot.data ?? const []).take(_maxColumns).toList();
        if (products.length < 2) return const SizedBox.shrink();

        const columnWidth = 140.0;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: theme.spaceM, vertical: theme.spaceS),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < products.length; i++) ...[
                  if (i > 0) VerticalDivider(width: theme.spaceM, color: theme.borderColor),
                  SizedBox(
                    width: columnWidth,
                    child: _ComparisonColumn(
                      data: products[i],
                      callbacks: widget.callbacks,
                      theme: theme,
                      currencySymbol: _currencySymbol(products[i].currency),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ComparisonColumn extends StatelessWidget {
  const _ComparisonColumn({
    required this.data,
    required this.callbacks,
    required this.theme,
    required this.currencySymbol,
  });

  final ProductCardData data;
  final WidgetCallbacks callbacks;
  final EcommerceWidgetTheme theme;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => callbacks.onAction(WidgetAction(type: WidgetActionType.product, id: data.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(theme.radiusM),
            child: CatalogNetworkImage(
              url: data.image,
              height: 120,
              width: double.infinity,
              errorBuilder: callbacks.imageErrorBuilder,
            ),
          ),
          SizedBox(height: theme.spaceXs),
          Text(
            data.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.productTitleStyle.copyWith(fontSize: 12),
          ),
          if (data.subtitle != null) ...[
            SizedBox(height: theme.spaceXs),
            Text(
              data.subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.captionStyle,
            ),
          ],
          SizedBox(height: theme.spaceXs),
          if (data.price != null)
            Text(
              '${data.price!.toStringAsFixed(2)} $currencySymbol',
              style: theme.priceStyle.copyWith(
                fontSize: 14,
                color: data.hasDiscount ? theme.discountColor : theme.textPrimaryColor,
              ),
            ),
        ],
      ),
    );
  }
}
