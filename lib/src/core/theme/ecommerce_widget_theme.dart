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
    this.fastRegisterAccentColor = AppColors.whatsappGreen,
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
    this.gridColumns = 2,
    this.favoriteAnimationDuration = const Duration(milliseconds: 600),
    this.flashSaleBorderDuration = const Duration(milliseconds: 5500),
    this.storyAutoAdvanceDuration = const Duration(seconds: 3),
    this.viewPricesLabel = 'View Prices',
    this.notAvailableForSaleLabel = 'Not available for sale',
    this.addToCartLabel = 'Add to Cart',
    this.variantColorLabel = 'Color',
    this.recentlyViewedLabel = 'Recently Viewed',
    this.searchHintLabel = 'Search products...',
    this.searchButtonLabel = 'Search',
    this.flashSaleTitleLabel = 'Flash Sale',
    this.flashSaleTimeUpLabel = "Time's up",
    this.fastRegisterHeaderLabel = 'WHATSAPP',
    this.fastRegisterSendLabel = 'Send',
    this.fastRegisterTitleLabel = 'Quick Registration System',
    this.fastRegisterSubtitleLabel = 'Register quickly via WhatsApp in 3 steps.',
    this.fastRegisterStep1Label = 'Enter Your\nNumber',
    this.fastRegisterStep2Label = 'Send the\nReceived Code',
    this.fastRegisterStep3Label = 'Talk to a\nRepresentative',
    this.fastRegisterLaunchFailedLabel = "Couldn't open WhatsApp",
    this.preOrderLabel = 'Pre-order',
    this.quickAddLabel = 'Add',
    this.bundleTitleLabel = 'Frequently Bought Together',
    this.addAllToCartLabel = 'Add All to Cart',
    this.couponCopyLabel = 'Copy',
    this.couponCopiedLabel = 'Copied!',
    this.abandonedCartTitleLabel = 'You left items in your cart',
    this.abandonedCartReservedLabel = 'Reserved for',
    this.abandonedCartCtaLabel = 'Complete your order',
    this.reviewsTitleLabel = 'Customer Reviews',
    this.reviewsVerifiedLabel = 'Verified Purchase',
    this.qnaTitleLabel = 'Questions & Answers',
    this.urgencyStockLabel = 'Only {count} left in stock!',
    this.recommendedForYouTitleLabel = 'Recommended For You',
    this.socialProofLabel = '{count} people bought this recently',
    this.sizeGuideButtonLabel = 'Size Guide',
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

  /// Border/text/header background color for the FASTREGISTER card.
  final Color fastRegisterAccentColor;

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

  /// Number of columns for GRID/PRODUCTCARD's product grid. Overridden per
  /// entry by a `"columns"` params value when the backend sends one.
  final int gridColumns;

  /// Duration of the favorite-button "pop" animation.
  final Duration favoriteAnimationDuration;

  /// Duration of one loop of the FLASHSALE countdown border animation.
  final Duration flashSaleBorderDuration;

  /// How long a STORY page shows before auto-advancing to the next one.
  final Duration storyAutoAdvanceDuration;

  /// Label shown instead of a hidden price when the viewer is logged out.
  final String viewPricesLabel;

  /// Fallback shown in the variant sheet when a product can't be sold and
  /// the backend didn't send a specific reason.
  final String notAvailableForSaleLabel;

  /// Label for the "Add to Cart" button in the variant sheet.
  final String addToCartLabel;

  /// Word used after the variant count in the variant sheet header (e.g.
  /// "3 Color").
  final String variantColorLabel;

  /// Header shown above the VISITEDPRODUCTS row.
  final String recentlyViewedLabel;

  /// Fallback SEARCH input hint when the backend doesn't send `hint_text`.
  final String searchHintLabel;

  /// Label for the SEARCH widget's submit button.
  final String searchButtonLabel;

  /// Fallback FLASHSALE title when the backend doesn't send `title`.
  final String flashSaleTitleLabel;

  /// Shown in the FLASHSALE modal once the countdown has expired.
  final String flashSaleTimeUpLabel;

  /// Header text on the FASTREGISTER card.
  final String fastRegisterHeaderLabel;

  /// Submit button label on the FASTREGISTER card.
  final String fastRegisterSendLabel;

  /// Title text on the FASTREGISTER card.
  final String fastRegisterTitleLabel;

  /// Subtitle text on the FASTREGISTER card.
  final String fastRegisterSubtitleLabel;

  /// First step label on the FASTREGISTER card.
  final String fastRegisterStep1Label;

  /// Second step label on the FASTREGISTER card.
  final String fastRegisterStep2Label;

  /// Third step label on the FASTREGISTER card.
  final String fastRegisterStep3Label;

  /// Snackbar message shown when the FASTREGISTER card can't launch
  /// WhatsApp (e.g. it isn't installed).
  final String fastRegisterLaunchFailedLabel;

  /// Banner shown on OldProductCard (GRID) when a product is
  /// pre-order-only.
  final String preOrderLabel;

  /// Label for OldProductCard's compact "add one at the default measure"
  /// pill, shown next to the measure-picker button when the product has
  /// [ProductCardData.measureOptions].
  final String quickAddLabel;

  /// Header shown above the BUNDLE widget's product row.
  final String bundleTitleLabel;

  /// Label for the BUNDLE widget's "add every item at once" button.
  final String addAllToCartLabel;

  /// Label for the COUPON widget's copy-code button/icon before it's tapped.
  final String couponCopyLabel;

  /// Label shown briefly on the COUPON widget after its code is copied.
  final String couponCopiedLabel;

  /// Fallback ABANDONEDCART header when the backend doesn't send `title`.
  final String abandonedCartTitleLabel;

  /// Prefix shown before the ABANDONEDCART countdown (e.g. "Reserved for
  /// 09:58").
  final String abandonedCartReservedLabel;

  /// Label for the ABANDONEDCART widget's checkout/cart CTA button.
  final String abandonedCartCtaLabel;

  /// Fallback REVIEWS header when the backend doesn't send `title`.
  final String reviewsTitleLabel;

  /// Badge label shown on a REVIEWS entry whose `verified` field is true.
  final String reviewsVerifiedLabel;

  /// Fallback QNA header when the backend doesn't send `title`.
  final String qnaTitleLabel;

  /// Template for URGENCY's low-stock text; `{count}` is replaced with
  /// `params['stock_left']` when the backend doesn't send its own `text`.
  final String urgencyStockLabel;

  /// Fallback RECOMMENDEDFORYOU header when the backend doesn't send
  /// `title`.
  final String recommendedForYouTitleLabel;

  /// Template for SOCIALPROOF's purchase-count text; `{count}` is replaced
  /// with `params['count']` when the backend doesn't send its own `text`.
  final String socialProofLabel;

  /// Label for the SIZEGUIDE widget's trigger button, and its dialog title
  /// when the backend doesn't send its own `title`.
  final String sizeGuideButtonLabel;

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
    Color? fastRegisterAccentColor,
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
    int? gridColumns,
    Duration? favoriteAnimationDuration,
    Duration? flashSaleBorderDuration,
    Duration? storyAutoAdvanceDuration,
    String? viewPricesLabel,
    String? notAvailableForSaleLabel,
    String? addToCartLabel,
    String? variantColorLabel,
    String? recentlyViewedLabel,
    String? searchHintLabel,
    String? searchButtonLabel,
    String? flashSaleTitleLabel,
    String? flashSaleTimeUpLabel,
    String? fastRegisterHeaderLabel,
    String? fastRegisterSendLabel,
    String? fastRegisterTitleLabel,
    String? fastRegisterSubtitleLabel,
    String? fastRegisterStep1Label,
    String? fastRegisterStep2Label,
    String? fastRegisterStep3Label,
    String? fastRegisterLaunchFailedLabel,
    String? preOrderLabel,
    String? quickAddLabel,
    String? bundleTitleLabel,
    String? addAllToCartLabel,
    String? couponCopyLabel,
    String? couponCopiedLabel,
    String? abandonedCartTitleLabel,
    String? abandonedCartReservedLabel,
    String? abandonedCartCtaLabel,
    String? reviewsTitleLabel,
    String? reviewsVerifiedLabel,
    String? qnaTitleLabel,
    String? urgencyStockLabel,
    String? recommendedForYouTitleLabel,
    String? socialProofLabel,
    String? sizeGuideButtonLabel,
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
      fastRegisterAccentColor: fastRegisterAccentColor ?? this.fastRegisterAccentColor,
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
      gridColumns: gridColumns ?? this.gridColumns,
      favoriteAnimationDuration: favoriteAnimationDuration ?? this.favoriteAnimationDuration,
      flashSaleBorderDuration: flashSaleBorderDuration ?? this.flashSaleBorderDuration,
      storyAutoAdvanceDuration: storyAutoAdvanceDuration ?? this.storyAutoAdvanceDuration,
      viewPricesLabel: viewPricesLabel ?? this.viewPricesLabel,
      notAvailableForSaleLabel: notAvailableForSaleLabel ?? this.notAvailableForSaleLabel,
      addToCartLabel: addToCartLabel ?? this.addToCartLabel,
      variantColorLabel: variantColorLabel ?? this.variantColorLabel,
      recentlyViewedLabel: recentlyViewedLabel ?? this.recentlyViewedLabel,
      searchHintLabel: searchHintLabel ?? this.searchHintLabel,
      searchButtonLabel: searchButtonLabel ?? this.searchButtonLabel,
      flashSaleTitleLabel: flashSaleTitleLabel ?? this.flashSaleTitleLabel,
      flashSaleTimeUpLabel: flashSaleTimeUpLabel ?? this.flashSaleTimeUpLabel,
      fastRegisterHeaderLabel: fastRegisterHeaderLabel ?? this.fastRegisterHeaderLabel,
      fastRegisterSendLabel: fastRegisterSendLabel ?? this.fastRegisterSendLabel,
      fastRegisterTitleLabel: fastRegisterTitleLabel ?? this.fastRegisterTitleLabel,
      fastRegisterSubtitleLabel: fastRegisterSubtitleLabel ?? this.fastRegisterSubtitleLabel,
      fastRegisterStep1Label: fastRegisterStep1Label ?? this.fastRegisterStep1Label,
      fastRegisterStep2Label: fastRegisterStep2Label ?? this.fastRegisterStep2Label,
      fastRegisterStep3Label: fastRegisterStep3Label ?? this.fastRegisterStep3Label,
      fastRegisterLaunchFailedLabel: fastRegisterLaunchFailedLabel ?? this.fastRegisterLaunchFailedLabel,
      preOrderLabel: preOrderLabel ?? this.preOrderLabel,
      quickAddLabel: quickAddLabel ?? this.quickAddLabel,
      bundleTitleLabel: bundleTitleLabel ?? this.bundleTitleLabel,
      addAllToCartLabel: addAllToCartLabel ?? this.addAllToCartLabel,
      couponCopyLabel: couponCopyLabel ?? this.couponCopyLabel,
      couponCopiedLabel: couponCopiedLabel ?? this.couponCopiedLabel,
      abandonedCartTitleLabel: abandonedCartTitleLabel ?? this.abandonedCartTitleLabel,
      abandonedCartReservedLabel: abandonedCartReservedLabel ?? this.abandonedCartReservedLabel,
      abandonedCartCtaLabel: abandonedCartCtaLabel ?? this.abandonedCartCtaLabel,
      reviewsTitleLabel: reviewsTitleLabel ?? this.reviewsTitleLabel,
      reviewsVerifiedLabel: reviewsVerifiedLabel ?? this.reviewsVerifiedLabel,
      qnaTitleLabel: qnaTitleLabel ?? this.qnaTitleLabel,
      urgencyStockLabel: urgencyStockLabel ?? this.urgencyStockLabel,
      recommendedForYouTitleLabel: recommendedForYouTitleLabel ?? this.recommendedForYouTitleLabel,
      socialProofLabel: socialProofLabel ?? this.socialProofLabel,
      sizeGuideButtonLabel: sizeGuideButtonLabel ?? this.sizeGuideButtonLabel,
    );
  }
}
