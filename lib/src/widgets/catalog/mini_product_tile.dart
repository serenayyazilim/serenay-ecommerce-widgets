import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/product_card_data.dart';
import '../../contracts/widget_action.dart';
import '../../core/constants/app_colors.dart';
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
  });

  final ProductCardData data;
  final WidgetCallbacks callbacks;
  final double? imageSize;

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
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: const BorderSide(color: Colors.grey, width: 0.3),
            ),
          ),
          child: const Text(
            'View Prices',
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 11),
          ),
        ),
      );
    }

    final price = data.price ?? 0;
    final oldPrice = data.priceOld ?? 0;
    final symbol = _currencySymbol(data.currency);
    final hasDiscount = oldPrice > 0 && oldPrice != price;

    if (price > 0) {
      return Row(
        children: [
          if (hasDiscount) ...[
            Text(
              '${oldPrice.toStringAsFixed(2)} $symbol',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500, decoration: TextDecoration.lineThrough),
            ),
            const SizedBox(width: 5),
          ],
          Text(
            '${price.toStringAsFixed(2)} $symbol',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: hasDiscount ? Colors.red : Colors.black),
          ),
        ],
      );
    }
    if (data.priceText != null && data.priceText!.isNotEmpty) {
      return Text(data.priceText!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold));
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => callbacks.onAction(WidgetAction(type: WidgetActionType.product, id: data.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CatalogNetworkImage(url: data.image, width: imageSize, height: imageSize),
          ),
          const SizedBox(height: 6),
          if (data.title.isNotEmpty) ...[
            Text(
              data.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey.shade800),
            ),
            const SizedBox(height: 4),
          ],
          _buildPrice(context),
        ],
      ),
    );
  }
}
