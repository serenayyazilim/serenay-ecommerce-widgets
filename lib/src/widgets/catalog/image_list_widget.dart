import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../core/utils/param_parsing.dart';
import 'image_widget.dart';

/// IMAGELIST: several IMAGE widgets laid out side by side, each taking an
/// equal share of the row's width. Like the legacy SerBuilder IMAGELIST, each
/// image keeps its natural aspect ratio (`fit_width`, `height_percent`
/// ignored) so narrow cells don't crop the banner.
class ImageListWidget extends StatelessWidget {
  const ImageListWidget({
    super.key,
    required this.params,
    required this.callbacks,
  });

  final Map<String, dynamic> params;
  final WidgetCallbacks callbacks;

  @override
  Widget build(BuildContext context) {
    final list = (params['list'] as List?) ?? const [];
    if (list.isEmpty) return const SizedBox.shrink();

    final spacing = parseDouble(params['spacing']) ?? 0;
    final radius = params['radius'];
    final items = list.whereType<Map>().toList();

    return Container(
      color: parseColor(params['bg_color']),
      padding: EdgeInsets.symmetric(
        horizontal: parseDouble(params['padding_horizontal']) ?? 0,
        vertical: parseDouble(params['padding_vertical']) ?? 0,
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) SizedBox(width: spacing),
            Expanded(
              child: ImageWidget(
                params: {
                  ...Map<String, dynamic>.from(items[i]),
                  'height_percent': null,
                  'fit': items[i]['fit'] ?? 'fit_width',
                  'radius': items[i]['radius'] ?? radius,
                },
                callbacks: callbacks,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
