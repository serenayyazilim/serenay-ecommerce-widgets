import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// YOUTUBE: a single YouTube video embedded inline, auto-playing muted and
/// looping.
class YoutubeWidget extends StatefulWidget {
  const YoutubeWidget({super.key, required this.params});

  final Map<String, dynamic> params;

  @override
  State<YoutubeWidget> createState() => _YoutubeWidgetState();
}

class _YoutubeWidgetState extends State<YoutubeWidget> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    final url = widget.params['url'] as String?;
    final videoId = url == null ? null : YoutubePlayerController.convertUrlToId(url);
    if (videoId != null) {
      _controller = YoutubePlayerController.fromVideoId(
        videoId: videoId,
        autoPlay: true,
        params: const YoutubePlayerParams(mute: true, loop: true, showFullscreenButton: false),
      );
    }
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null) return const SizedBox.shrink();

    return Container(
      color: Colors.white,
      height: 300,
      child: YoutubePlayer(controller: controller),
    );
  }
}
