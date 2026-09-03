import 'package:flutter/material.dart';

import '../../core/theme/ecommerce_widget_theme.dart';

/// QNA: a vertical "Questions & Answers" list — each entry's question and
/// answer, plus an optional asker name/date. Reads its entries straight
/// from `params['list']` (no fetch callback), the same inline-list contract
/// as CATEGORYMENU/REVIEWS.
class QnaWidget extends StatelessWidget {
  const QnaWidget({
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

    final title = (params['title'] as String?) ?? theme.qnaTitleLabel;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: theme.spaceM, vertical: theme.spaceS),
      child: Container(
        padding: EdgeInsets.all(theme.spaceM),
        decoration: BoxDecoration(
          color: theme.surfaceColor,
          borderRadius: BorderRadius.circular(theme.radiusM),
          border: Border.all(color: theme.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.productTitleStyle.copyWith(fontSize: 15)),
            SizedBox(height: theme.spaceS),
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0) ...[
                SizedBox(height: theme.spaceS),
                Divider(height: 1, color: theme.borderColor),
                SizedBox(height: theme.spaceS),
              ],
              _QnaEntry(item: items[i], theme: theme),
            ],
          ],
        ),
      ),
    );
  }
}

class _QnaEntry extends StatelessWidget {
  const _QnaEntry({required this.item, required this.theme});

  final Map<String, dynamic> item;
  final EcommerceWidgetTheme theme;

  @override
  Widget build(BuildContext context) {
    final question = (item['question'] as String?) ?? '';
    final answer = (item['answer'] as String?) ?? '';
    final author = item['author'] as String?;
    final date = item['date'] as String?;
    if (question.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.help_outline, size: 16, color: theme.textSecondaryColor),
            SizedBox(width: theme.spaceXs),
            Expanded(
              child: Text(
                question,
                style: theme.captionStyle.copyWith(fontWeight: FontWeight.w600, color: theme.textPrimaryColor),
              ),
            ),
          ],
        ),
        if (answer.isNotEmpty) ...[
          SizedBox(height: theme.spaceXs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.subdirectory_arrow_right, size: 16, color: theme.textSecondaryColor),
              SizedBox(width: theme.spaceXs),
              Expanded(child: Text(answer, style: theme.captionStyle)),
            ],
          ),
        ],
        if (author != null || date != null) ...[
          SizedBox(height: theme.spaceXs),
          Padding(
            padding: const EdgeInsets.only(left: 22),
            child: Text(
              [?author, ?date].join(' · '),
              style: theme.captionStyle.copyWith(color: theme.textSecondaryColor, fontSize: 10),
            ),
          ),
        ],
      ],
    );
  }
}
