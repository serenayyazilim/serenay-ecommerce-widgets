import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/widget_action.dart';
import '../../contracts/slide_item.dart';
import '../../core/utils/param_parsing.dart';
import 'catalog_network_image.dart';

/// SLIDER: a scrollable image slider whose slides are fetched by [id].
/// Slides follow the shared tap contract, plus two slider-only targets:
/// `zoom` (full-screen pinch-zoom gallery) and `modal` (fetch popup content
/// and show it in a bottom sheet).
class SliderWidget extends StatefulWidget {
  const SliderWidget({
    super.key,
    required this.params,
    required this.callbacks,
  });

  final Map<String, dynamic> params;
  final WidgetCallbacks callbacks;

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  late final Future<List<SlideItem>> _future = _load();
  final _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<List<SlideItem>> _load() {
    final id = widget.params['id'];
    final fetch = widget.callbacks.fetchSlides;
    if (id == null || fetch == null) return Future.value(const []);
    return fetch(id);
  }

  void _handleTap(List<SlideItem> slides, int index) {
    final action = slides[index].action;
    switch (action.type) {
      case WidgetActionType.zoom:
        showDialog(
          context: context,
          builder: (context) => _ZoomGallery(
            images: slides.map((s) => s.image).toList(),
            initialIndex: index,
          ),
        );
        break;
      case WidgetActionType.modal:
        final fetchModal = widget.callbacks.fetchModal;
        if (fetchModal == null) return;
        fetchModal(action.id).then((image) {
          if (!mounted || image == null) return;
          showModalBottomSheet(
            context: context,
            builder: (context) => CatalogNetworkImage(url: image),
          );
        });
        break;
      default:
        widget.callbacks.onAction(action);
    }
  }

  @override
  Widget build(BuildContext context) {
    final heightPercent = parseDouble(widget.params['height_percent']) ?? 0.3;
    final paddingH = parseDouble(widget.params['padding_horizontal']) ?? 0.0;
    final paddingV = parseDouble(widget.params['padding_vertical']) ?? 0.0;

    return FutureBuilder<List<SlideItem>>(
      future: _future,
      builder: (context, snapshot) {
        final slides = snapshot.data ?? const [];
        if (slides.isEmpty) return const SizedBox.shrink();

        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * paddingH,
                vertical: width * paddingV,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: width * heightPercent,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) => setState(() => _currentPage = index),
                      itemCount: slides.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: GestureDetector(
                          onTap: () => _handleTap(slides, index),
                          child: CatalogNetworkImage(url: slides[index].image),
                        ),
                      ),
                    ),
                  ),
                  if (slides.length > 1)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(slides.length, (index) {
                        final active = index == _currentPage;
                        return Container(
                          width: active ? 7 : 5,
                          height: active ? 7 : 5,
                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: active
                                ? const Color.fromRGBO(0, 0, 0, 0.9)
                                : const Color.fromRGBO(0, 0, 0, 0.4),
                          ),
                        );
                      }),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _ZoomGallery extends StatelessWidget {
  const _ZoomGallery({required this.images, required this.initialIndex});

  final List<String> images;
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: EdgeInsets.zero,
      child: PageView.builder(
        controller: PageController(initialPage: initialIndex),
        itemCount: images.length,
        itemBuilder: (context, index) => InteractiveViewer(
          child: CatalogNetworkImage(url: images[index], fit: BoxFit.contain),
        ),
      ),
    );
  }
}
