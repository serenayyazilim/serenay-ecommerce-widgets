import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Default text styles used across the e-commerce widget kit.
///
/// Any widget in this package that renders text accepts a [TextStyle]
/// override; these are only the fallback defaults.
class AppTextStyles {
  const AppTextStyles._();

  /// Style used for product titles.
  static const TextStyle productTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// Style used for the current/selling price.
  static const TextStyle price = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  /// Style used for a struck-through original price next to a discount.
  static const TextStyle originalPrice = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    decoration: TextDecoration.lineThrough,
  );

  /// Style used for badge labels (e.g. "New", "-20%").
  static const TextStyle badgeLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  /// Style used for button labels.
  static const TextStyle buttonLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  /// Style used for secondary/muted captions (e.g. review counts).
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
}
