import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../core/constants/app_colors.dart';

/// A silent, looping, autoplaying inline video preview — used for GRID
/// variant images and VIDEOLIST entries that are actually `.mp4` clips.
///
/// Falls back to a placeholder icon (same graceful-degradation pattern as
/// [CatalogNetworkImage]) instead of a permanent black box when the URL
/// fails to load.
class MutedLoopVideo extends StatefulWidget {
  const MutedLoopVideo({super.key, required this.url});

  final String url;

  @override
  State<MutedLoopVideo> createState() => _MutedLoopVideoState();
}

class _MutedLoopVideoState extends State<MutedLoopVideo> {
  VideoPlayerController? _controller;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    final controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _controller = controller;
    controller.initialize().then((_) {
      if (!mounted) return;
      controller
        ..setLooping(true)
        ..setVolume(0)
        ..play();
      setState(() {});
    }).catchError((_) {
      if (!mounted) return;
      setState(() => _failed = true);
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) return _placeholder();

    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return const ColoredBox(color: Colors.black12);
    }
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: controller.value.size.width,
        height: controller.value.size.height,
        child: VideoPlayer(controller),
      ),
    );
  }

  Widget _placeholder() {
    return const ColoredBox(
      color: AppColors.border,
      child: Center(
        child: Icon(Icons.videocam_off_outlined, color: AppColors.textSecondary),
      ),
    );
  }
}
