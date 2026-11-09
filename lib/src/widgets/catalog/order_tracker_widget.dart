import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/widget_action.dart';
import '../../core/theme/ecommerce_widget_theme.dart';
import '../../core/utils/param_parsing.dart';
import 'catalog_network_image.dart';

/// ORDERTRACKER: a "your order is on its way" card — an optional product
/// image, a title/subtitle and a step bar (Ordered → Shipped → Delivered)
/// with every step up to `current` filled. Action fields in `params` make
/// the whole card tappable (e.g. to the order detail page).
class OrderTrackerWidget extends StatelessWidget {
  const OrderTrackerWidget({
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
    final steps = ((params['steps'] as List?) ?? const [])
        .map((e) => e?.toString() ?? '')
        .where((e) => e.isNotEmpty)
        .toList();
    if (steps.isEmpty) return const SizedBox.shrink();

    final current = (parseInt(params['current']) ?? 0).clamp(0, steps.length - 1);
    final active = parseColor(params['active_color'], fallback: theme.primaryColor)!;
    final title = params['title']?.toString() ?? '';
    final subtitle = params['subtitle']?.toString() ?? '';
    final image = params['image']?.toString() ?? '';
    final tappable = params['type'] != null;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: theme.spaceM, vertical: theme.spaceS),
      child: GestureDetector(
        onTap: tappable ? () => callbacks.onAction(WidgetAction.fromParams(params)) : null,
        child: Container(
          padding: EdgeInsets.all(theme.spaceM),
          decoration: BoxDecoration(
            color: parseColor(params['bg_color'], fallback: theme.surfaceColor),
            borderRadius: BorderRadius.circular(theme.radiusM),
            border: Border.all(color: theme.borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (title.isNotEmpty || subtitle.isNotEmpty || image.isNotEmpty) ...[
                Row(
                  children: [
                    if (image.isNotEmpty) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(theme.radiusS),
                        child: CatalogNetworkImage(
                          url: image,
                          width: 48,
                          height: 48,
                          errorBuilder: callbacks.imageErrorBuilder,
                        ),
                      ),
                      SizedBox(width: theme.spaceS),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (title.isNotEmpty) Text(title, style: theme.productTitleStyle.copyWith(fontSize: 15)),
                          if (subtitle.isNotEmpty)
                            Text(subtitle, style: theme.captionStyle.copyWith(color: theme.textSecondaryColor)),
                        ],
                      ),
                    ),
                    if (tappable) Icon(Icons.chevron_right, color: theme.textSecondaryColor),
                  ],
                ),
                SizedBox(height: theme.spaceM),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final (i, step) in steps.indexed)
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: _line(i > 0 && i <= current, i > 0, active)),
                              Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: i <= current ? active : theme.surfaceColor,
                                  border: Border.all(color: i <= current ? active : theme.borderColor, width: 2),
                                ),
                              ),
                              Expanded(child: _line(i < current, i < steps.length - 1, active)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            step,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: theme.captionStyle.copyWith(
                              fontSize: 11,
                              color: i <= current ? theme.textPrimaryColor : theme.textSecondaryColor,
                              fontWeight: i == current ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Half of the connector between two dots; hidden past the first/last.
  Widget _line(bool filled, bool visible, Color active) =>
      Container(height: 2, color: !visible ? Colors.transparent : (filled ? active : theme.borderColor));
}
