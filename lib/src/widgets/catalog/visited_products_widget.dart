import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/product_card_data.dart';
import '../../contracts/widget_action.dart';
import '../../core/theme/ecommerce_widget_theme.dart';
import '../../core/utils/param_parsing.dart';
import '../badges/discount_badge.dart';
import 'catalog_network_image.dart';

/// VISITEDPRODUCTS: the locally-tracked "recently visited" list — never
/// fetched from the backend. Shows a history-icon header, then a row of
/// simple cards (image + discount badge, subtitle, title, price — no
/// favorite heart or variant picker).
class VisitedProductsWidget extends StatelessWidget {
  const VisitedProductsWidget({
    super.key,
    required this.params,
    required this.callbacks,
    this.theme = const EcommerceWidgetTheme(),
  });

  final Map<String, dynamic> params;
  final WidgetCallbacks callbacks;
  final EcommerceWidgetTheme theme;

  @override
  Widget build(BuildContext context) {
    final limit = parseInt(params['limit']) ?? 10;
    final products = (callbacks.visitedProducts?.call() ?? const []).take(limit).toList();
    if (products.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
            child: Row(
              children: [
                Icon(Icons.history, size: 18, color: theme.primaryColor),
                const SizedBox(width: 6),
                Text(
                  'Recently Viewed',
                  style: theme.productTitleStyle.copyWith(fontSize: 15),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 210,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: products.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _VisitedProductCard(data: products[index], callbacks: callbacks, theme: theme),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VisitedProductCard extends StatelessWidget {
  const _VisitedProductCard({required this.data, required this.callbacks, required this.theme});

  final ProductCardData data;
  final WidgetCallbacks callbacks;
  final EcommerceWidgetTheme theme;

  static const double _cardWidth = 128;
  static const double _imageSize = 128;

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
    final price = data.price ?? 0;
    final oldPrice = data.priceOld ?? 0;
    final hasDiscount = oldPrice > 0 && oldPrice != price;
    final symbol = _currencySymbol(data.currency);

    return GestureDetector(
      onTap: () => callbacks.onAction(WidgetAction(type: WidgetActionType.product, id: data.id)),
      child: SizedBox(
        width: _cardWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: _imageSize,
              height: _imageSize,
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  Container(
                    width: _imageSize,
                    height: _imageSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(theme.radiusM),
                      border: Border.all(color: theme.borderColor, width: 0.5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(theme.radiusM - 0.5),
                      child: Container(
                        color: theme.surfaceColor,
                        child: CatalogNetworkImage(url: data.image),
                      ),
                    ),
                  ),
                  if (hasDiscount)
                    Positioned(
                      top: 0,
                      left: 0,
                      child: DiscountBadge(
                        percentage: int.tryParse(data.discount ?? '') ?? 0,
                        backgroundColor: theme.discountColor,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            if (data.subtitle != null && data.subtitle!.isNotEmpty)
              Text(
                data.subtitle!,
                style: theme.captionStyle.copyWith(fontSize: 10),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 2),
            Text(
              data.title,
              style: theme.productTitleStyle.copyWith(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),
            if (price > 0)
              Row(
                children: [
                  if (hasDiscount) ...[
                    Text(
                      '${oldPrice.toStringAsFixed(2)} $symbol',
                      style: theme.originalPriceStyle.copyWith(fontSize: 10),
                    ),
                    const SizedBox(width: 4),
                  ],
                  Flexible(
                    child: Text(
                      '${price.toStringAsFixed(2)} $symbol',
                      style: theme.priceStyle.copyWith(
                        fontSize: 13,
                        color: hasDiscount ? theme.discountColor : theme.primaryColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            else if (data.priceText != null && data.priceText!.isNotEmpty)
              Text(
                data.priceText!,
                style: theme.priceStyle.copyWith(fontSize: 12, color: theme.primaryColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }
}
