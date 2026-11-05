import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/widget_action.dart';
import '../../core/theme/ecommerce_widget_theme.dart';
import '../../core/utils/param_parsing.dart';
import 'catalog_network_image.dart';

/// HOTSPOT: a "shop the look" image with tappable dots placed over the
/// products in it. `x`/`y` are fractions (0–1) of the rendered image box.
/// Tapping a dot that has a `title` opens a small label; tapping the label
/// resolves the dot's action. A dot without a `title` resolves straight
/// away.
class HotspotWidget extends StatefulWidget {
  const HotspotWidget({
    super.key,
    required this.params,
    required this.callbacks,
    this.theme = const EcommerceWidgetTheme(),
  });

  final Map<String, dynamic> params;
  final WidgetCallbacks callbacks;
  final EcommerceWidgetTheme theme;

  @override
  State<HotspotWidget> createState() => _HotspotWidgetState();
}

class _HotspotWidgetState extends State<HotspotWidget> {
  int? _open;

  @override
  Widget build(BuildContext context) {
    final params = widget.params;
    final url = params['url']?.toString() ?? '';
    if (url.isEmpty) return const SizedBox.shrink();

    final theme = widget.theme;
    final heightPercent = parseDouble(params['height_percent']) ?? 1.0;
    final radius = parseDouble(params['radius']) ?? 0;
    final dotSize = parseDouble(params['dot_size']) ?? 24;
    final dotColor = parseColor(params['dot_color'], fallback: theme.primaryColor)!;
    final spots = ((params['list'] as List?) ?? const [])
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .where((e) => parseDouble(e['x']) != null && parseDouble(e['y']) != null)
        .toList();

    return Padding(
      padding: EdgeInsets.all(parseDouble(params['padding']) ?? 0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = width * heightPercent;
          return ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: SizedBox(
              width: width,
              height: height,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: GestureDetector(
                      // A tap on the image closes an open label; otherwise
                      // it follows the image's own action, if it has one.
                      onTap: () {
                        if (_open != null) return setState(() => _open = null);
                        if (params['type'] != null) {
                          widget.callbacks.onAction(WidgetAction.fromParams(params));
                        }
                      },
                      child: CatalogNetworkImage(
                        url: url,
                        width: width,
                        height: height,
                        fit: parseBoxFit(params['fit']),
                        errorBuilder: widget.callbacks.imageErrorBuilder,
                      ),
                    ),
                  ),
                  for (final (i, spot) in spots.indexed)
                    _dot(i, spot, width, height, dotSize, dotColor),
                  if (_open != null && _open! < spots.length)
                    _label(spots[_open!], width, height, dotSize),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Offset _center(Map<String, dynamic> spot, double width, double height) => Offset(
    parseDouble(spot['x'])!.clamp(0.0, 1.0) * width,
    parseDouble(spot['y'])!.clamp(0.0, 1.0) * height,
  );

  Widget _dot(
    int i,
    Map<String, dynamic> spot,
    double width,
    double height,
    double size,
    Color color,
  ) {
    final c = _center(spot, width, height);
    final title = spot['title']?.toString() ?? '';
    return Positioned(
      left: c.dx - size / 2,
      top: c.dy - size / 2,
      child: Semantics(
        button: true,
        label: title.isEmpty ? null : title,
        child: GestureDetector(
          onTap: () => title.isEmpty
              ? widget.callbacks.onAction(WidgetAction.fromParams(spot))
              : setState(() => _open = _open == i ? null : i),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
            ),
            alignment: Alignment.center,
            child: Container(
              width: size * 0.45,
              height: size * 0.45,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(Map<String, dynamic> spot, double width, double height, double dotSize) {
    final c = _center(spot, width, height);
    const maxLabelWidth = 180.0;
    final subtitle = spot['subtitle']?.toString() ?? '';
    // Opens below the dot, or above it when the dot sits in the lower half;
    // shifted sideways so it never leaves the image.
    final below = c.dy < height / 2;
    final left = (c.dx - maxLabelWidth / 2).clamp(
      4.0,
      (width - maxLabelWidth - 4).clamp(4.0, double.infinity),
    );
    return Positioned(
      left: left,
      top: below ? c.dy + dotSize / 2 + 6 : null,
      bottom: below ? null : height - c.dy + dotSize / 2 + 6,
      width: maxLabelWidth,
      child: Align(
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () => widget.callbacks.onAction(WidgetAction.fromParams(spot)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        spot['title'].toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: widget.theme.captionStyle.copyWith(
                          color: widget.theme.textPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (subtitle.isNotEmpty)
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: widget.theme.captionStyle.copyWith(
                            color: widget.theme.textSecondaryColor,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.chevron_right, size: 16, color: widget.theme.textSecondaryColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
