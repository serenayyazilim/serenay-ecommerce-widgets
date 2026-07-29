import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';

/// A toggleable heart/favorite (wishlist) icon button with a bounce+rotate
/// "pop" animation on toggle.
///
/// This widget is controlled: the caller owns [isFavorite] and updates it in
/// response to [onChanged].
class FavoriteButton extends StatefulWidget {
  /// Creates a favorite/wishlist toggle button.
  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onChanged,
    this.size = AppDimens.iconButtonSize,
    this.iconSize = 20.0,
    this.activeColor = AppColors.favoriteActive,
    this.inactiveColor = AppColors.textSecondary,
    this.backgroundColor = AppColors.surface,
  });

  /// Whether the product is currently marked as a favorite.
  final bool isFavorite;

  /// Called with the new favorite state when the button is tapped.
  final ValueChanged<bool> onChanged;

  /// Diameter of the circular button surface.
  final double size;

  /// Size of the heart icon.
  final double iconSize;

  /// Icon color when [isFavorite] is true.
  final Color activeColor;

  /// Icon color when [isFavorite] is false.
  final Color inactiveColor;

  /// Background color of the circular button surface.
  final Color backgroundColor;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 600),
    vsync: this,
  );
  late final Animation<double> _scale = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 25),
    TweenSequenceItem(tween: Tween(begin: 1.3, end: 0.9), weight: 25),
    TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.15), weight: 25),
    TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 25),
  ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  late final Animation<double> _rotation = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.17), weight: 25),
    TweenSequenceItem(tween: Tween(begin: -0.17, end: 0.17), weight: 25),
    TweenSequenceItem(tween: Tween(begin: 0.17, end: -0.09), weight: 25),
    TweenSequenceItem(tween: Tween(begin: -0.09, end: 0.0), weight: 25),
  ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.backgroundColor,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          widget.onChanged(!widget.isFavorite);
          _controller.forward(from: 0);
        },
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => Transform.scale(
              scale: _scale.value,
              child: Transform.rotate(angle: _rotation.value, child: child),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Icon(
                widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                key: ValueKey<bool>(widget.isFavorite),
                size: widget.iconSize,
                color: widget.isFavorite ? widget.activeColor : widget.inactiveColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
