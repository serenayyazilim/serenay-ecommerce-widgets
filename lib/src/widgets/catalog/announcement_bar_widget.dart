import 'dart:async';

import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/widget_action.dart';
import '../../core/theme/ecommerce_widget_theme.dart';
import '../../core/utils/param_parsing.dart';

/// ANNOUNCEMENTBAR: a thin full-width strip with a short message ("Free
/// shipping over 500 TL"). A `list` of messages rotates every `interval`
/// seconds; a message with a `type` is tappable through the shared tap
/// contract.
class AnnouncementBarWidget extends StatefulWidget {
  const AnnouncementBarWidget({
    super.key,
    required this.params,
    required this.callbacks,
    this.theme = const EcommerceWidgetTheme(),
  });

  final Map<String, dynamic> params;
  final WidgetCallbacks callbacks;
  final EcommerceWidgetTheme theme;

  @override
  State<AnnouncementBarWidget> createState() => _AnnouncementBarWidgetState();
}

class _AnnouncementBarWidgetState extends State<AnnouncementBarWidget> {
  late final List<Map<String, dynamic>> _messages = _parseMessages();
  int _index = 0;
  Timer? _timer;

  /// `list` items may be plain strings or `{text, type, id, ...}` maps; a
  /// lone `text` param is treated as a one-item list carrying the widget's
  /// own action fields.
  List<Map<String, dynamic>> _parseMessages() {
    final list = widget.params['list'];
    if (list is List && list.isNotEmpty) {
      return [
        for (final item in list)
          if (item is Map)
            Map<String, dynamic>.from(item)
          else if (item != null)
            {'text': item.toString()},
      ].where((m) => (m['text']?.toString() ?? '').isNotEmpty).toList();
    }
    final text = widget.params['text']?.toString() ?? '';
    return text.isEmpty ? const [] : [widget.params];
  }

  @override
  void initState() {
    super.initState();
    if (_messages.length >= 2) {
      final seconds = parseInt(widget.params['interval']) ?? 4;
      _timer = Timer.periodic(Duration(seconds: seconds < 1 ? 1 : seconds), (_) {
        if (mounted) setState(() => _index = (_index + 1) % _messages.length);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_messages.isEmpty) return const SizedBox.shrink();

    final params = widget.params;
    final message = _messages[_index];
    final isTappable = message['type'] != null;
    final align = switch (params['align']) {
      'left' => TextAlign.left,
      'right' => TextAlign.right,
      _ => TextAlign.center,
    };

    return GestureDetector(
      onTap: isTappable ? () => widget.callbacks.onAction(WidgetAction.fromParams(message)) : null,
      child: Container(
        width: double.infinity,
        color: parseColor(params['bg_color'], fallback: widget.theme.primaryColor),
        padding: EdgeInsets.symmetric(
          horizontal: parseDouble(params['padding_horizontal']) ?? 16,
          vertical: parseDouble(params['padding_vertical']) ?? 8,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            message['text'].toString(),
            key: ValueKey(_index),
            textAlign: align,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: parseColor(params['text_color'], fallback: Colors.white),
              fontSize: parseDouble(params['text_size']) ?? 13,
              fontWeight: (parseBool(params['bold']) ?? true) ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
