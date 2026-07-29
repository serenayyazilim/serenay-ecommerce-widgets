import 'package:flutter/material.dart';

import '../../callbacks/ser_builder_callbacks.dart';
import '../../contracts/product_card_data.dart';
import '../../contracts/product_query.dart';
import 'rich_product_card.dart';

/// GRID: the same product-query contract as CAROUSEL, rendered as a
/// 2-column grid of the shared rich product card instead of a horizontal
/// row.
class SerGridWidget extends StatefulWidget {
  const SerGridWidget({
    super.key,
    required this.params,
    required this.callbacks,
  });

  final Map<String, dynamic> params;
  final SerBuilderCallbacks callbacks;

  @override
  State<SerGridWidget> createState() => _SerGridWidgetState();
}

class _SerGridWidgetState extends State<SerGridWidget> {
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
          ),
        );
      },
    );
  }
}
