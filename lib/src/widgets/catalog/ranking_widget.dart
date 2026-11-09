import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/product_card_data.dart';
import '../../contracts/product_query.dart';
import '../../core/theme/ecommerce_widget_theme.dart';
import '../../core/utils/param_parsing.dart';
import 'rich_product_card.dart';

/// RANKING: a titled "Top 10" row — the same product-query contract as
/// CAROUSEL, with a large rank number (1, 2, 3, ...) beside each card in
/// the order the products come back.
class RankingWidget extends StatefulWidget {
  const RankingWidget({
    super.key,
    required this.params,
    required this.callbacks,
    this.theme = const EcommerceWidgetTheme(),
  });

  final Map<String, dynamic> params;
  final WidgetCallbacks callbacks;
  final EcommerceWidgetTheme theme;

  @override
  State<RankingWidget> createState() => _RankingWidgetState();
}

class _RankingWidgetState extends State<RankingWidget> {
  late final Future<List<ProductCardData>> _future = widget.callbacks.fetchProducts(
    ProductQuery.fromParams(widget.params),
  );

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final params = widget.params;
    return FutureBuilder<List<ProductCardData>>(
      future: _future,
      builder: (context, snapshot) {
        final products = snapshot.data ?? const [];
        if (products.isEmpty) return const SizedBox.shrink();

        final title = params['title']?.toString() ?? '';
        final rankColor = parseColor(params['rank_color'], fallback: theme.primaryColor)!;
        final itemWidth = parseDouble(params['item_width']) ?? 150;
        final builder = widget.callbacks.productCardBuilder;

        return Container(
          color: parseColor(params['bg_color']),
          padding: EdgeInsets.symmetric(vertical: theme.spaceS),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title.isNotEmpty) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: theme.spaceM),
                  child: Text(title, style: theme.productTitleStyle.copyWith(fontSize: 15)),
                ),
                SizedBox(height: theme.spaceS),
              ],
              SizedBox(
                height: parseDouble(params['height']) ?? 260,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: theme.spaceM),
                  itemCount: products.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) => Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${index + 1}',
                        style: TextStyle(fontSize: 56, height: 1, fontWeight: FontWeight.w800, color: rankColor),
                      ),
                      const SizedBox(width: 4),
                      SizedBox(
                        width: itemWidth,
                        child: builder != null
                            ? builder(products[index])
                            : RichProductCard(
                                data: products[index],
                                callbacks: widget.callbacks,
                                imageSize: itemWidth,
                                theme: theme,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
