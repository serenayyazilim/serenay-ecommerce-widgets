import 'package:flutter/material.dart';

import '../../core/theme/ecommerce_widget_theme.dart';
import '../../core/utils/param_parsing.dart';

/// ACCORDION: collapsible sections ("Shipping & Returns", FAQ entries,
/// product details). Reads its entries straight from `params['list']`, the
/// same inline-list contract as QNA. Each section opens and closes on its
/// own.
class AccordionWidget extends StatelessWidget {
  const AccordionWidget({super.key, required this.params, this.theme = const EcommerceWidgetTheme()});

  final Map<String, dynamic> params;
  final EcommerceWidgetTheme theme;

  @override
  Widget build(BuildContext context) {
    final items = ((params['list'] as List?) ?? const [])
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .where((e) => (e['title']?.toString() ?? '').isNotEmpty)
        .toList();
    if (items.isEmpty) return const SizedBox.shrink();

    final title = params['title']?.toString() ?? '';
    final textColor = parseColor(params['text_color'], fallback: theme.textPrimaryColor)!;
    final textSize = parseDouble(params['text_size']) ?? 14;
    final initialIndex = parseInt(params['initial_index']);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: theme.spaceM, vertical: theme.spaceS),
      // A Material (not a decorated Container) so the tiles' ink splashes show.
      child: Material(
        color: parseColor(params['bg_color'], fallback: theme.surfaceColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(theme.radiusM),
          side: BorderSide(color: theme.borderColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title.isNotEmpty)
              Padding(
                padding: EdgeInsets.fromLTRB(theme.spaceM, theme.spaceM, theme.spaceM, theme.spaceXs),
                child: Text(title, style: theme.productTitleStyle.copyWith(fontSize: 15)),
              ),
            for (final (i, item) in items.indexed) ...[
              if (i > 0) Divider(height: 1, color: theme.borderColor),
              Theme(
                // ExpansionTile draws its own dividers when open; ours sit
                // between sections instead.
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded: i == initialIndex,
                  iconColor: textColor,
                  collapsedIconColor: theme.textSecondaryColor,
                  tilePadding: EdgeInsets.symmetric(horizontal: theme.spaceM),
                  childrenPadding: EdgeInsets.fromLTRB(theme.spaceM, 0, theme.spaceM, theme.spaceM),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  title: Text(
                    item['title'].toString(),
                    style: theme.productTitleStyle.copyWith(
                      fontSize: textSize,
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  children: [
                    Text(
                      item['text']?.toString() ?? '',
                      style: theme.captionStyle.copyWith(color: theme.textSecondaryColor, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
