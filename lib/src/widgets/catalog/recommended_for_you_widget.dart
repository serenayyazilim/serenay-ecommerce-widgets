import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/product_card_data.dart';
import '../../contracts/product_query.dart';
import '../../core/theme/ecommerce_widget_theme.dart';
import 'rich_product_card.dart';

/// RECOMMENDEDFORYOU: a titled, horizontally-scrolling row of the shared
/// rich product card — the same product-query contract as CAROUSEL, plus a
/// header (CAROUSEL has none) so a personalized "Recommended For You" rail
/// reads as its own section rather than blending into the feed.
class RecommendedForYouWidget extends StatefulWidget {
  const RecommendedForYouWidget({
    super.key,
    required this.params,
    required this.callbacks,
    this.theme = const EcommerceWidgetTheme(),
  });

  final Map<String, dynamic> params;
  final WidgetCallbacks callbacks;
  final EcommerceWidgetTheme theme;

  @override
  State<RecommendedForYouWidget> createState() => _RecommendedForYouWidgetState();
}

class _RecommendedForYouWidgetState extends State<RecommendedForYouWidget> {
  late final Future<List<ProductCardData>> _future =
      widget.callbacks.fetchProducts(ProductQuery.fromParams(widget.params));

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return FutureBuilder<List<ProductCardData>>(
      future: _future,
      builder: (context, snapshot) {
        final products = snapshot.data ?? const [];
        if (products.isEmpty) return const SizedBox.shrink();

        final title = (widget.params['title'] as String?) ?? theme.recommendedForYouTitleLabel;

        return Padding(
          padding: EdgeInsets.symmetric(vertical: theme.spaceS),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: theme.spaceM),
                child: Text(title, style: theme.productTitleStyle.copyWith(fontSize: 15)),
              ),
              SizedBox(height: theme.spaceS),
              SizedBox(
                height: 260,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: theme.spaceM),
                  itemCount: products.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final builder = widget.callbacks.productCardBuilder;
                    return SizedBox(
                      width: 160,
                      child: builder != null
                          ? builder(products[index])
                          : RichProductCard(
                              data: products[index],
                              callbacks: widget.callbacks,
                              imageSize: 160,
                              theme: theme,
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
