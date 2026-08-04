import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimens.dart';
import 'app_text_styles.dart';

/// A single, host-app-supplied bundle of colors, text styles and sizes that
/// every widget rendered through [WidgetCatalog] reads instead of the
/// hardcoded [AppColors]/[AppDimens]/[AppTextStyles] defaults.
///
/// Pass an instance to `WidgetCatalog.getScreen(theme: ...)` to re-brand the
/// whole catalog (e.g. your app's primary color and fonts) without forking
/// the package. Any field left unset falls back to the package default.
@immutable
class EcommerceWidgetTheme {
  const EcommerceWidgetTheme({
    this.primaryColor = AppColors.primary,
    this.secondaryColor = AppColors.secondary,
    this.discountColor = AppColors.discount,
    this.newBadgeColor = AppColors.newBadge,
    this.outOfStockColor = AppColors.outOfStock,
    this.ratingFilledColor = AppColors.ratingFilled,
    this.ratingEmptyColor = AppColors.ratingEmpty,
    this.surfaceColor = AppColors.surface,
    this.borderColor = AppColors.border,
    this.textPrimaryColor = AppColors.textPrimary,
    this.textSecondaryColor = AppColors.textSecondary,
    this.favoriteActiveColor = AppColors.favoriteActive,
    this.productTitleStyle = AppTextStyles.productTitle,
    this.priceStyle = AppTextStyles.price,
    this.originalPriceStyle = AppTextStyles.originalPrice,
    this.badgeLabelStyle = AppTextStyles.badgeLabel,
    this.buttonLabelStyle = AppTextStyles.buttonLabel,
    this.captionStyle = AppTextStyles.caption,
    this.radiusM = AppDimens.radiusM,
    this.radiusS = AppDimens.radiusS,
    this.radiusL = AppDimens.radiusL,
    this.spaceXs = AppDimens.spaceXs,
    this.spaceS = AppDimens.spaceS,
    this.spaceM = AppDimens.spaceM,
    this.spaceL = AppDimens.spaceL,
    this.buttonHeight = AppDimens.buttonHeight,
    this.iconButtonSize = AppDimens.iconButtonSize,
    this.starSize = AppDimens.starSize,
    this.viewPricesLabel = 'View Prices',
  });

  /// Primary brand color: CTA buttons, "View Prices" link, selected states.
  final Color primaryColor;

  /// Secondary accent color.
  final Color secondaryColor;

  /// Color used for discount/sale badges and struck-through-price prices.
  final Color discountColor;

  /// Color used for "new" badges.
  final Color newBadgeColor;

  /// Color used for "out of stock" badges and disabled states.
  final Color outOfStockColor;

  /// Color used for star ratings when filled.
  final Color ratingFilledColor;

  /// Color used for star ratings when empty.
  final Color ratingEmptyColor;

  /// Default surface/background color for cards and image placeholders.
  final Color surfaceColor;

  /// Default border color for outlined components (cards, pickers).
  final Color borderColor;

  /// Default primary text color (titles).
  final Color textPrimaryColor;

  /// Default secondary/muted text color (subtitles, captions).
  final Color textSecondaryColor;

  /// Color used to indicate a favorite/wishlist active state.
  final Color favoriteActiveColor;

  /// Text style used for product titles.
  final TextStyle productTitleStyle;

  /// Text style used for the current/selling price.
  final TextStyle priceStyle;

  /// Text style used for a struck-through original price next to a discount.
  final TextStyle originalPriceStyle;

  /// Text style used for badge labels (e.g. "New", "-20%").
  final TextStyle badgeLabelStyle;

  /// Text style used for button labels (e.g. "Add to Cart").
  final TextStyle buttonLabelStyle;

  /// Text style used for secondary/muted captions.
  final TextStyle captionStyle;

  /// Corner radius for cards and buttons.
  final double radiusM;

  /// Corner radius for badges and chips.
  final double radiusS;

  /// Corner radius for bottom sheets and prominent surfaces.
  final double radiusL;

  /// Extra-small spacing unit.
  final double spaceXs;

  /// Small spacing unit.
  final double spaceS;

  /// Medium spacing unit.
  final double spaceM;

  /// Large spacing unit.
  final double spaceL;

  /// Height for primary action buttons.
  final double buttonHeight;

  /// Size for icon-only circular buttons (e.g. favorite button).
  final double iconButtonSize;

  /// Size for a single star in a rating widget.
  final double starSize;

  /// Label shown instead of a hidden price when the viewer is logged out.
  final String viewPricesLabel;

  /// Returns a copy of this theme with the given fields replaced.
  EcommerceWidgetTheme copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? discountColor,
    Color? newBadgeColor,
    Color? outOfStockColor,
    Color? ratingFilledColor,
    Color? ratingEmptyColor,
    Color? surfaceColor,
    Color? borderColor,
    Color? textPrimaryColor,
    Color? textSecondaryColor,
    Color? favoriteActiveColor,
    TextStyle? productTitleStyle,
    TextStyle? priceStyle,
    TextStyle? originalPriceStyle,
    TextStyle? badgeLabelStyle,
    TextStyle? buttonLabelStyle,
    TextStyle? captionStyle,
    double? radiusM,
    double? radiusS,
    double? radiusL,
    double? spaceXs,
    double? spaceS,
    double? spaceM,
    double? spaceL,
    double? buttonHeight,
    double? iconButtonSize,
    double? starSize,
    String? viewPricesLabel,
  }) {
    return EcommerceWidgetTheme(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      discountColor: discountColor ?? this.discountColor,
      newBadgeColor: newBadgeColor ?? this.newBadgeColor,
      outOfStockColor: outOfStockColor ?? this.outOfStockColor,
      ratingFilledColor: ratingFilledColor ?? this.ratingFilledColor,
      ratingEmptyColor: ratingEmptyColor ?? this.ratingEmptyColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      borderColor: borderColor ?? this.borderColor,
      textPrimaryColor: textPrimaryColor ?? this.textPrimaryColor,
      textSecondaryColor: textSecondaryColor ?? this.textSecondaryColor,
      favoriteActiveColor: favoriteActiveColor ?? this.favoriteActiveColor,
      productTitleStyle: productTitleStyle ?? this.productTitleStyle,
      priceStyle: priceStyle ?? this.priceStyle,
      originalPriceStyle: originalPriceStyle ?? this.originalPriceStyle,
      badgeLabelStyle: badgeLabelStyle ?? this.badgeLabelStyle,
      buttonLabelStyle: buttonLabelStyle ?? this.buttonLabelStyle,
      captionStyle: captionStyle ?? this.captionStyle,
      radiusM: radiusM ?? this.radiusM,
      radiusS: radiusS ?? this.radiusS,
      radiusL: radiusL ?? this.radiusL,
      spaceXs: spaceXs ?? this.spaceXs,
      spaceS: spaceS ?? this.spaceS,
      spaceM: spaceM ?? this.spaceM,
      spaceL: spaceL ?? this.spaceL,
      buttonHeight: buttonHeight ?? this.buttonHeight,
      iconButtonSize: iconButtonSize ?? this.iconButtonSize,
      starSize: starSize ?? this.starSize,
      viewPricesLabel: viewPricesLabel ?? this.viewPricesLabel,
    );
  }
}
