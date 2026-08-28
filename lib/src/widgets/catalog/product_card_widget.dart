import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/product_card_data.dart';
import '../../contracts/product_query.dart';
import '../../core/theme/ecommerce_widget_theme.dart';
import '../../core/utils/param_parsing.dart';
import 'rich_product_card.dart';

/// PRODUCTCARD: a 2-column grid of [RichProductCard] — the same component
/// CAROUSEL uses. GRID renders its own card ([OldProductCard]); PRODUCTCARD
/// is kept as its own catalog entry because the backend addresses them as
/// distinct widget types.
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

        final columns = parseInt(widget.params['columns']) ?? widget.theme.gridColumns;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 8.0;
              final itemWidth =
                  (constraints.maxWidth - spacing * (columns - 1)) / columns;

              final builder = widget.callbacks.productCardBuilder;
              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (final product in products)
                    SizedBox(
                      width: itemWidth,
                      child: builder != null
                          ? builder(product)
                          : RichProductCard(
                              data: product,
                              imageSize: itemWidth,
                              callbacks: widget.callbacks,
                              theme: widget.theme,
                            ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
