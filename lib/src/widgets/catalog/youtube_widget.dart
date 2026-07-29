import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// YOUTUBE: a single YouTube video embedded inline, auto-playing muted and
/// looping.
class SerYoutubeWidget extends StatefulWidget {
  const SerYoutubeWidget({super.key, required this.params});

  final Map<String, dynamic> params;

  @override
  State<SerYoutubeWidget> createState() => _SerYoutubeWidgetState();
}

class _SerYoutubeWidgetState extends State<SerYoutubeWidget> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    final url = widget.params['url'] as String?;
    final videoId = url == null ? null : YoutubePlayer.convertUrlToId(url);
    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(autoPlay: true, mute: true, loop: true),
      );
    }
  }

  @override
  void dispose() {
    _controller?.pause();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null) return const SizedBox.shrink();

    return Container(
      color: Colors.white,
      height: 300,
      child: YoutubePlayer(
        controller: controller,
        showVideoProgressIndicator: false,
        progressIndicatorColor: Colors.amber,
        progressColors: const ProgressBarColors(playedColor: Colors.red, handleColor: Colors.redAccent),
      ),
    );
  }
}
