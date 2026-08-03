import 'widget_action.dart';

/// A single playable video, fetched by id, for VIDEOLIST. Follows the same
/// tap contract as IMAGE/SLIDER (§1.3 of the widget catalog doc).
class VideoItem {
  const VideoItem({
    required this.video,
    required this.action,
    this.title,
    this.subtitle,
  });

  /// Direct, playable video URL.
  final String video;

  final WidgetAction action;
  final String? title;
  final String? subtitle;

  factory VideoItem.fromJson(Map<String, dynamic> json) {
    return VideoItem(
      video: (json['video'] as String?) ?? (json['url'] as String?) ?? '',
      action: WidgetAction.fromParams(json),
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
    );
  }

  static List<VideoItem> listFromJson(dynamic json) {
    final List<dynamic> raw = json is List ? json : const [];
    return raw
        .whereType<Map>()
        .map((e) => VideoItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
