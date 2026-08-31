import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/product_card_data.dart';
import '../../contracts/widget_action.dart';
import '../../core/theme/ecommerce_widget_theme.dart';
import 'catalog_network_image.dart';

/// A plain image/title/price tile with no favorite heart or variant picker —
/// used by MIXEDCAROUSEL's mini 2x2 product grid, which only needs to show
/// a photo and a price at a glance.
class MiniProductTile extends StatelessWidget {
  const MiniProductTile({
    super.key,
    required this.data,
    required this.callbacks,
    this.imageSize,
    this.theme = const EcommerceWidgetTheme(),
  });

  final ProductCardData data;
  final WidgetCallbacks callbacks;
  final double? imageSize;
  final EcommerceWidgetTheme theme;

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

  String _formatPrice(num amount, String currency) {
    final formatPrice = callbacks.formatPrice;
    if (formatPrice != null) return formatPrice(amount, currency);
    return '${amount.toStringAsFixed(2)} ${_currencySymbol(currency)}';
  }

  Widget _buildPrice(BuildContext context) {
    final loggedIn = callbacks.isLoggedIn?.call() ?? true;
    if (!loggedIn) {
      return SizedBox(
        height: 28,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: callbacks.onRequireAuth,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: EdgeInsets.zero,
            backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(theme.radiusS),
              side: BorderSide(color: theme.borderColor, width: 0.3),
            ),
          ),
          child: Text(
            theme.viewPricesLabel,
            style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.w600, fontSize: 11),
          ),
        ),
      );
    }

    final price = data.price ?? 0;
    final oldPrice = data.priceOld ?? 0;
    final hasDiscount = oldPrice > 0 && oldPrice != price;

    if (price > 0) {
      // A Wrap (not a Row) so a narrow host — e.g. BUNDLE's multi-item
      // strip — drops the old-price text to its own line instead of
      // overflowing when both prices don't fit on one.
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 5,
        children: [
          if (hasDiscount)
            Text(
              _formatPrice(oldPrice, data.currency),
              style: theme.originalPriceStyle.copyWith(fontSize: 11),
            ),
          Text(
            _formatPrice(price, data.currency),
            style: theme.priceStyle.copyWith(
              fontSize: 14,
              color: hasDiscount ? theme.discountColor : theme.textPrimaryColor,
            ),
          ),
        ],
      );
    }
    if (data.priceText != null && data.priceText!.isNotEmpty) {
      return Text(data.priceText!, style: theme.priceStyle.copyWith(fontSize: 13));
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => callbacks.onAction(WidgetAction(type: WidgetActionType.product, id: data.id)),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.surfaceColor,
          borderRadius: BorderRadius.circular(theme.radiusM),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(theme.radiusM),
              child: CatalogNetworkImage(
                url: data.image,
                width: imageSize,
                height: imageSize,
                errorBuilder: callbacks.imageErrorBuilder,
              ),
            ),
            const SizedBox(height: 6),
            if (data.title.isNotEmpty) ...[
              Text(
                data.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.productTitleStyle.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 4),
            ],
            _buildPrice(context),
          ],
        ),
      ),
    );
  }
}
