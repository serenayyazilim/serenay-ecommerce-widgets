import 'package:flutter/material.dart';

import '../../core/theme/ecommerce_widget_theme.dart';

/// TEXT: a simple or compound text block with three visual styles
/// (`default`, `section`, `banner_text` — §2 of the widget catalog doc).
class TextWidget extends StatelessWidget {
  const TextWidget({super.key, required this.params, this.theme = const EcommerceWidgetTheme()});

  final Map<String, dynamic> params;
  final EcommerceWidgetTheme theme;

  TextAlign _align(String? value) {
    switch (value) {
      case 'center':
        return TextAlign.center;
      case 'right':
        return TextAlign.right;
      case 'justify':
        return TextAlign.justify;
      default:
        return TextAlign.left;
    }
  }

  double _fontSize(String? size) {
    switch (size) {
      case 'small':
        return 12;
      case 'medium':
        return 14;
      case 'large':
        return 18;
      case 'title':
        return 22;
      default:
        return 24; // headline (default)
    }
  }

  Color? _color(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    final value = hex.replaceFirst('#', '');
    final parsed = int.tryParse('FF$value', radix: 16);
    return parsed != null ? Color(parsed) : null;
  }

  @override
  Widget build(BuildContext context) {
    final text = (params['text'] as String?) ?? '';
    final subtitle = params['subtitle'] as String?;
    final style = (params['style'] as String?) ?? 'default';
    final align = _align(params['align'] as String?);
    final color = _color(params['color'] as String?) ?? theme.textPrimaryColor;
    final paddingH = ((params['padding_horizontal'] as num?) ?? 16).toDouble();
    final paddingV = ((params['padding_vertical'] as num?) ?? 12).toDouble();

    if (text.isEmpty && (subtitle == null || subtitle.isEmpty)) {
      return const SizedBox.shrink();
    }

    Widget content;
    switch (style) {
      case 'section':
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              textAlign: align,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            if (subtitle != null && subtitle.isNotEmpty) ...[
              SizedBox(height: theme.spaceXs),
              Text(
                subtitle,
                textAlign: align,
                style: theme.captionStyle.copyWith(fontSize: 13),
              ),
            ],
          ],
        );
        break;
      case 'banner_text':
        content = Container(
          width: double.infinity,
          padding: EdgeInsets.all(theme.spaceM),
          decoration: BoxDecoration(
            color: theme.surfaceColor,
            borderRadius: BorderRadius.circular(theme.radiusM),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                textAlign: align,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              if (subtitle != null && subtitle.isNotEmpty) ...[
                SizedBox(height: theme.spaceXs),
                Text(
                  subtitle,
                  textAlign: align,
                  style: theme.captionStyle.copyWith(fontSize: 13),
                ),
              ],
            ],
          ),
        );
        break;
      default:
        content = Text(
          text,
          textAlign: align,
          style: TextStyle(
            fontSize: _fontSize(params['size'] as String?),
            fontWeight: FontWeight.w600,
            color: color,
          ),
        );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
      child: content,
    );
  }
}
