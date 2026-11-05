import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/widget_action.dart';
import '../../core/theme/ecommerce_widget_theme.dart';
import '../../core/utils/param_parsing.dart';
import 'catalog_network_image.dart';

/// QUICKFILTERS: a horizontally-scrolling row of pill-shaped chips ("Under
/// 500 TL", "Free Shipping", "New Season"), each resolving through the
/// shared tap contract — usually `type: "filter"` or `type: "search"`.
class QuickFiltersWidget extends StatelessWidget {
  const QuickFiltersWidget({
    super.key,
    required this.params,
    required this.callbacks,
    this.theme = const EcommerceWidgetTheme(),
  });

  final Map<String, dynamic> params;
  final WidgetCallbacks callbacks;
  final EcommerceWidgetTheme theme;

  @override
  Widget build(BuildContext context) {
    final items = ((params['list'] as List?) ?? const [])
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .where((e) => (e['title']?.toString() ?? '').isNotEmpty)
        .toList();
    if (items.isEmpty) return const SizedBox.shrink();

    final chipColor = parseColor(params['chip_color'], fallback: theme.surfaceColor);
    final textColor = parseColor(params['text_color'], fallback: theme.textPrimaryColor);
    final borderColor = parseColor(params['border_color'], fallback: theme.borderColor)!;
    final radius = parseDouble(params['radius']) ?? 20;
    final textSize = parseDouble(params['text_size']) ?? 13;
    final paddingV = parseDouble(params['padding_vertical']) ?? 8;

    return Container(
      color: parseColor(params['bg_color']),
      padding: EdgeInsets.symmetric(vertical: paddingV),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: parseDouble(params['padding_horizontal']) ?? theme.spaceM,
        ),
        child: Row(
          children: [
            for (final (i, item) in items.indexed) ...[
              if (i > 0) SizedBox(width: parseDouble(params['spacing']) ?? 8),
              Semantics(
                button: true,
                child: GestureDetector(
                  onTap: () => callbacks.onAction(WidgetAction.fromParams(item)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: chipColor,
                      borderRadius: BorderRadius.circular(radius),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if ((item['image']?.toString() ?? '').isNotEmpty) ...[
                          CatalogNetworkImage(
                            url: item['image'].toString(),
                            width: textSize + 5,
                            height: textSize + 5,
                            fit: BoxFit.contain,
                            errorBuilder: callbacks.imageErrorBuilder,
                          ),
                          const SizedBox(width: 6),
                        ],
                        Text(
                          item['title'].toString(),
                          style: theme.captionStyle.copyWith(
                            fontSize: textSize,
                            color: textColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
