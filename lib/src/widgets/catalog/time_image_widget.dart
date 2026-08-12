import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/utils/param_parsing.dart';
import 'catalog_network_image.dart';

/// TIMEIMAGE: a banner image with an optional "countdown to date" overlay —
/// a title plus boxed day/hour/minute/second fields, positioned via
/// `position_top`/`position_bottom`/`position_left`/`position_right` (or a
/// nested `position` map) and aligned left/right via `title_position`.
class TimeImageWidget extends StatefulWidget {
  const TimeImageWidget({super.key, required this.params});

  final Map<String, dynamic> params;

  @override
  State<TimeImageWidget> createState() => _TimeImageWidgetState();
}

class _TimeImageWidgetState extends State<TimeImageWidget> {
  Timer? _ticker;
  DateTime? _target;
  bool _active = false;

  @override
  void initState() {
    super.initState();
    _target = _parseDate(widget.params['date']);
    _active = _target != null && _target!.isAfter(DateTime.now());
    if (_active) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        if (_target!.isBefore(DateTime.now())) {
          setState(() => _active = false);
          _ticker?.cancel();
        } else {
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  DateTime? _parseDate(dynamic raw) {
    if (raw == null) return null;
    if (raw is num) return DateTime.fromMillisecondsSinceEpoch(raw.toInt() * 1000);
    return DateTime.tryParse(raw.toString());
  }

  double? _pos(String key) {
    final v = widget.params['position_$key'] ?? (widget.params['position'] as Map?)?[key];
    return parseDouble(v);
  }

  Color _parseColor(dynamic raw) {
    final hex = (raw?.toString() ?? '').replaceAll('#', '').replaceAll(RegExp(r'^0[xX]'), '');
    final value = int.tryParse(hex.padLeft(8, 'F'), radix: 16);
    return value != null ? Color(value) : Colors.white;
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final url = (widget.params['url'] as String?) ?? '';
    if (url.isEmpty) return const SizedBox.shrink();

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CatalogNetworkImage(url: url),
          if (_active) _buildOverlay(),
        ],
      ),
    );
  }

  Widget _buildOverlay() {
    final remaining = _target!.difference(DateTime.now());
    final days = remaining.inDays;
    final hours = _pad(remaining.inHours % 24);
    final minutes = _pad(remaining.inMinutes % 60);
    final seconds = _pad(remaining.inSeconds % 60);

    final top = _pos('top');
    final bottom = _pos('bottom');
    final isLeft = widget.params['title_position'] == 'left' || !widget.params.containsKey('title_position');
    final title = (widget.params['title'] as String?)?.trim() ?? '';

    return Positioned(
      top: top,
      bottom: top != null ? null : (bottom ?? 16),
      left: _pos('left') ?? (isLeft ? 16 : null),
      right: _pos('right') ?? (!isLeft ? 16 : null),
      child: Column(
        crossAxisAlignment: isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          if (title.isNotEmpty) ...[
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: _parseColor(widget.params['title_color']),
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 6),
          ],
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (days > 0) ...[
                  _timeField(data: '$days', label: 'd'),
                  _separator(),
                ],
                _timeField(data: hours, label: 'h'),
                _separator(),
                _timeField(data: minutes, label: 'm'),
                _separator(),
                _timeField(data: seconds, label: 's'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _separator() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 3),
      child: Text(
        ':',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.white70,
          shadows: [Shadow(color: Colors.black38, blurRadius: 3, offset: Offset(0, 1))],
        ),
      ),
    );
  }

  Widget _timeField({required String data, required String label}) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: data,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1,
              shadows: [Shadow(color: Colors.black45, blurRadius: 3, offset: Offset(0, 1))],
            ),
          ),
          TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
              shadows: [Shadow(color: Colors.black38, blurRadius: 3, offset: Offset(0, 1))],
            ),
          ),
        ],
      ),
    );
  }
}
