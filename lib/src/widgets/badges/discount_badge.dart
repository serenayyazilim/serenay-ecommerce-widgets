import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// A small badge showing a discount percentage as "%X" with a tag icon,
/// overlaid on the top-left corner of a product card image.
class DiscountBadge extends StatelessWidget {
  /// Creates a discount badge from a percentage value (0-100).
  const DiscountBadge({
    super.key,
    required this.percentage,
    this.backgroundColor = AppColors.discount,
    this.label,
  }) : assert(percentage >= 0, 'percentage must not be negative');

  /// The discount percentage to display, e.g. `20` renders "%20".
  final int percentage;

  /// Background color of the badge.
  final Color backgroundColor;

  /// Optional custom label overriding the default "%{percentage}" text.
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_offer_rounded, size: 11, color: Colors.white),
          const SizedBox(width: 3),
          Text(
            label ?? '%$percentage',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
