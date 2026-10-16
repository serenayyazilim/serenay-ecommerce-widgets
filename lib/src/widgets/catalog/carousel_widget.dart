import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/product_card_data.dart';
import '../../contracts/product_query.dart';
import '../../core/theme/ecommerce_widget_theme.dart';
import '../../core/utils/autoplay_controller.dart';
import '../../core/utils/param_parsing.dart';
import 'rich_product_card.dart';

/// CAROUSEL: a horizontally-scrolling row of the shared rich product card,
/// backed by the shared product-query contract (§1.4 of the widget catalog
/// doc).
class CarouselWidget extends StatefulWidget {
  const CarouselWidget({
    super.key,
    required this.params,
    required this.callbacks,
    this.theme = const EcommerceWidgetTheme(),
  });

  final Map<String, dynamic> params;
  final WidgetCallbacks callbacks;
  final EcommerceWidgetTheme theme;

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  late final Future<List<ProductCardData>> _future =
      widget.callbacks.fetchProducts(ProductQuery.fromParams(widget.params));
  final _scrollController = ScrollController();
  int _itemCount = 0;

  double get _itemWidth => parseDouble(widget.params['item_width']) ?? 160;
  double get _itemSpacing => parseDouble(widget.params['item_spacing']) ?? 12;
  late final _autoplay = AutoplayController(
    canAdvance: () => _scrollController.hasClients && _itemCount >= 2,
    advance: () {
      final step = _itemWidth + _itemSpacing;
      final maxExtent = _scrollController.position.maxScrollExtent;
      final next = _scrollController.offset + step;
      _scrollController.animateTo(
        next > maxExtent ? 0 : next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    },
    interval: Duration(seconds: parseInt(widget.params['autoplay_interval']) ?? 5),
  );

  @override
  void initState() {
    super.initState();
    _future.then((products) {
      if (!mounted) return;
      _itemCount = products.length;
      if (parseBool(widget.params['autoplay']) ?? false) _autoplay.start();
    }, onError: (_) {});
  }

  @override
  void dispose() {
    _autoplay.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductCardData>>(
      future: _future,
      builder: (context, snapshot) {
        final products = snapshot.data ?? const [];
        if (products.isEmpty) return const SizedBox.shrink();

        final itemWidth = _itemWidth;
        final paddingV = parseDouble(widget.params['padding_vertical']) ?? 0;

        return Container(
          height: (parseDouble(widget.params['height']) ?? 260) + 2 * paddingV,
          color: parseColor(widget.params['bg_color']),
          padding: EdgeInsets.symmetric(vertical: paddingV),
          child: NotificationListener<ScrollNotification>(
            onNotification: _autoplay.handleScrollNotification,
            child: ListView.separated(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                horizontal: parseDouble(widget.params['padding_horizontal']) ?? 16,
              ),
              itemCount: products.length,
              separatorBuilder: (context, index) => SizedBox(width: _itemSpacing),
              itemBuilder: (context, index) {
                final builder = widget.callbacks.productCardBuilder;
                return SizedBox(
                  width: itemWidth,
                  child: builder != null
                      ? builder(products[index])
                      : RichProductCard(
                          data: products[index],
                          callbacks: widget.callbacks,
                          imageSize: itemWidth,
                          theme: widget.theme,
                        ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
