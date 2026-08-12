import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/video_item.dart';
import '../../core/utils/param_parsing.dart';
import 'muted_loop_video.dart';

/// VIDEOLIST: one or more silent, looping, auto-playing videos fetched by
/// [id]. A single video renders full-width with an optional `textparams`
/// title/subtitle overlay (custom color/size/weight/alignment); multiple
/// videos scroll in a row/column per `scroll_direction`.
class VideoListWidget extends StatefulWidget {
  const VideoListWidget({
    super.key,
    required this.params,
    required this.callbacks,
  });

  final Map<String, dynamic> params;
  final WidgetCallbacks callbacks;

  @override
  State<VideoListWidget> createState() => _VideoListWidgetState();
}

class _VideoListWidgetState extends State<VideoListWidget> {
  late final Future<List<VideoItem>> _future = _load();

  Map<String, dynamic>? get _textParams {
    final raw = widget.params['textparams'];
    return raw is Map ? Map<String, dynamic>.from(raw) : null;
  }

  Future<List<VideoItem>> _load() {
    final id = widget.params['id'];
    final fetch = widget.callbacks.fetchVideos;
    if (id == null || fetch == null) return Future.value(const []);
    return fetch(id);
  }

  double _pd(String key, double fallback) => parseDouble(widget.params[key]) ?? fallback;

  Axis _scrollDirection() =>
      widget.params['scroll_direction'] == 'horizontal' ? Axis.horizontal : Axis.vertical;

  FontWeight _fontWeight(String? value) {
    switch (value) {
      case 'bold':
        return FontWeight.bold;
      case 'regular':
        return FontWeight.w300;
      default:
        return FontWeight.normal;
    }
  }

  CrossAxisAlignment _crossAlign(String? horizontal) {
    switch (horizontal) {
      case 'left':
        return CrossAxisAlignment.start;
      case 'right':
        return CrossAxisAlignment.end;
      default:
        return CrossAxisAlignment.center;
    }
  }

  MainAxisAlignment _mainAlign(String? vertical) {
    switch (vertical) {
      case 'top':
        return MainAxisAlignment.start;
      case 'bottom':
        return MainAxisAlignment.end;
      default:
        return MainAxisAlignment.center;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<VideoItem>>(
      future: _future,
      builder: (context, snapshot) {
        final videos = snapshot.data ?? const [];
        if (videos.isEmpty) return const SizedBox.shrink();

        if (videos.length == 1) return _buildSingle(context, videos.first);
        return _buildList(context, videos);
      },
    );
  }

  Widget _buildSingle(BuildContext context, VideoItem video) {
    final textParams = _textParams;
    final width = MediaQuery.of(context).size.width * _pd('width_percent', 1.0);
    final height = MediaQuery.of(context).size.height * _pd('height_percent', 0.3);

    return GestureDetector(
      onTap: () => widget.callbacks.onAction(video.action),
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            MutedLoopVideo(url: video.video),
            if (video.title != null)
              Container(
                width: width,
                height: height,
                color: textParams != null ? Colors.black.withValues(alpha: 0.3) : Colors.transparent,
                child: textParams == null
                    ? null
                    : Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: _crossAlign(textParams['horizontal'] as String?),
                          mainAxisAlignment: _mainAlign(textParams['vertical'] as String?),
                          children: [
                            Text(
                              video.title!,
                              style: TextStyle(
                                height: 1.1,
                                color: _parseColor(textParams['fontcolor_title'] as String?),
                                fontSize: parseDouble(textParams['fontsize_title']) ?? 16,
                                fontWeight: _fontWeight(textParams['fontweight_title'] as String?),
                              ),
                            ),
                            if (video.subtitle != null)
                              Text(
                                video.subtitle!,
                                style: TextStyle(
                                  color: _parseColor(textParams['fontcolor_subtitle'] as String?),
                                  fontSize: parseDouble(textParams['fontsize_subtitle']) ?? 13,
                                  fontWeight: _fontWeight(textParams['fontweight_subtitle'] as String?),
                                ),
                              ),
                          ],
                        ),
                      ),
              ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return Colors.white;
    final value = int.tryParse('FF${hex.replaceFirst('#', '')}', radix: 16);
    return value != null ? Color(value) : Colors.white;
  }

  Widget _buildList(BuildContext context, List<VideoItem> videos) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height * _pd('container_height', 0.3),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: _scrollDirection(),
        itemCount: videos.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => widget.callbacks.onAction(videos[index].action),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _pd('horizontal_padding', 3),
              vertical: _pd('vertical_padding', 4),
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * _pd('width_percent', 1.0),
              height: MediaQuery.of(context).size.height * _pd('height_percent', 0.3),
              child: MutedLoopVideo(url: videos[index].video),
            ),
          ),
        ),
      ),
    );
  }
}

