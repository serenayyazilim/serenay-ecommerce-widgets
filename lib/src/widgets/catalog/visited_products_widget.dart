import 'package:flutter/material.dart';

import '../../callbacks/ser_builder_callbacks.dart';
import '../../contracts/product_card_data.dart';
import '../../contracts/ser_action.dart';
import '../../core/constants/app_colors.dart';
import '../badges/discount_badge.dart';
import 'ser_network_image.dart';

/// VISITEDPRODUCTS: the locally-tracked "recently visited" list — never
/// fetched from the backend. Shows a history-icon header, then a row of
/// simple cards (image + discount badge, subtitle, title, price — no
/// favorite heart or variant picker).
class SerVisitedProductsWidget extends StatelessWidget {
  const SerVisitedProductsWidget({
    super.key,
    required this.params,
    required this.callbacks,
  });

  final Map<String, dynamic> params;
  final SerBuilderCallbacks callbacks;

  @override
  Widget build(BuildContext context) {
    final limit = (params['limit'] as num?)?.toInt() ?? 10;
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
                const Icon(Icons.history, size: 18, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  'Recently Viewed',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
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
                child: _VisitedProductCard(data: products[index], callbacks: callbacks),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VisitedProductCard extends StatelessWidget {
  const _VisitedProductCard({required this.data, required this.callbacks});

  final ProductCardData data;
  final SerBuilderCallbacks callbacks;

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
      onTap: () => callbacks.onAction(SerAction(type: SerActionType.product, id: data.id)),
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
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300, width: 0.5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(11.5),
                      child: Container(
                        color: const Color(0xFFF5F5F5),
                        child: SerNetworkImage(url: data.image),
                      ),
                    ),
                  ),
                  if (hasDiscount)
                    Positioned(
                      top: 0,
                      left: 0,
                      child: DiscountBadge(percentage: int.tryParse(data.discount ?? '') ?? 0),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            if (data.subtitle != null && data.subtitle!.isNotEmpty)
              Text(
                data.subtitle!,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 2),
            Text(
              data.title,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade800),
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
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade500, decoration: TextDecoration.lineThrough),
                    ),
                    const SizedBox(width: 4),
                  ],
                  Flexible(
                    child: Text(
                      '${price.toStringAsFixed(2)} $symbol',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: hasDiscount ? Colors.red : AppColors.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            else if (data.priceText != null && data.priceText!.isNotEmpty)
              Text(
                data.priceText!,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }
}
