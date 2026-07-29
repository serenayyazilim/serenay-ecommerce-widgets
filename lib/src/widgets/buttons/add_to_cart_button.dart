import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/theme/app_text_styles.dart';

/// A production-ready "Add to Cart" / "Buy Now" style call-to-action button.
///
/// Supports a loading state (e.g. while the add-to-cart request is in
/// flight) and a disabled state (e.g. product out of stock).
class AddToCartButton extends StatelessWidget {
  /// Creates an add-to-cart button.
  const AddToCartButton({
    super.key,
    required this.onPressed,
    this.label = 'Add to Cart',
    this.icon = Icons.shopping_cart_outlined,
    this.backgroundColor = AppColors.primary,
    this.textStyle = AppTextStyles.buttonLabel,
    this.height = AppDimens.buttonHeight,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(AppDimens.radiusM),
    ),
    this.isLoading = false,
    this.isEnabled = true,
  });

  /// Called when the button is tapped. Ignored while [isLoading] is true or
  /// [isEnabled] is false.
  final VoidCallback onPressed;

  /// Text label shown on the button.
  final String label;

  /// Leading icon shown before [label]. Pass `null` to hide it.
  final IconData? icon;

  /// Background color of the button when enabled.
  final Color backgroundColor;

  /// Text style used for [label].
  final TextStyle textStyle;

  /// Height of the button.
  final double height;

  /// Corner radius of the button.
  final BorderRadiusGeometry borderRadius;

  /// Whether to show a loading spinner instead of the label/icon.
  final bool isLoading;

  /// Whether the button can be pressed. When false, the button is rendered
  /// with a muted color and taps are ignored.
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final bool enabled = isEnabled && !isLoading;

    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          disabledBackgroundColor: AppColors.outOfStock,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: textStyle.color ?? Colors.white,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18, color: textStyle.color),
                    SizedBox(width: AppDimens.spaceXs + AppDimens.spaceXs),
                  ],
                  Text(label, style: textStyle),
                ],
              ),
      ),
    );
  }
}
