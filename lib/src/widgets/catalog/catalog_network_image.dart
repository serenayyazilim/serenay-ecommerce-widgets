import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// A network image that falls back to a placeholder icon instead of
/// crashing/erroring when it fails to load — the graceful-degradation
/// pattern every backend-driven widget follows for images (§2 of the widget
/// catalog doc).
class CatalogNetworkImage extends StatelessWidget {
  const CatalogNetworkImage({
    super.key,
    required this.url,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final String url;
  final double? height;
  final double? width;
  final BoxFit fit;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    final Widget image = url.isEmpty
        ? _placeholder()
        : Image.network(
            url,
            height: height,
            width: width,
            fit: fit,
            errorBuilder: (context, error, stackTrace) => _placeholder(),
          );

    if (borderRadius == null) return image;
    return ClipRRect(borderRadius: borderRadius!, child: image);
  }

  Widget _placeholder() {
    return Container(
      height: height,
      width: width,
      color: AppColors.border,
      alignment: Alignment.center,
      child: const Icon(Icons.image_not_supported_outlined,
          color: AppColors.textSecondary),
    );
  }
}
