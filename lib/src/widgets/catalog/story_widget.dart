import 'dart:async';

import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/widget_action.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/theme/ecommerce_widget_theme.dart';
import 'catalog_network_image.dart';

/// STORY: an Instagram-style story tray. Built from scratch (no third-party
/// story package) so the standalone widget kit stays dependency-light, per
/// §4 of the widget catalog doc.
class StoryWidget extends StatelessWidget {
  const StoryWidget({
    super.key,
    required this.params,
    required this.callbacks,
    this.theme = const EcommerceWidgetTheme(),
  });

  final Map<String, dynamic> params;
  final WidgetCallbacks callbacks;
  final EcommerceWidgetTheme theme;

  List<Map<String, dynamic>> get _stories => ((params['list'] as List?) ?? const [])
      .whereType<Map>()
      .map((e) => Map<String, dynamic>.from(e))
      .toList();

  @override
  Widget build(BuildContext context) {
    final stories = _stories;
    if (stories.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceM),
        itemCount: stories.length,
        separatorBuilder: (context, index) => const SizedBox(width: AppDimens.spaceM),
        itemBuilder: (context, index) {
          final story = stories[index];
          final thumbnail = story['thumbnail'] as String? ?? '';
          return GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => _StoryViewer(
                  stories: stories,
                  initialIndex: index,
                  callbacks: callbacks,
                  theme: theme,
                ),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF512F), Color(0xFFDD2476)],
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: CatalogNetworkImage(
                          url: thumbnail,
                          errorBuilder: callbacks.imageErrorBuilder,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StoryViewer extends StatefulWidget {
  const _StoryViewer({
    required this.stories,
    required this.initialIndex,
    required this.callbacks,
    required this.theme,
  });

  final List<Map<String, dynamic>> stories;
  final int initialIndex;
  final WidgetCallbacks callbacks;
  final EcommerceWidgetTheme theme;

  @override
  State<_StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends State<_StoryViewer> {
  late int _storyIndex = widget.initialIndex;
  int _imageIndex = 0;
  Timer? _timer;

  List<String> get _urls =>
      ((widget.stories[_storyIndex]['urls'] as List?) ?? const []).cast<String>();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(widget.theme.storyAutoAdvanceDuration, _advance);
  }

  void _advance() {
    final urls = _urls;
    if (_imageIndex < urls.length - 1) {
      setState(() => _imageIndex++);
      _startTimer();
    } else if (_storyIndex < widget.stories.length - 1) {
      setState(() {
        _storyIndex++;
        _imageIndex = 0;
      });
      _startTimer();
    } else {
      Navigator.of(context).maybePop();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _handleCta(Map<String, dynamic> story) {
    final type = story['type'] as String?;
    final target = story['product_id_or_url'];
    if (type == 'product') {
      widget.callbacks.onAction(WidgetAction(type: WidgetActionType.product, id: target));
    } else if (target is String) {
      widget.callbacks.onAction(WidgetAction(type: WidgetActionType.link, goto: target));
    }
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.stories[_storyIndex];
    final urls = _urls;
    final image = urls.isNotEmpty ? urls[_imageIndex] : '';
    final footer = story['contain'] as String?;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTapUp: (details) {
              final half = MediaQuery.of(context).size.width / 2;
              if (details.globalPosition.dx < half) {
                if (_imageIndex > 0) setState(() => _imageIndex--);
              } else {
                _advance();
              }
            },
            child: CatalogNetworkImage(
              url: image,
              fit: BoxFit.contain,
              errorBuilder: widget.callbacks.imageErrorBuilder,
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            right: 8,
            child: Row(
              children: List.generate(
                urls.length,
                (i) => Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    color: i <= _imageIndex ? Colors.white : Colors.white30,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              tooltip: 'Close',
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
          if (footer != null && footer.isNotEmpty)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () => _handleCta(story),
                child: Container(
                  height: 60,
                  width: double.infinity,
                  color: Colors.black.withValues(alpha: 0.4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.keyboard_arrow_up_outlined, color: Colors.white),
                      Padding(
                        padding: const EdgeInsets.all(3),
                        child: Text(
                          footer,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
