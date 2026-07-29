import 'ser_action.dart';

/// A single slide, fetched by id, for SLIDER and IMAGECAROUSEL. Slides share
/// the same tap contract as IMAGE (§1.3 of the widget catalog doc).
class SerSlideItem {
  const SerSlideItem({required this.image, required this.action});

  final String image;
  final SerAction action;

  factory SerSlideItem.fromJson(Map<String, dynamic> json) {
    return SerSlideItem(
      image: (json['url'] as String?) ?? (json['image'] as String?) ?? '',
      action: SerAction.fromParams(json),
    );
  }

  static List<SerSlideItem> listFromJson(dynamic json) {
    final List<dynamic> raw = json is List ? json : const [];
    return raw
        .whereType<Map>()
        .map((e) => SerSlideItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}

/// Content for a MODAL popup fetched by id (the `type: "modal"` tap target,
/// distinct from the MODAL widget's own inline `url`).
class SerModalContent {
  const SerModalContent({required this.image, this.action});

  final String image;
  final SerAction? action;

  factory SerModalContent.fromJson(Map<String, dynamic> json) {
    return SerModalContent(
      image: (json['url'] as String?) ?? (json['image'] as String?) ?? '',
      action: json.containsKey('type') ? SerAction.fromParams(json) : null,
    );
  }
}
