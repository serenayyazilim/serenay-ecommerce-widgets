import 'package:flutter/material.dart';

import '../../core/theme/ecommerce_widget_theme.dart';
import '../../core/utils/param_parsing.dart';

/// REVIEWS: a horizontally-scrolling row of customer review cards — author,
/// star rating, comment and an optional "Verified Purchase" badge — with an
/// optional aggregate rating/count header, matching RATING's summary style.
///
/// Reads its entries straight from `params['list']` (no fetch callback),
/// the same inline-list contract as CATEGORYMENU.
class ReviewsWidget extends StatelessWidget {
  const ReviewsWidget({
    super.key,
    required this.params,
    this.theme = const EcommerceWidgetTheme(),
  });

  final Map<String, dynamic> params;
  final EcommerceWidgetTheme theme;

  List<Map<String, dynamic>> get _items => ((params['list'] as List?) ?? const [])
      .whereType<Map>()
      .map((e) => Map<String, dynamic>.from(e))
      .toList();

  @override
  Widget build(BuildContext context) {
    final items = _items;
    if (items.isEmpty) return const SizedBox.shrink();

    final title = (params['title'] as String?) ?? theme.reviewsTitleLabel;
    final averageRating = parseDouble(params['average_rating']);
    final reviewCount = parseInt(params['review_count']);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: theme.spaceS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: theme.spaceM),
            child: Row(
              children: [
                Expanded(child: Text(title, style: theme.productTitleStyle.copyWith(fontSize: 15))),
                if (averageRating != null) ...[
                  Icon(Icons.star_rounded, size: theme.starSize, color: theme.ratingFilledColor),
                  const SizedBox(width: 2),
                  Text(
                    averageRating.toStringAsFixed(1),
                    style: theme.captionStyle.copyWith(fontWeight: FontWeight.w600, color: theme.textPrimaryColor),
                  ),
                  if (reviewCount != null) ...[
                    const SizedBox(width: 4),
                    Text('($reviewCount)', style: theme.captionStyle),
                  ],
                ],
              ],
            ),
          ),
          SizedBox(height: theme.spaceS),
          SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: theme.spaceM),
              itemCount: items.length,
              separatorBuilder: (_, _) => SizedBox(width: theme.spaceS),
              itemBuilder: (context, index) => _ReviewCard(item: items[index], theme: theme),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.item, required this.theme});

  final Map<String, dynamic> item;
  final EcommerceWidgetTheme theme;

  @override
  Widget build(BuildContext context) {
    final author = (item['author'] as String?) ?? '';
    final avatar = item['avatar'] as String?;
    final comment = (item['comment'] as String?) ?? '';
    final date = item['date'] as String?;
    final verified = item['verified'] == true;
    final rating = (parseDouble(item['rating']) ?? 0).clamp(0, 5).round();

    return Container(
      width: 220,
      padding: EdgeInsets.all(theme.spaceM),
      decoration: BoxDecoration(
        color: theme.surfaceColor,
        borderRadius: BorderRadius.circular(theme.radiusM),
        border: Border.all(color: theme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: theme.borderColor,
                backgroundImage: (avatar == null || avatar.isEmpty) ? null : NetworkImage(avatar),
                child: (avatar == null || avatar.isEmpty)
                    ? Text(
                        author.isEmpty ? '?' : author[0].toUpperCase(),
                        style: theme.captionStyle.copyWith(fontWeight: FontWeight.w600),
                      )
                    : null,
              ),
              SizedBox(width: theme.spaceXs),
              Expanded(
                child: Text(
                  author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.captionStyle.copyWith(fontWeight: FontWeight.w600, color: theme.textPrimaryColor),
                ),
              ),
            ],
          ),
          SizedBox(height: theme.spaceXs),
          Row(
            children: [
              for (var i = 0; i < 5; i++)
                Icon(
                  Icons.star_rounded,
                  size: 14,
                  color: i < rating ? theme.ratingFilledColor : theme.ratingEmptyColor,
                ),
              if (verified) ...[
                SizedBox(width: theme.spaceXs),
                Flexible(
                  child: Text(
                    theme.reviewsVerifiedLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.captionStyle.copyWith(color: theme.discountColor, fontSize: 10),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: theme.spaceXs),
          Expanded(
            child: Text(
              comment,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: theme.captionStyle,
            ),
          ),
          if (date != null) ...[
            SizedBox(height: theme.spaceXs),
            Text(date, style: theme.captionStyle.copyWith(color: theme.textSecondaryColor, fontSize: 10)),
          ],
        ],
      ),
    );
  }
}
