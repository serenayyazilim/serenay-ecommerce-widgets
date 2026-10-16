import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/widget_action.dart';
import '../../core/theme/ecommerce_widget_theme.dart';
import '../../core/utils/param_parsing.dart';
import 'catalog_network_image.dart';

/// BRANDS: brand logos on bordered tiles, either as a horizontally-scrolling
/// row (`layout: "row"`, default) or a wrapping grid (`layout: "grid"`).
/// Each logo resolves through the shared tap contract.
class BrandsWidget extends StatelessWidget {
  const BrandsWidget({
    super.key,
    required this.params,
    required this.callbacks,
    this.theme = const EcommerceWidgetTheme(),
  });

  final Map<String, dynamic> params;
  final WidgetCallbacks callbacks;
  final EcommerceWidgetTheme theme;

  List<Map<String, dynamic>> get _items => ((params['list'] as List?) ?? const [])
      .whereType<Map>()
      .map((e) => Map<String, dynamic>.from(e))
      .toList();

  @override
  Widget build(BuildContext context) {
    final items = _items;
    if (items.isEmpty) return const SizedBox.shrink();

    final spacing = parseDouble(params['spacing']) ?? 8;
    final parsedRatio = parseDouble(params['aspect_ratio']) ?? 1;
    final aspectRatio = parsedRatio > 0 ? parsedRatio : 1.0;
    final showTitle = parseBool(params['show_title']) ?? false;
    final titleSize = parseDouble(params['title_size']) ?? 12;
    final titleHeight = showTitle ? theme.spaceXs + titleSize * 1.4 : 0.0;
    final padding = EdgeInsets.symmetric(
      horizontal: parseDouble(params['padding_horizontal']) ?? 16,
      vertical: parseDouble(params['padding_vertical']) ?? 8,
    );

    Widget tile(Map<String, dynamic> item, double width) => SizedBox(
          width: width,
          child: _BrandTile(
            item: item,
            params: params,
            callbacks: callbacks,
            theme: theme,
            aspectRatio: aspectRatio,
            showTitle: showTitle,
            titleSize: titleSize,
          ),
        );

    final Widget content;
    if (params['layout'] == 'grid') {
      final parsedColumns = parseInt(params['columns']) ?? 4;
      final columns = parsedColumns > 0 ? parsedColumns : 4;
      content = Padding(
        padding: padding,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = (constraints.maxWidth - spacing * (columns - 1)) / columns;
            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [for (final item in items) tile(item, width)],
            );
          },
        ),
      );
    } else {
      final itemWidth = parseDouble(params['item_width']) ?? 88;
      content = SizedBox(
        height: itemWidth / aspectRatio + titleHeight + padding.vertical,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: padding,
          itemCount: items.length,
          separatorBuilder: (context, index) => SizedBox(width: spacing),
          itemBuilder: (context, index) => tile(items[index], itemWidth),
        ),
      );
    }

    return ColoredBox(
      color: parseColor(params['bg_color'], fallback: Colors.transparent)!,
      child: content,
    );
  }
}

class _BrandTile extends StatelessWidget {
  const _BrandTile({
    required this.item,
    required this.params,
    required this.callbacks,
    required this.theme,
    required this.aspectRatio,
    required this.showTitle,
    required this.titleSize,
  });

  final Map<String, dynamic> item;
  final Map<String, dynamic> params;
  final WidgetCallbacks callbacks;
  final EcommerceWidgetTheme theme;
  final double aspectRatio;
  final bool showTitle;
  final double titleSize;

  @override
  Widget build(BuildContext context) {
    final radius = parseDouble(params['radius']) ?? 8;
    final borderWidth = parseDouble(params['border_width']) ?? 1;
    final title = item['title']?.toString() ?? '';

    return GestureDetector(
      onTap: () => callbacks.onAction(WidgetAction.fromParams(item)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: aspectRatio,
            child: Container(
              padding: EdgeInsets.all(parseDouble(params['item_padding']) ?? 8),
              decoration: BoxDecoration(
                color: parseColor(params['item_bg_color'], fallback: Colors.white),
                borderRadius: BorderRadius.circular(radius),
                border: borderWidth > 0
                    ? Border.all(
                        color: parseColor(params['border_color'], fallback: theme.borderColor)!,
                        width: borderWidth,
                      )
                    : null,
              ),
              child: CatalogNetworkImage(
                url: item['image']?.toString() ?? '',
                fit: parseBoxFit(params['fit'], fallback: BoxFit.contain),
                errorBuilder: callbacks.imageErrorBuilder,
              ),
            ),
          ),
          if (showTitle) ...[
            SizedBox(height: theme.spaceXs),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: titleSize,
                color: parseColor(params['title_color'], fallback: theme.textPrimaryColor),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
