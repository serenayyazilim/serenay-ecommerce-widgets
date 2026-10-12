import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/slide_item.dart';
import '../../core/utils/param_parsing.dart';
import 'catalog_network_image.dart';

/// IMAGECAROUSEL: like SLIDER but with an optional background image behind
/// a flat horizontally-scrolling row of slides (one at a time, not paged in
/// groups), each sized from `item_count`. No `zoom`/`modal` handling — every
/// tap goes through the default action resolver.
class ImageCarouselWidget extends StatefulWidget {
  const ImageCarouselWidget({
    super.key,
    required this.params,
    required this.callbacks,
  });

  final Map<String, dynamic> params;
  final WidgetCallbacks callbacks;

  @override
  State<ImageCarouselWidget> createState() => _ImageCarouselWidgetState();
}

class _ImageCarouselWidgetState extends State<ImageCarouselWidget> {
  late final Future<List<SlideItem>> _future = _load();

  Future<List<SlideItem>> _load() {
    final id = widget.params['id'];
    final fetch = widget.callbacks.fetchSlides;
    if (id == null || fetch == null) return Future.value(const []);
    return fetch(id);
  }

  @override
  Widget build(BuildContext context) {
    final heightPercent = parseDouble(widget.params['height_percent']) ?? 0.3;
    final bgImage = widget.params['bg_image']?.toString();
    final parsedItemCount = parseDouble(widget.params['item_count']) ?? 2;
    final itemCount = parsedItemCount > 0 ? parsedItemCount : 2;
    final fit = parseBoxFit(widget.params['fit']);
    final bgFit = parseBoxFit(widget.params['bg_fit']);
    final itemMargin = parseDouble(widget.params['item_margin_horizontal']) ?? 5.0;
    final itemWidthOffset = parseDouble(widget.params['item_width_offset']) ?? itemMargin;
    final paddingH = parseDouble(widget.params['padding_horizontal']) ?? 0.0;
    final paddingV = parseDouble(widget.params['padding_vertical']) ?? 0.0;
    final radius = parseDouble(widget.params['radius']) ?? 0.0;

    return FutureBuilder<List<SlideItem>>(
      future: _future,
      builder: (context, snapshot) {
        final slides = snapshot.data ?? const [];
        if (slides.isEmpty) return const SizedBox.shrink();

        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = width * heightPercent;
            final rowWidth = width * (1 - 2 * paddingH);
            final itemWidth = ((rowWidth - (itemCount * 2 * itemMargin)) / itemCount) - itemWidthOffset;

            return Container(
              height: height + 2 * width * paddingV,
              padding: EdgeInsets.symmetric(
                horizontal: width * paddingH,
                vertical: width * paddingV,
              ),
              decoration: (bgImage == null || bgImage.isEmpty)
                  ? null
                  : BoxDecoration(
                      image: DecorationImage(image: NetworkImage(bgImage), fit: bgFit),
                    ),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: slides.length,
                itemBuilder: (context, index) => Container(
                  width: itemWidth > 0 ? itemWidth : 0,
                  margin: EdgeInsets.symmetric(horizontal: itemMargin),
                  child: GestureDetector(
                    onTap: () => widget.callbacks.onAction(slides[index].action),
                    child: CatalogNetworkImage(
                      url: slides[index].image,
                      fit: fit,
                      borderRadius: radius > 0 ? BorderRadius.circular(radius) : null,
                      errorBuilder: widget.callbacks.imageErrorBuilder,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
