import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/widget_action.dart';
import '../../core/theme/ecommerce_widget_theme.dart';
import '../../core/utils/param_parsing.dart';
import 'catalog_network_image.dart';

/// CATEGORYMENU: a horizontal row of circular category icons with a label
/// underneath, each resolving through the shared tap contract — the common
/// "shop by category" strip shown near the top of an e-commerce home
/// screen, distinct from STORY (which opens a full-screen viewer instead of
/// navigating directly).
class CategoryMenuWidget extends StatelessWidget {
  const CategoryMenuWidget({
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

    final imageSize = parseDouble(params['image_size']) ?? 56;
    final itemWidth = parseDouble(params['item_width']) ?? imageSize + 8;
    final radius = parseDouble(params['radius']) ?? imageSize / 2;
    final parsedMaxLines = parseInt(params['max_lines']) ?? 1;
    final maxLines = parsedMaxLines > 0 ? parsedMaxLines : 1;
    final titleStyle = theme.captionStyle.copyWith(
      color: parseColor(params['title_color'], fallback: theme.textPrimaryColor),
      fontSize: parseDouble(params['title_size']),
    );
    final lineHeight = (titleStyle.fontSize ?? 12) * 1.4;
    final imageBgColor = parseColor(params['image_bg_color']);

    return Container(
      height: parseDouble(params['height']) ?? imageSize + 36 + (maxLines - 1) * lineHeight,
      color: parseColor(params['bg_color']),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: parseDouble(params['padding_horizontal']) ?? theme.spaceM,
        ),
        itemCount: items.length,
        separatorBuilder: (context, index) =>
            SizedBox(width: parseDouble(params['spacing']) ?? theme.spaceM),
        itemBuilder: (context, index) {
          final item = items[index];
          final image = item['image']?.toString() ?? '';
          final title = item['title']?.toString() ?? '';
          return GestureDetector(
            onTap: () => callbacks.onAction(WidgetAction.fromParams(item)),
            child: SizedBox(
              width: itemWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(radius),
                    child: Container(
                      width: imageSize,
                      height: imageSize,
                      color: imageBgColor,
                      child: CatalogNetworkImage(
                        url: image,
                        fit: parseBoxFit(params['fit']),
                        errorBuilder: callbacks.imageErrorBuilder,
                      ),
                    ),
                  ),
                  SizedBox(height: theme.spaceXs),
                  Text(
                    title,
                    maxLines: maxLines,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: titleStyle,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
