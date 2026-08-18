import 'package:flutter/material.dart';

import '../../core/theme/ecommerce_widget_theme.dart';
import '../../core/utils/param_parsing.dart';

/// RATING: a star rating row plus an optional review count, reading its
/// colors and star size straight from [EcommerceWidgetTheme] (the theme
/// already exposed `ratingFilledColor`/`ratingEmptyColor`/`starSize` — this
/// is the first widget that actually renders them).
class RatingWidget extends StatelessWidget {
  const RatingWidget({
    super.key,
    required this.params,
    this.theme = const EcommerceWidgetTheme(),
  });

  final Map<String, dynamic> params;
  final EcommerceWidgetTheme theme;

  @override
  Widget build(BuildContext context) {
    final maxRating = parseInt(params['max_rating']) ?? 5;
    final rating = (parseDouble(params['rating']) ?? 0).clamp(0, maxRating.toDouble()).toDouble();
    final reviewCount = parseInt(params['review_count']);
    final label = params['label'] as String?;

    if (maxRating <= 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < maxRating; i++) _star(i, rating),
          const SizedBox(width: 6),
          Text(
            label ?? rating.toStringAsFixed(1),
            style: theme.captionStyle.copyWith(fontWeight: FontWeight.w600, color: theme.textPrimaryColor),
          ),
          if (reviewCount != null) ...[
            const SizedBox(width: 4),
            Text('($reviewCount)', style: theme.captionStyle),
          ],
        ],
      ),
    );
  }

  Widget _star(int index, double rating) {
    final fillFraction = (rating - index).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.only(right: 2),
      child: fillFraction >= 1
          ? Icon(Icons.star_rounded, size: theme.starSize, color: theme.ratingFilledColor)
          : fillFraction <= 0
              ? Icon(Icons.star_rounded, size: theme.starSize, color: theme.ratingEmptyColor)
              : Stack(
                  children: [
                    Icon(Icons.star_rounded, size: theme.starSize, color: theme.ratingEmptyColor),
                    ClipRect(
                      clipper: _FractionClipper(fillFraction),
                      child: Icon(Icons.star_rounded, size: theme.starSize, color: theme.ratingFilledColor),
                    ),
                  ],
                ),
    );
  }
}

class _FractionClipper extends CustomClipper<Rect> {
  _FractionClipper(this.fraction);

  final double fraction;

  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, size.width * fraction, size.height);

  @override
  bool shouldReclip(covariant _FractionClipper oldClipper) => oldClipper.fraction != fraction;
}
