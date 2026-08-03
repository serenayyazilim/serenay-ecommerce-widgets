import 'dart:async';

import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/product_card_data.dart';
import '../../contracts/product_query.dart';
import '../../contracts/widget_action.dart';
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
  });

  final Map<String, dynamic> params;
  final WidgetCallbacks callbacks;

  @override
  State<MixedCarouselWidget> createState() => _SerMixedCarouselWidgetState();
}

class _SerMixedCarouselWidgetState extends State<MixedCarouselWidget> {
  final _pageController = PageController(viewportFraction: 0.8);
  Timer? _autoplay;
  bool _userInteracted = false;

  List<Map<String, dynamic>> get _items => ((widget.params['items'] as List?) ?? const [])
      .whereType<Map>()
      .map((e) => Map<String, dynamic>.from(e))
      .toList();

  @override
  void initState() {
    super.initState();
    _autoplay = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_userInteracted || !_pageController.hasClients) return;
      final items = _items;
      if (items.isEmpty) return;
      final next = ((_pageController.page ?? 0).round() + 1) % items.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoplay?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Color _bgColor(String? hex) {
    if (hex == null || hex.isEmpty) return Colors.white;
    final value = hex.replaceFirst('#', '');
    final parsed = int.tryParse('FF$value', radix: 16);
    return parsed != null ? Color(parsed) : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;
    if (items.isEmpty) return const SizedBox.shrink();

    final heightPercent = (widget.params['height_percent'] as num?)?.toDouble() ?? 1.1;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return SizedBox(
          height: width * heightPercent,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollStartNotification &&
                  notification.dragDetails != null) {
                _userInteracted = true;
              }
              return false;
            },
            child: PageView.builder(
              controller: _pageController,
              padEnds: false,
              itemCount: items.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: _buildPage(items[index]),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPage(Map<String, dynamic> item) {
    final itemType = item['item_type'] as String?;
    final bgColor = _bgColor(item['bg_color'] as String?);
    final title = item['title'] as String?;
    final titleColor = _bgColor(item['title_color'] as String?);
    final description = item['description'] as String?;
    final descriptionColor = _bgColor(item['description_color'] as String?);

    if (itemType == 'image') {
      final url = item['url'] as String? ?? '';
      final action = WidgetAction.fromParams(item);
      return GestureDetector(
        onTap: () => widget.callbacks.onAction(action),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(color: bgColor, child: CatalogNetworkImage(url: url)),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.all(14),
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
                fontSize: 19,
                height: 1.15,
              ),
            ),
          if (description != null) ...[
            const SizedBox(height: 4),
            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: descriptionColor, fontSize: 13),
            ),
          ],
          if (title != null || description != null) const SizedBox(height: 10),
          Expanded(child: _MiniProductGrid(params: item, callbacks: widget.callbacks)),
        ],
      ),
    );
  }
}

class _MiniProductGrid extends StatefulWidget {
  const _MiniProductGrid({required this.params, required this.callbacks});

  final Map<String, dynamic> params;
  final WidgetCallbacks callbacks;

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

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.62,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) => MiniProductTile(
            data: products[index],
            callbacks: widget.callbacks,
          ),
        );
      },
    );
  }
}
