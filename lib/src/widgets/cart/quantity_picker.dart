import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/theme/app_text_styles.dart';

/// A stepper control for choosing an item quantity, typically used for a
/// cart line item ("- 2 +").
///
/// This widget is stateless and controlled: the caller owns [quantity] and
/// updates it in response to [onChanged].
class QuantityPicker extends StatelessWidget {
  /// Creates a quantity picker.
  const QuantityPicker({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.minQuantity = 1,
    this.maxQuantity = 99,
    this.step = 1,
    this.borderColor = AppColors.border,
    this.iconColor = AppColors.textPrimary,
    this.textStyle = AppTextStyles.productTitle,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(AppDimens.radiusS),
    ),
    this.buttonSize = 32.0,
  }) : assert(minQuantity <= maxQuantity, 'minQuantity must be <= maxQuantity');

  /// The current quantity value.
  final int quantity;

  /// Called with the new quantity when the user taps the increment or
  /// decrement control. Never called with a value outside
  /// [minQuantity]..[maxQuantity].
  final ValueChanged<int> onChanged;

  /// The smallest selectable quantity. The decrement button is disabled at
  /// this value.
  final int minQuantity;

  /// The largest selectable quantity. The increment button is disabled at
  /// this value.
  final int maxQuantity;

  /// The amount [quantity] changes by on each tap.
  final int step;

  /// Border color of the picker container.
  final Color borderColor;

  /// Color of the increment/decrement icons.
  final Color iconColor;

  /// Text style used for the quantity value.
  final TextStyle textStyle;

  /// Corner radius of the picker container.
  final BorderRadiusGeometry borderRadius;

  /// Size (width and height) of each tap target.
  final double buttonSize;

  bool get _canDecrement => quantity - step >= minQuantity;
  bool get _canIncrement => quantity + step <= maxQuantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: borderRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStepButton(
            icon: Icons.remove,
            enabled: _canDecrement,
            onTap: () => onChanged(quantity - step),
          ),
          SizedBox(
            width: buttonSize,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: textStyle,
            ),
          ),
          _buildStepButton(
            icon: Icons.add,
            enabled: _canIncrement,
            onTap: () => onChanged(quantity + step),
          ),
        ],
      ),
    );
  }

  Widget _buildStepButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return Material(
      type: MaterialType.transparency,
      child: SizedBox(
        width: buttonSize,
        height: buttonSize,
        child: InkWell(
          onTap: enabled ? onTap : null,
          child: Icon(
            icon,
            size: 16,
            color: enabled ? iconColor : AppColors.outOfStock,
          ),
        ),
      ),
    );
  }
}
