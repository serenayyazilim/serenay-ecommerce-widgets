import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import 'image_widget.dart';

/// IMAGELIST: several IMAGE widgets laid out side by side, each taking an
/// equal share of the row's width.
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

    return Row(
      children: list
          .whereType<Map>()
          .map(
            (item) => Expanded(
              child: ImageWidget(
                params: Map<String, dynamic>.from(item),
                callbacks: callbacks,
              ),
            ),
          )
          .toList(),
    );
  }
}
