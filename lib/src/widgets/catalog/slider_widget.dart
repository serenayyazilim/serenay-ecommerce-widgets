import 'package:flutter/material.dart';

import '../../callbacks/ser_builder_callbacks.dart';
import '../../contracts/ser_action.dart';
import '../../contracts/ser_slide_item.dart';
import 'ser_network_image.dart';

/// SLIDER: a scrollable image slider whose slides are fetched by [id].
/// Slides follow the shared tap contract, plus two slider-only targets:
/// `zoom` (full-screen pinch-zoom gallery) and `modal` (fetch popup content
/// and show it in a bottom sheet).
class SerSliderWidget extends StatefulWidget {
  const SerSliderWidget({
    super.key,
    required this.params,
    required this.callbacks,
  });

  final Map<String, dynamic> params;
  final SerBuilderCallbacks callbacks;

  @override
  State<SerSliderWidget> createState() => _SerSliderWidgetState();
}

class _SerSliderWidgetState extends State<SerSliderWidget> {
  late final Future<List<SerSlideItem>> _future = _load();
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<List<SerSlideItem>> _load() {
    final id = widget.params['id'];
    final fetch = widget.callbacks.fetchSlides;
    if (id == null || fetch == null) return Future.value(const []);
    return fetch(id);
  }

  void _handleTap(List<SerSlideItem> slides, int index) {
    final action = slides[index].action;
    switch (action.type) {
      case SerActionType.zoom:
        showDialog(
          context: context,
          builder: (context) => _ZoomGallery(
            images: slides.map((s) => s.image).toList(),
            initialIndex: index,
          ),
        );
        break;
      case SerActionType.modal:
        final fetchModal = widget.callbacks.fetchModal;
        if (fetchModal == null) return;
        fetchModal(action.id).then((image) {
          if (!mounted || image == null) return;
          showModalBottomSheet(
            context: context,
            builder: (context) => SerNetworkImage(url: image),
          );
        });
        break;
      default:
        widget.callbacks.onAction(action);
    }
  }

  @override
  Widget build(BuildContext context) {
    final heightPercent = (widget.params['height_percent'] as num?)?.toDouble() ?? 0.3;
    final paddingH = (widget.params['padding_horizontal'] as num?)?.toDouble() ?? 0.0;
    final paddingV = (widget.params['padding_vertical'] as num?)?.toDouble() ?? 0.0;

    return FutureBuilder<List<SerSlideItem>>(
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
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () => _handleTap(slides, index),
                        child: SerNetworkImage(url: slides[index].image),
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
          child: SerNetworkImage(url: images[index], fit: BoxFit.contain),
        ),
      ),
    );
  }
}
