import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/ecommerce_widget_theme.dart';

/// COUPON: a dashed-border coupon card showing a discount headline, a
/// tap-to-copy code and an optional countdown to `end_time`. Disappears
/// entirely once the countdown expires, matching FLASHSALE's behavior.
class CouponWidget extends StatefulWidget {
  const CouponWidget({
    super.key,
    required this.params,
    this.theme = const EcommerceWidgetTheme(),
  });

  final Map<String, dynamic> params;
  final EcommerceWidgetTheme theme;

  @override
  State<CouponWidget> createState() => _CouponWidgetState();
}

class _CouponWidgetState extends State<CouponWidget> {
  Timer? _ticker;
  Timer? _copiedResetTimer;
  DateTime? _endTime;
  bool _copied = false;

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
    _copiedResetTimer?.cancel();
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

  Future<void> _copyCode(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    _copiedResetTimer?.cancel();
    setState(() => _copied = true);
    _copiedResetTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final now = DateTime.now();
    if (_endTime != null && _endTime!.isBefore(now)) {
      return const SizedBox.shrink();
    }

    final code = widget.params['code'] as String?;
    final discountText = widget.params['discount_text'] as String?;
    final description = widget.params['description'] as String?;
    if (code == null || code.isEmpty) return const SizedBox.shrink();

    final remaining = _endTime?.difference(now);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CustomPaint(
        painter: _DashedBorderPainter(color: theme.discountColor, radius: theme.radiusM),
        child: Padding(
          padding: EdgeInsets.all(theme.spaceM),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (discountText != null)
                      Text(
                        discountText,
                        style: theme.priceStyle.copyWith(color: theme.discountColor),
                      ),
                    if (description != null) ...[
                      SizedBox(height: theme.spaceXs),
                      Text(description, style: theme.captionStyle),
                    ],
                    if (remaining != null) ...[
                      SizedBox(height: theme.spaceXs),
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
              SizedBox(width: theme.spaceM),
              InkWell(
                onTap: () => _copyCode(code),
                borderRadius: BorderRadius.circular(theme.radiusS),
                child: Semantics(
                  button: true,
                  label: _copied ? theme.couponCopiedLabel : theme.couponCopyLabel,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: theme.spaceM, vertical: theme.spaceS),
                    decoration: BoxDecoration(
                      color: theme.discountColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(theme.radiusS),
                      border: Border.all(color: theme.discountColor),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          code,
                          style: theme.buttonLabelStyle.copyWith(
                            color: theme.discountColor,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          _copied ? Icons.check : Icons.copy_rounded,
                          size: 16,
                          color: theme.discountColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0.75, 0.75, size.width - 1.5, size.height - 1.5),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    final metric = path.computeMetrics().first;

    const dashLength = 6.0;
    const gapLength = 4.0;
    var distance = 0.0;
    while (distance < metric.length) {
      final next = (distance + dashLength).clamp(0.0, metric.length);
      canvas.drawPath(metric.extractPath(distance, next), paint);
      distance += dashLength + gapLength;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
