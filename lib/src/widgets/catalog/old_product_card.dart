import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/product_card_data.dart';
import '../../contracts/widget_action.dart';
import '../../core/theme/ecommerce_widget_theme.dart';
import '../buttons/add_to_cart_button.dart';
import '../buttons/favorite_button.dart';
import '../cart/quantity_picker.dart';
import 'catalog_network_image.dart';

/// GRID's product card. Forked from [RichProductCard] (used by CAROUSEL,
/// PRODUCTCARD and FLASHSALE) and ported from the original app's full
/// `SerProductCard` design so GRID can evolve independently. Differences
/// from the shared card: the whole card (not just the image) sits in one
/// bordered box, the image area is taller than it is wide and plays inline
/// video for `.mp4` variant URLs, the discount badge is a left-edge ribbon,
/// a pre-order banner replaces the price row when
/// [ProductCardData.preOrder] is set, and a measure/quantity picker (for
/// size/package tiers, distinct from the color [ProductVariant] sheet) is
/// available when [ProductCardData.measureOptions] is non-empty.
///
/// Not ported: the source app's per-index "private product" blur+login
/// overlay (a guest-conversion trick tied to that app's config, not a
/// generic catalog concept) and its hierarchical variant-color-group fetch
/// (would need a new nested contract beyond the flat [ProductVariant]
/// list this package already exposes elsewhere).
class OldProductCard extends StatefulWidget {
  const OldProductCard({
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
  State<OldProductCard> createState() => _OldProductCardState();
}

class _OldProductCardState extends State<OldProductCard> {
  late ProductCardData _data = widget.data;
  int _currentVariantPage = 0;

  bool _isVideo(String url) => url.toLowerCase().endsWith('.mp4');

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

  void _quickAddMeasure() {
    widget.callbacks.onAddToCart?.call(_data, null, 1);
  }

  void _openMeasureSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _MeasureSheet(data: _data, callbacks: widget.callbacks, theme: widget.theme),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;

    return GestureDetector(
      onTap: () => widget.callbacks
          .onAction(WidgetAction(type: WidgetActionType.product, id: _data.id)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double size = widget.imageSize ?? constraints.maxWidth;
          return Container(
            width: size,
            decoration: BoxDecoration(
              color: theme.surfaceColor,
              borderRadius: BorderRadius.circular(theme.radiusM),
              border: Border.all(color: theme.borderColor, width: 0.5),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildImageArea(size - 16),
                const SizedBox(height: 8),
                _buildContent(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageArea(double width) {
    final theme = widget.theme;
    final images = _data.variants.isNotEmpty
        ? _data.variants.map((v) => v.image ?? _data.image).toList()
        : [_data.image];
    final hasMultiple = images.length > 1;
    // Taller than wide (vs. the square image RichProductCard uses) — the
    // visible "longer" look GRID's original design had.
    final height = width * 1.35;

    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(theme.radiusS),
        child: Container(
          color: Colors.white,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              hasMultiple
                  ? PageView.builder(
                      itemCount: images.length,
                      onPageChanged: (index) => setState(() => _currentVariantPage = index),
                      itemBuilder: (context, index) => _isVideo(images[index])
                          ? _MutedLoopVideo(url: images[index])
                          : CatalogNetworkImage(url: images[index]),
                    )
                  : (_isVideo(images.first)
                      ? _MutedLoopVideo(url: images.first)
                      : CatalogNetworkImage(url: images.first)),
              if (hasMultiple)
                Positioned(
                  bottom: 8,
                  left: 0,
                  right: 0,
                  child: Center(child: _DotIndicator(count: images.length, activeIndex: _currentVariantPage)),
                ),
              Positioned(
                top: 6,
                right: 6,
                child: FavoriteButton(
                  isFavorite: _data.isFavorited,
                  onChanged: (_) => _toggleFavorite(),
                  size: 30,
                  iconSize: 16,
                  activeColor: theme.favoriteActiveColor,
                  inactiveColor: theme.textSecondaryColor,
                  backgroundColor: theme.surfaceColor,
                ),
              ),
              if (_data.hasDiscount || (_data.discount != null && _data.discount != '0'))
                Positioned(
                  top: 20,
                  left: 0,
                  child: _DiscountRibbon(
                    percentage: int.tryParse(_data.discount ?? '') ?? 0,
                    color: theme.discountColor,
                  ),
                ),
              if (_data.variants.length > 1)
                Positioned(
                  bottom: 8,
                  right: 8,
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
              if (_data.preOrder)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: double.infinity,
                    color: theme.textPrimaryColor.withValues(alpha: 0.85),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      theme.preOrderLabel,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
            ],
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
            '#${_data.subtitle}',
            style: TextStyle(
              color: _data.hasDiscount ? theme.discountColor : theme.textSecondaryColor,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        const SizedBox(height: 3),
        Text(
          _data.title,
          style: theme.productTitleStyle.copyWith(fontSize: 11, fontWeight: FontWeight.w300),
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
        _buildPriceStatus(loggedIn),
        if (_data.measureOptions.isNotEmpty && !_data.saleDisabled && loggedIn) ...[
          const SizedBox(height: 6),
          _buildMeasureQuickAdd(),
        ],
      ],
    );
  }

  Widget _buildMeasureQuickAdd() {
    final theme = widget.theme;
    return Row(
      children: [
        GestureDetector(
          onTap: _quickAddMeasure,
          child: Container(
            height: 25,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(theme.radiusS),
            ),
            child: Center(
              child: Text(
                '+1',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: theme.primaryColor),
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: _openMeasureSheet,
          child: Container(
            height: 25,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(theme.radiusS),
            ),
            child: Center(
              child: Text(
                theme.quickAddLabel,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: theme.primaryColor),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceStatus(bool loggedIn) {
    final theme = widget.theme;
    if (!loggedIn) {
      return SizedBox(
        height: 26,
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

    if (_data.unitPriceText != null && _data.unitPriceText!.isNotEmpty) {
      return Text(
        _data.unitPriceText!,
        style: theme.priceStyle.copyWith(fontSize: 15, color: theme.textPrimaryColor),
      );
    }

    if (_data.qtyInPackage != null && _data.qtyInPackage! > 1 && _data.priceText != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${_data.qtyInPackage}× ', style: theme.captionStyle),
          Text(_data.priceText!, style: theme.priceStyle.copyWith(fontSize: 14)),
        ],
      );
    }

    if (_data.price == null || _data.price == 0) {
      if (_data.priceText != null && _data.priceText!.isNotEmpty) {
        return Text(_data.priceText!, style: theme.priceStyle.copyWith(fontSize: 14));
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
            style: theme.originalPriceStyle.copyWith(fontSize: 12),
          ),
          const SizedBox(width: 5),
        ],
        Text(
          '${_data.price!.toStringAsFixed(2)} $symbol',
          style: theme.priceStyle.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _data.hasDiscount ? theme.discountColor : theme.textPrimaryColor,
          ),
        ),
      ],
    );
  }
}

/// Left-edge ribbon-style discount badge (vs. the corner-tag [DiscountBadge]
/// the shared card uses).
class _DiscountRibbon extends StatelessWidget {
  const _DiscountRibbon({required this.percentage, required this.color});

  final int percentage;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(6),
          bottomRight: Radius.circular(6),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.sell, size: 10, color: Colors.white),
          const SizedBox(width: 3),
          Text(
            '%$percentage',
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ],
      ),
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

/// A silent, looping, autoplaying inline video preview — used for variant
/// image URLs that are actually `.mp4` clips.
class _MutedLoopVideo extends StatefulWidget {
  const _MutedLoopVideo({required this.url});

  final String url;

  @override
  State<_MutedLoopVideo> createState() => _MutedLoopVideoState();
}

class _MutedLoopVideoState extends State<_MutedLoopVideo> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    final controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _controller = controller;
    controller.initialize().then((_) {
      if (!mounted) return;
      controller
        ..setLooping(true)
        ..setVolume(0)
        ..play();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return const ColoredBox(color: Colors.black12);
    }
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: controller.value.size.width,
        height: controller.value.size.height,
        child: VideoPlayer(controller),
      ),
    );
  }
}

/// Color/style variant picker + quantity + add-to-cart, identical to the
/// shared card's variant sheet.
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
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close, size: 23, color: theme.textSecondaryColor),
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

/// Measure/size/package-tier picker + quantity + add-to-cart — distinct
/// from [_VariantSheet] (which picks a color/style), ported from the
/// source app's separate "measure modal". Since [WidgetCallbacks.onAddToCart]
/// only carries a [ProductVariant], the chosen measure is not forwarded
/// through it; host apps that need it should encode the choice into the
/// product itself (e.g. `fetchProducts` returning one entry per measure).
class _MeasureSheet extends StatefulWidget {
  const _MeasureSheet({required this.data, required this.callbacks, required this.theme});

  final ProductCardData data;
  final WidgetCallbacks callbacks;
  final EcommerceWidgetTheme theme;

  @override
  State<_MeasureSheet> createState() => _MeasureSheetState();
}

class _MeasureSheetState extends State<_MeasureSheet> {
  late int _selectedMeasure = 0;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final options = data.measureOptions;
    final theme = widget.theme;

    return Container(
      height: 260,
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
                  Text(
                    data.measureName ?? theme.quickAddLabel,
                    style: TextStyle(fontWeight: FontWeight.bold, color: theme.textSecondaryColor),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close, size: 23, color: theme.textSecondaryColor),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options[index];
                  final selected = _selectedMeasure == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: () => setState(() => _selectedMeasure = index),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(theme.radiusS),
                          border: Border.all(color: selected ? theme.primaryColor : theme.borderColor),
                          color: selected ? theme.primaryColor : theme.surfaceColor,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              option.title,
                              style: TextStyle(
                                fontSize: 13,
                                color: selected ? Colors.white : theme.textPrimaryColor,
                                fontWeight: selected ? FontWeight.w500 : FontWeight.w300,
                              ),
                            ),
                            if (option.priceText != null)
                              Text(
                                option.priceText!,
                                style: TextStyle(
                                  fontSize: 10.5,
                                  color: selected ? Colors.white70 : theme.textSecondaryColor,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
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
                          widget.callbacks.onAddToCart?.call(data, null, _quantity);
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
