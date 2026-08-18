import 'package:flutter/material.dart';

import '../../core/theme/ecommerce_widget_theme.dart';
import '../../core/utils/param_parsing.dart';

/// LOYALTYPROGRESS: a "N more to go" progress bar (e.g. purchases toward a
/// loyalty reward, or spend toward free shipping) — `current`/`target` drive
/// a clamped [LinearProgressIndicator] styled from the theme, with an
/// optional title and reward caption.
class LoyaltyProgressWidget extends StatelessWidget {
  const LoyaltyProgressWidget({
    super.key,
    required this.params,
    this.theme = const EcommerceWidgetTheme(),
  });

  final Map<String, dynamic> params;
  final EcommerceWidgetTheme theme;

  @override
  Widget build(BuildContext context) {
    final target = parseDouble(params['target']) ?? 0;
    if (target <= 0) return const SizedBox.shrink();

    final current = (parseDouble(params['current']) ?? 0).clamp(0, target);
    final title = params['title'] as String?;
    final rewardText = params['reward_text'] as String?;
    final progress = current / target;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: theme.spaceM, vertical: theme.spaceS),
      child: Container(
        padding: EdgeInsets.all(theme.spaceM),
        decoration: BoxDecoration(
          color: theme.surfaceColor,
          borderRadius: BorderRadius.circular(theme.radiusM),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(title, style: theme.productTitleStyle.copyWith(fontSize: 14)),
              SizedBox(height: theme.spaceS),
            ],
            ClipRRect(
              borderRadius: BorderRadius.circular(theme.radiusS),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: theme.borderColor,
                color: theme.primaryColor,
              ),
            ),
            if (rewardText != null) ...[
              SizedBox(height: theme.spaceXs),
              Text(rewardText, style: theme.captionStyle),
            ],
          ],
        ),
      ),
    );
  }
}
