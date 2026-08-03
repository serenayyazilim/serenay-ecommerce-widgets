import 'widget_action.dart';

/// A single slide, fetched by id, for SLIDER and IMAGECAROUSEL. Slides share
/// the same tap contract as IMAGE (§1.3 of the widget catalog doc).
class SlideItem {
  const SlideItem({required this.image, required this.action});

  final String image;
  final WidgetAction action;

  factory SlideItem.fromJson(Map<String, dynamic> json) {
    return SlideItem(
      image: (json['url'] as String?) ?? (json['image'] as String?) ?? '',
      action: WidgetAction.fromParams(json),
    );
  }

  static List<SlideItem> listFromJson(dynamic json) {
    final List<dynamic> raw = json is List ? json : const [];
    return raw
        .whereType<Map>()
        .map((e) => SlideItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}

/// Content for a MODAL popup fetched by id (the `type: "modal"` tap target,
/// distinct from the MODAL widget's own inline `url`).
class ModalContent {
  const ModalContent({required this.image, this.action});

  final String image;
  final WidgetAction? action;

  factory ModalContent.fromJson(Map<String, dynamic> json) {
    return ModalContent(
      image: (json['url'] as String?) ?? (json['image'] as String?) ?? '',
      action: json.containsKey('type') ? WidgetAction.fromParams(json) : null,
    );
  }
}
