import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/widget_action.dart';
import '../../core/theme/ecommerce_widget_theme.dart';
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

    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: theme.spaceM),
        itemCount: items.length,
        separatorBuilder: (context, index) => SizedBox(width: theme.spaceM),
        itemBuilder: (context, index) {
          final item = items[index];
          final image = item['image'] as String? ?? '';
          final title = item['title'] as String? ?? '';
          return GestureDetector(
            onTap: () => callbacks.onAction(WidgetAction.fromParams(item)),
            child: SizedBox(
              width: 64,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: CatalogNetworkImage(
                        url: image,
                        errorBuilder: callbacks.imageErrorBuilder,
                      ),
                    ),
                  ),
                  SizedBox(height: theme.spaceXs),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: theme.captionStyle.copyWith(color: theme.textPrimaryColor),
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
