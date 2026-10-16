import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/product_card_data.dart';
import '../../contracts/product_query.dart';
import '../../contracts/widget_action.dart';
import '../../core/theme/ecommerce_widget_theme.dart';
import '../../core/utils/autoplay_controller.dart';
import '../../core/utils/param_parsing.dart';
import 'mini_product_tile.dart';
import 'catalog_network_image.dart';

/// MIXEDCAROUSEL: an auto-playing (until the user drags) carousel whose
/// pages are either a 2x2 mini product grid (`item_type: "products"`) or a
/// full-page image (`item_type: "image"`), each with its own background
/// color/title/description.
class MixedCarouselWidget extends StatefulWidget {
  const MixedCarouselWidget({
    super.key,
    required this.params,
    required this.callbacks,
    this.theme = const EcommerceWidgetTheme(),
  });

  final Map<String, dynamic> params;
  final WidgetCallbacks callbacks;
  final EcommerceWidgetTheme theme;

  @override
  State<MixedCarouselWidget> createState() => _MixedCarouselWidgetState();
}

class _MixedCarouselWidgetState extends State<MixedCarouselWidget> {
  late final double _viewportFraction = () {
    final value = parseDouble(widget.params['viewport_fraction']) ?? 0.8;
    return value > 0 && value <= 1 ? value : 0.8;
  }();
  late final _pageController = PageController(viewportFraction: _viewportFraction);
  double _p(String key, double fallback) => parseDouble(widget.params[key]) ?? fallback;

  late final _autoplay = AutoplayController(
    canAdvance: () => _pageController.hasClients && _items.length >= 2,
    advance: () {
      final next = ((_pageController.page ?? 0).round() + 1) % _items.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    },
    interval: Duration(seconds: parseInt(widget.params['autoplay_interval']) ?? 5),
  );

  List<Map<String, dynamic>> get _items => ((widget.params['items'] as List?) ?? const [])
      .whereType<Map>()
      .map((e) => Map<String, dynamic>.from(e))
      .toList();

  @override
  void initState() {
    super.initState();
    if (parseBool(widget.params['autoplay']) ?? true) _autoplay.start();
  }

  @override
  void dispose() {
    _autoplay.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Color _bgColor(dynamic hex) => parseColor(hex, fallback: Colors.white)!;

  @override
  Widget build(BuildContext context) {
    final items = _items;
    if (items.isEmpty) return const SizedBox.shrink();

    final heightPercent = parseDouble(widget.params['height_percent']) ?? 1.1;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final requiredHeight = items
            .map((item) => _requiredPageHeight(item, width))
            .fold(0.0, math.max);
        return SizedBox(
          height: math.max(width * heightPercent, requiredHeight),
          child: NotificationListener<ScrollNotification>(
            onNotification: _autoplay.handleScrollNotification,
            child: PageView.builder(
              controller: _pageController,
              padEnds: false,
              itemCount: items.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(horizontal: _p('page_spacing', 6)),
                child: _buildPage(items[index]),
              ),
            ),
          ),
        );
      },
    );
  }

  /// The height a single carousel page needs to render [item] without its
  /// content overflowing, given the widget's total [width]. Only
  /// `item_type: "products"` pages have a real minimum (the 2x2 mini grid);
  /// image pages just fill whatever space they're given.
  double _requiredPageHeight(Map<String, dynamic> item, double width) {
    final pageViewportFraction = _viewportFraction;
    final pagePadding = _p('page_spacing', 6); // horizontal padding around each PageView page
    final containerPadding = _p('inner_padding', 14); // _buildPage's Container padding
    final titleSize = _p('title_size', 19);
    final descriptionSize = _p('description_size', 13);
    const gridSpacing = 8.0;
    const cardPadding = 8.0;
    // Non-image chrome per mini tile: padding + spacing + title line + spacing + price line.
    const tileChromeHeight = cardPadding * 2 + 6 + 18 + 4 + 20;

    final hasTitle = (item['title']?.toString())?.isNotEmpty ?? false;
    final hasDescription = (item['description']?.toString())?.isNotEmpty ?? false;
    var headerHeight = 0.0;
    if (hasTitle || hasDescription) {
      // One title line is ~22px at the default 19px font; two description lines ~35px at 13px.
      final titleLine = titleSize * 22 / 19;
      headerHeight += hasTitle ? (hasDescription ? titleLine : titleLine * 2) : 0.0;
      headerHeight += hasDescription ? descriptionSize * 35 / 13 : 0.0;
      headerHeight += 10.0;
    }

    var gridHeight = 0.0;
    if (item['item_type'] != 'image') {
      final pageWidth = width * pageViewportFraction - pagePadding * 2;
      final gridWidth = pageWidth - containerPadding * 2;
      final tileWidth = (gridWidth - gridSpacing) / 2;
      final imageSize = tileWidth - cardPadding * 2;
      gridHeight = 2 * (imageSize + tileChromeHeight) + gridSpacing;
    }

    return containerPadding * 2 + headerHeight + gridHeight;
  }

  Widget _buildPage(Map<String, dynamic> item) {
    final itemType = item['item_type']?.toString();
    final bgColor = _bgColor(item['bg_color']);
    final title = item['title']?.toString();
    final titleColor = _bgColor(item['title_color']);
    final description = item['description']?.toString();
    final descriptionColor = _bgColor(item['description_color']);

    return Container(
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(_p('radius', 16))),
      padding: EdgeInsets.all(_p('inner_padding', 14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              title,
              maxLines: description != null ? 1 : 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: titleColor,
                fontWeight: FontWeight.bold,
                fontSize: _p('title_size', 19),
                height: 1.15,
              ),
            ),
          if (description != null) ...[
            const SizedBox(height: 4),
            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: descriptionColor, fontSize: _p('description_size', 13)),
            ),
          ],
          if (title != null || description != null) const SizedBox(height: 10),
          Expanded(
            child: itemType == 'image'
                ? _buildImagePage(item)
                : _MiniProductGrid(params: item, callbacks: widget.callbacks, theme: widget.theme),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePage(Map<String, dynamic> item) {
    final url = item['url']?.toString() ?? '';
    final fit = parseBoxFit(item['fit']);
    final action = WidgetAction.fromParams(item);
    return GestureDetector(
      onTap: () => widget.callbacks.onAction(action),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_p('image_radius', 12)),
        child: CatalogNetworkImage(
          url: url,
          width: double.infinity,
          height: double.infinity,
          fit: fit,
          errorBuilder: widget.callbacks.imageErrorBuilder,
        ),
      ),
    );
  }
}

class _MiniProductGrid extends StatefulWidget {
  const _MiniProductGrid({required this.params, required this.callbacks, required this.theme});

  final Map<String, dynamic> params;
  final WidgetCallbacks callbacks;
  final EcommerceWidgetTheme theme;

  @override
  State<_MiniProductGrid> createState() => _MiniProductGridState();
}

class _MiniProductGridState extends State<_MiniProductGrid> {
  late final Future<List<ProductCardData>> _future =
      widget.callbacks.fetchProducts(ProductQuery.fromParams(widget.params));

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductCardData>>(
      future: _future,
      builder: (context, snapshot) {
        final products = (snapshot.data ?? const []).take(4).toList();
        if (products.isEmpty) return const SizedBox.shrink();

        return LayoutBuilder(
          builder: (context, constraints) {
            const spacing = 8.0;
            const cardPadding = 8.0;
            final itemWidth = (constraints.maxWidth - spacing) / 2;
            final imageSize = itemWidth - cardPadding * 2;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                for (final product in products)
                  SizedBox(
                    width: itemWidth,
                    child: MiniProductTile(
                      data: product,
                      callbacks: widget.callbacks,
                      theme: widget.theme,
                      imageSize: imageSize,
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
