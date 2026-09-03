import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/ecommerce_widget_theme.dart';
import '../../core/utils/param_parsing.dart';

/// URGENCY: a slim scarcity/countdown banner (e.g. "Only 3 left in
/// stock!"), reusing COUPON/ABANDONEDCART's `end_time` countdown contract.
///
/// Hides itself when there's nothing to show: no `text` override, no
/// `stock_left`, or a `stock_left` above `threshold` (default 10) — and
/// once `end_time` has passed.
class UrgencyWidget extends StatefulWidget {
  const UrgencyWidget({
    super.key,
    required this.params,
    this.theme = const EcommerceWidgetTheme(),
  });

  final Map<String, dynamic> params;
  final EcommerceWidgetTheme theme;

  @override
  State<UrgencyWidget> createState() => _UrgencyWidgetState();
}

class _UrgencyWidgetState extends State<UrgencyWidget> {
  Timer? _ticker;
  DateTime? _endTime;

  @override
  void initState() {
    super.initState();
    _endTime = _parseDate(widget.params['end_time']);
    if (_endTime != null) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() {});
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
    if (raw is String) return DateTime.tryParse(raw);
    return null;
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  String _timerText(Duration remaining) {
    final h = remaining.inHours;
    final m = remaining.inMinutes % 60;
    final s = remaining.inSeconds % 60;
    if (h > 0) return '${_pad(h)}:${_pad(m)}:${_pad(s)}';
    return '${_pad(m)}:${_pad(s)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final now = DateTime.now();
    if (_endTime != null && _endTime!.isBefore(now)) {
      return const SizedBox.shrink();
    }

    final params = widget.params;
    final stockLeft = parseInt(params['stock_left']);
    final threshold = parseInt(params['threshold']) ?? 10;
    final override = params['text'] as String?;

    String? text = override;
    if (text == null && stockLeft != null) {
      if (stockLeft > threshold) return const SizedBox.shrink();
      text = theme.urgencyStockLabel.replaceAll('{count}', '$stockLeft');
    }
    if (text == null || text.isEmpty) return const SizedBox.shrink();

    final remaining = _endTime?.difference(now);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: theme.spaceM, vertical: theme.spaceXs),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: theme.spaceM, vertical: theme.spaceS),
        decoration: BoxDecoration(
          color: theme.discountColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(theme.radiusS),
        ),
        child: Row(
          children: [
            Icon(Icons.local_fire_department, size: 16, color: theme.discountColor),
            SizedBox(width: theme.spaceXs),
            Expanded(
              child: Text(
                text,
                style: theme.captionStyle.copyWith(color: theme.discountColor, fontWeight: FontWeight.w600),
              ),
            ),
            if (remaining != null) ...[
              SizedBox(width: theme.spaceXs),
              Text(
                _timerText(remaining),
                style: theme.captionStyle.copyWith(
                  color: theme.discountColor,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
