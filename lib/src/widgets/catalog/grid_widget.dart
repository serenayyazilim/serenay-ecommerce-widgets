import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/product_card_data.dart';
import '../../contracts/product_query.dart';
import '../../core/theme/ecommerce_widget_theme.dart';
import '../../core/utils/param_parsing.dart';
import 'old_product_card.dart';

/// GRID: the same product-query contract as CAROUSEL, rendered as a
/// 2-column grid of OldProductCard (GRID's own, taller card design)
/// instead of a horizontal row.
class GridWidget extends StatefulWidget {
  const GridWidget({
    super.key,
    required this.params,
    required this.callbacks,
    this.theme = const EcommerceWidgetTheme(),
  });

  final Map<String, dynamic> params;
  final WidgetCallbacks callbacks;
  final EcommerceWidgetTheme theme;

  @override
  State<GridWidget> createState() => _GridWidgetState();
}

class _GridWidgetState extends State<GridWidget> {
  late final Future<List<ProductCardData>> _future =
      widget.callbacks.fetchProducts(ProductQuery.fromParams(widget.params));

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductCardData>>(
      future: _future,
      builder: (context, snapshot) {
        final products = snapshot.data ?? const [];
        if (products.isEmpty) return const SizedBox.shrink();

        final params = widget.params;
        final parsedColumns = parseInt(params['columns']) ?? widget.theme.gridColumns;
        final columns = parsedColumns > 0 ? parsedColumns : widget.theme.gridColumns;
        final spacing = parseDouble(params['spacing']) ?? 8;
        final runSpacing = parseDouble(params['run_spacing']) ?? spacing;

        return Container(
          color: parseColor(params['bg_color']),
          padding: EdgeInsets.symmetric(
            horizontal: parseDouble(params['padding_horizontal']) ?? 8,
            vertical: parseDouble(params['padding_vertical']) ?? 8,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth =
                  (constraints.maxWidth - spacing * (columns - 1)) / columns;

              return Wrap(
                spacing: spacing,
                runSpacing: runSpacing,
                children: [
                  for (final product in products)
                    SizedBox(
                      width: itemWidth,
                      child: OldProductCard(
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
