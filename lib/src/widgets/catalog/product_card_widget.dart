import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/product_card_data.dart';
import '../../contracts/product_query.dart';
import '../../core/theme/ecommerce_widget_theme.dart';
import 'rich_product_card.dart';

/// PRODUCTCARD: a 2-column grid of the shared rich product card — the same
/// component GRID and CAROUSEL use. In the source app this widget and GRID
/// are visually identical; PRODUCTCARD is kept as its own catalog entry
/// because the backend addresses them as distinct widget types.
class ProductCardWidget extends StatefulWidget {
  const ProductCardWidget({
    super.key,
    required this.params,
    required this.callbacks,
    this.theme = const EcommerceWidgetTheme(),
  });

  final Map<String, dynamic> params;
  final WidgetCallbacks callbacks;
  final EcommerceWidgetTheme theme;

  @override
  State<ProductCardWidget> createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget> {
  late final Future<List<ProductCardData>> _future =
      widget.callbacks.fetchProducts(ProductQuery.fromParams(widget.params));

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductCardData>>(
      future: _future,
      builder: (context, snapshot) {
        final products = snapshot.data ?? const [];
        if (products.isEmpty) return const SizedBox.shrink();

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.6,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) => RichProductCard(
            data: products[index],
            callbacks: widget.callbacks,
            theme: widget.theme,
          ),
        );
      },
    );
  }
}
