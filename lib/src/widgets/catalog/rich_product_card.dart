import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/product_card_data.dart';
import '../../contracts/widget_action.dart';
import '../../core/theme/ecommerce_widget_theme.dart';
import '../badges/discount_badge.dart';
import '../buttons/add_to_cart_button.dart';
import '../buttons/favorite_button.dart';
import '../cart/quantity_picker.dart';
import 'catalog_network_image.dart';

/// The rich, variant-capable product card shared by CAROUSEL, PRODUCTCARD
/// and FLASHSALE's product grid (GRID uses its own fork, [OldProductCard]):
/// a bordered square image (with a variant photo slider + dot indicator when
/// the product has more than one variant), an animated favorite heart, a
/// discount badge, and a variant-count chip that opens a color/size +
/// quantity bottom sheet.
class RichProductCard extends StatefulWidget {
  const RichProductCard({
    super.key,
    required this.data,
    required this.callbacks,
    this.imageSize,
    this.theme = const EcommerceWidgetTheme(),
  });

  final ProductCardData data;
  final WidgetCallbacks callbacks;

  /// Fixed image/card width. When null, the card fills its parent (e.g. a
  /// grid cell).
  final double? imageSize;

  /// Colors, text styles and sizes used to render this card. Defaults to
  /// the package's built-in look.
  final EcommerceWidgetTheme theme;

  @override
  State<RichProductCard> createState() => _RichProductCardState();
}

class _RichProductCardState extends State<RichProductCard> {
  late ProductCardData _data = widget.data;
  int _currentVariantPage = 0;

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

  Future<void> _toggleFavorite() async {
    final toggle = widget.callbacks.onToggleFavorite;
    if (toggle == null) return;
    final newValue = await toggle(_data);
    if (mounted) setState(() => _data = _data.copyWith(isFavorited: newValue));
  }

  void _openVariantSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _VariantSheet(data: _data, callbacks: widget.callbacks, theme: widget.theme),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.callbacks
          .onAction(WidgetAction(type: WidgetActionType.product, id: _data.id)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double size = widget.imageSize ?? constraints.maxWidth;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildImageArea(size),
              const SizedBox(height: 8),
              _buildContent(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildImageArea(double size) {
    final theme = widget.theme;
    final images = _data.variants.isNotEmpty
        ? _data.variants.map((v) => v.image ?? _data.image).toList()
        : [_data.image];
    final hasMultiple = images.length > 1;

    return SizedBox(
      width: size,
      height: size,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(theme.radiusM),
          border: Border.all(color: theme.borderColor, width: 0.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(theme.radiusM - 0.5),
          child: Container(
            color: theme.surfaceColor,
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                hasMultiple
                    ? PageView.builder(
                        itemCount: images.length,
                        onPageChanged: (index) =>
                            setState(() => _currentVariantPage = index),
                        itemBuilder: (context, index) =>
                            CatalogNetworkImage(url: images[index]),
                      )
                    : CatalogNetworkImage(url: images.first),
                if (hasMultiple)
                  Positioned(
                    bottom: 8,
                    left: 0,
                    right: 0,
                    child: Center(child: _DotIndicator(count: images.length, activeIndex: _currentVariantPage)),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: FavoriteButton(
                    isFavorite: _data.isFavorited,
                    onChanged: (_) => _toggleFavorite(),
                    size: 32,
                    iconSize: 18,
                    activeColor: theme.favoriteActiveColor,
                    inactiveColor: theme.textSecondaryColor,
                    backgroundColor: theme.surfaceColor,
                  ),
                ),
                if (_data.hasDiscount || (_data.discount != null && _data.discount != '0'))
                  Positioned(
                    top: 0,
                    left: 0,
                    child: DiscountBadge(
                      percentage: int.tryParse(_data.discount ?? '') ?? 0,
                      backgroundColor: theme.discountColor,
                    ),
                  ),
                if (_data.variants.length > 1)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: GestureDetector(
                      onTap: _openVariantSheet,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: theme.surfaceColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 10,
                              width: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: const LinearGradient(
                                  colors: [Color(0xffe82121), Color(0xffeaed07), Color(0xFF58a6ee)],
                                  begin: Alignment.centerRight,
                                  end: Alignment.centerLeft,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${_data.variants.length}',
                              style: const TextStyle(color: Colors.grey, fontSize: 10.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final loggedIn = widget.callbacks.isLoggedIn?.call() ?? true;
    final theme = widget.theme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_data.subtitle != null && _data.subtitle!.isNotEmpty)
          Text(
            _data.subtitle!,
            style: theme.captionStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        const SizedBox(height: 2),
        Text(
          _data.title,
          style: theme.productTitleStyle.copyWith(fontSize: 13),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (_data.subtitle2 != null && _data.subtitle2!.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            _data.subtitle2!,
            style: theme.captionStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const SizedBox(height: 4),
        _buildPriceRow(loggedIn),
      ],
    );
  }

  Widget _buildPriceRow(bool loggedIn) {
    final theme = widget.theme;
    if (!loggedIn) {
      return SizedBox(
        height: 28,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: widget.callbacks.onRequireAuth,
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

    if (_data.price == null || _data.price == 0) {
      if (_data.priceText != null && _data.priceText!.isNotEmpty) {
        return Text(_data.priceText!, style: theme.priceStyle.copyWith(fontSize: 13));
      }
      return const SizedBox.shrink();
    }

    final symbol = _currencySymbol(_data.currency);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_data.hasDiscount) ...[
          Text(
            '${_data.priceOld!.toStringAsFixed(2)} $symbol',
            style: theme.originalPriceStyle.copyWith(fontSize: 11),
          ),
          const SizedBox(width: 5),
        ],
        Text(
          '${_data.price!.toStringAsFixed(2)} $symbol',
          style: theme.priceStyle.copyWith(
            fontSize: 14,
            color: _data.hasDiscount ? theme.discountColor : theme.textPrimaryColor,
          ),
        ),
      ],
    );
  }
}

class _DotIndicator extends StatelessWidget {
  const _DotIndicator({required this.count, required this.activeIndex});

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(count, (i) {
          final active = i == activeIndex;
          return Container(
            width: 5,
            height: 5,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? Colors.black : Colors.grey,
            ),
          );
        }),
      ),
    );
  }
}

class _VariantSheet extends StatefulWidget {
  const _VariantSheet({required this.data, required this.callbacks, required this.theme});

  final ProductCardData data;
  final WidgetCallbacks callbacks;
  final EcommerceWidgetTheme theme;

  @override
  State<_VariantSheet> createState() => _VariantSheetState();
}

class _VariantSheetState extends State<_VariantSheet> {
  late int _selectedVariant = 0;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final variants = data.variants;
    final theme = widget.theme;

    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: theme.surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration:
                    BoxDecoration(color: theme.textSecondaryColor, borderRadius: BorderRadius.circular(20)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Text(
                          '${variants.length} ${theme.variantColorLabel}',
                          style: TextStyle(fontWeight: FontWeight.bold, color: theme.textSecondaryColor),
                        ),
                      ],
                    ),
                  ),
                  Semantics(
                    button: true,
                    label: 'Close',
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.close, size: 23, color: theme.textSecondaryColor),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: variants.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedVariant = index),
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: _selectedVariant == index
                                ? Border.all(color: theme.primaryColor, width: 1.5)
                                : Border.all(color: theme.borderColor),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: CatalogNetworkImage(url: variants[index].image ?? data.image),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          variants[index].name,
                          style: TextStyle(
                            fontSize: 11,
                            color: _selectedVariant == index ? theme.textPrimaryColor : theme.textSecondaryColor,
                            fontWeight: _selectedVariant == index ? FontWeight.w500 : FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (data.saleDisabled)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  data.saleDisabledReason ?? theme.notAvailableForSaleLabel,
                  style: TextStyle(color: theme.textSecondaryColor, fontSize: 13),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    QuantityPicker(
                      quantity: _quantity,
                      onChanged: (value) => setState(() => _quantity = value),
                      buttonSize: 38,
                      borderColor: theme.borderColor,
                      iconColor: theme.textPrimaryColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AddToCartButton(
                        label: theme.addToCartLabel,
                        icon: null,
                        backgroundColor: theme.primaryColor,
                        textStyle: theme.buttonLabelStyle,
                        onPressed: () {
                          widget.callbacks.onAddToCart?.call(
                            data,
                            variants.isNotEmpty ? variants[_selectedVariant] : null,
                            _quantity,
                          );
                          Navigator.pop(context);
                        },
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
