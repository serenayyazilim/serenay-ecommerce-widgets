import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/widget_action.dart';
import '../../core/utils/param_parsing.dart';
import 'catalog_network_image.dart';

/// BANNERGRID: a mosaic of tappable banner images. The `left_big` (default),
/// `right_big` and `top_big` layouts show one large banner next to two
/// stacked small ones (first three `list` items); `grid` lays every item out
/// in equal cells. Preset layouts with fewer than three items fall back to
/// `grid`.
class BannerGridWidget extends StatelessWidget {
  const BannerGridWidget({
    super.key,
    required this.params,
    required this.callbacks,
  });

  final Map<String, dynamic> params;
  final WidgetCallbacks callbacks;

  List<Map<String, dynamic>> get _items => ((params['list'] as List?) ?? const [])
      .whereType<Map>()
      .map((e) => Map<String, dynamic>.from(e))
      .toList();

  @override
  Widget build(BuildContext context) {
    final items = _items;
    if (items.isEmpty) return const SizedBox.shrink();

    final spacing = parseDouble(params['spacing']) ?? 8;
    final layout = params['layout']?.toString() ?? 'left_big';
    final isPreset = const {'left_big', 'right_big', 'top_big'}.contains(layout);

    return Container(
      color: parseColor(params['bg_color']),
      padding: EdgeInsets.symmetric(
        horizontal: parseDouble(params['padding_horizontal']) ?? 0,
        vertical: parseDouble(params['padding_vertical']) ?? 0,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => isPreset && items.length >= 3
            ? _buildPreset(items, layout, constraints.maxWidth, spacing)
            : _buildGrid(items, constraints.maxWidth, spacing),
      ),
    );
  }

  Widget _cell(Map<String, dynamic> item) {
    final radius = parseDouble(params['radius']) ?? 0;
    return GestureDetector(
      onTap: () => callbacks.onAction(WidgetAction.fromParams(item)),
      child: CatalogNetworkImage(
        url: item['url']?.toString() ?? '',
        width: double.infinity,
        height: double.infinity,
        fit: parseBoxFit(item['fit'] ?? params['fit']),
        borderRadius: radius > 0 ? BorderRadius.circular(radius) : null,
        errorBuilder: callbacks.imageErrorBuilder,
      ),
    );
  }

  Widget _buildPreset(List<Map<String, dynamic>> items, String layout, double width, double spacing) {
    final parsedRatio = parseDouble(params['big_ratio']) ?? 0.5;
    final bigRatio = parsedRatio > 0 && parsedRatio < 1 ? parsedRatio : 0.5;
    final bigFlex = (bigRatio * 1000).round();
    final smallFlex = 1000 - bigFlex;
    final isVertical = layout == 'top_big';

    final big = Expanded(flex: bigFlex, child: _cell(items[0]));
    final gap = SizedBox(width: spacing, height: spacing);
    final smalls = Expanded(
      flex: smallFlex,
      child: Flex(
        direction: isVertical ? Axis.horizontal : Axis.vertical,
        children: [
          Expanded(child: _cell(items[1])),
          gap,
          Expanded(child: _cell(items[2])),
        ],
      ),
    );

    return SizedBox(
      height: width * (parseDouble(params['height_percent']) ?? 0.6),
      child: Flex(
        direction: isVertical ? Axis.vertical : Axis.horizontal,
        children: layout == 'right_big' ? [smalls, gap, big] : [big, gap, smalls],
      ),
    );
  }

  Widget _buildGrid(List<Map<String, dynamic>> items, double width, double spacing) {
    final parsedColumns = parseInt(params['columns']) ?? 2;
    final columns = parsedColumns > 0 ? parsedColumns : 2;
    final parsedRatio = parseDouble(params['aspect_ratio']) ?? 1;
    final aspectRatio = parsedRatio > 0 ? parsedRatio : 1.0;
    final cellWidth = (width - spacing * (columns - 1)) / columns;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: [
        for (final item in items)
          SizedBox(width: cellWidth, height: cellWidth / aspectRatio, child: _cell(item)),
      ],
    );
  }
}
