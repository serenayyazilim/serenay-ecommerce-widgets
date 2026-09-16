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

const _kItemWidth = 160.0;
const _kItemSpacing = 12.0;

class _CarouselWidgetState extends State<CarouselWidget> {
  late final Future<List<ProductCardData>> _future =
      widget.callbacks.fetchProducts(ProductQuery.fromParams(widget.params));
  final _scrollController = ScrollController();
  int _itemCount = 0;
  late final _autoplay = AutoplayController(
    canAdvance: () => _scrollController.hasClients && _itemCount >= 2,
    advance: () {
      const step = _kItemWidth + _kItemSpacing;
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

        return SizedBox(
          height: 260,
          child: NotificationListener<ScrollNotification>(
            onNotification: _autoplay.handleScrollNotification,
            child: ListView.separated(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: products.length,
              separatorBuilder: (context, index) => const SizedBox(width: _kItemSpacing),
              itemBuilder: (context, index) {
                final builder = widget.callbacks.productCardBuilder;
                return SizedBox(
                  width: _kItemWidth,
                  child: builder != null
                      ? builder(products[index])
                      : RichProductCard(
                          data: products[index],
                          callbacks: widget.callbacks,
                          imageSize: _kItemWidth,
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
