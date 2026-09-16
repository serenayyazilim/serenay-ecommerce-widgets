import 'dart:async';

import 'package:flutter/widgets.dart';

/// Drives an auto-advance timer for a scrollable widget (a `PageView` or a
/// `ListView`), pausing permanently the first time the user drags it
/// manually. Shared by SLIDER, CAROUSEL and MIXEDCAROUSEL so the three
/// widgets' near-identical autoplay logic doesn't drift apart.
class AutoplayController {
  AutoplayController({
    required this.canAdvance,
    required this.advance,
    Duration interval = const Duration(seconds: 5),
  }) : _interval = interval < const Duration(seconds: 1)
            ? const Duration(seconds: 1)
            : interval;

  /// Whether the underlying controller is ready to jump to another page
  /// (e.g. `scrollController.hasClients`).
  final bool Function() canAdvance;

  /// Advances the scrollable by one step (page or pixel offset), wrapping
  /// back to the start past the end.
  final VoidCallback advance;

  final Duration _interval;
  Timer? _timer;
  bool _userInteracted = false;

  /// Starts (or restarts) the autoplay timer.
  void start() {
    _timer?.cancel();
    _timer = Timer.periodic(_interval, (_) {
      if (_userInteracted || !canAdvance()) return;
      advance();
    });
  }

  /// Feed this a scrollable's [ScrollNotification]s (via
  /// [NotificationListener]) to stop autoplay permanently the first time the
  /// user drags it. Programmatic scrolls from [advance] don't carry drag
  /// details, so they don't trip this.
  bool handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification && notification.dragDetails != null) {
      _userInteracted = true;
    }
    return false;
  }

  void dispose() => _timer?.cancel();
}
