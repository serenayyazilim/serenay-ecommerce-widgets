import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/slide_item.dart';
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
  State<ImageCarouselWidget> createState() => _SerImageCarouselWidgetState();
}

class _SerImageCarouselWidgetState extends State<ImageCarouselWidget> {
  static const double _marginHorizontal = 5.0;

  late final Future<List<SlideItem>> _future = _load();

  Future<List<SlideItem>> _load() {
    final id = widget.params['id'];
    final fetch = widget.callbacks.fetchSlides;
    if (id == null || fetch == null) return Future.value(const []);
    return fetch(id);
  }

  @override
  Widget build(BuildContext context) {
    final heightPercent = (widget.params['height_percent'] as num?)?.toDouble() ?? 0.3;
    final bgImage = widget.params['bg_image'] as String?;
    final itemCount = (widget.params['item_count'] as num?)?.toInt() ?? 2;

    return FutureBuilder<List<SlideItem>>(
      future: _future,
      builder: (context, snapshot) {
        final slides = snapshot.data ?? const [];
        if (slides.isEmpty) return const SizedBox.shrink();

        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = width * heightPercent;
            final itemWidth = ((width - (itemCount * 2 * _marginHorizontal)) / itemCount) - _marginHorizontal;

            return Container(
              height: height,
              decoration: (bgImage == null || bgImage.isEmpty)
                  ? null
                  : BoxDecoration(
                      image: DecorationImage(image: NetworkImage(bgImage), fit: BoxFit.cover),
                    ),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: slides.length,
                itemBuilder: (context, index) => Container(
                  width: itemWidth,
                  margin: const EdgeInsets.symmetric(horizontal: _marginHorizontal),
                  child: GestureDetector(
                    onTap: () => widget.callbacks.onAction(slides[index].action),
                    child: CatalogNetworkImage(url: slides[index].image),
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
