import 'dart:async';

import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/product_card_data.dart';
import '../../contracts/product_query.dart';
import 'rich_product_card.dart';

/// FLASHSALE: an animated countdown bar that opens a bottom sheet of
/// products (via the shared product-query contract) while the sale is
/// active, and disappears entirely once `end_time` has passed.
class FlashSaleWidget extends StatefulWidget {
  const FlashSaleWidget({
    super.key,
    required this.params,
    required this.callbacks,
  });

  final Map<String, dynamic> params;
  final WidgetCallbacks callbacks;

  @override
  State<FlashSaleWidget> createState() => _FlashSaleWidgetState();
}

class _FlashSaleWidgetState extends State<FlashSaleWidget>
    with TickerProviderStateMixin {
  late final AnimationController _colorController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);
  late final Animation<Color?> _colorA = ColorTween(
    begin: const Color(0xFFE53935),
    end: const Color(0xFFFF6F00),
  ).animate(CurvedAnimation(parent: _colorController, curve: Curves.easeInOut));
  late final Animation<Color?> _colorB = ColorTween(
    begin: const Color(0xFFFF6F00),
    end: const Color(0xFFE53935),
  ).animate(CurvedAnimation(parent: _colorController, curve: Curves.easeInOut));
  late final AnimationController _borderController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 5500),
  )..repeat();

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
    _colorController.dispose();
    _borderController.dispose();
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
    final d = remaining.inDays;
    final h = remaining.inHours % 24;
    final m = remaining.inMinutes % 60;
    final s = remaining.inSeconds % 60;
    if (d > 0) return '${d}d ${_pad(h)}:${_pad(m)}:${_pad(s)}';
    if (h > 0) return '${_pad(h)}:${_pad(m)}:${_pad(s)}';
    return '${_pad(m)}:${_pad(s)}';
  }

  void _openModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FlashModal(params: widget.params, callbacks: widget.callbacks),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    if (_endTime != null && _endTime!.isBefore(now)) {
      return const SizedBox.shrink();
    }

    final title = (widget.params['title'] as String?) ?? 'Flash Sale';
    final subtitle = widget.params['subtitle'] as String?;
    final remaining = _endTime?.difference(now);

    final content = AnimatedBuilder(
      animation: _colorController,
      builder: (context, _) {
        final c1 = _colorA.value ?? const Color(0xFFE53935);
        final c2 = _colorB.value ?? const Color(0xFFFF6F00);
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [c1, c2], begin: Alignment.centerLeft, end: Alignment.centerRight),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: c1.withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.bolt, color: Colors.white, size: 26),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                    if (subtitle != null)
                      Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                  ],
                ),
              ),
              if (remaining != null) _TimerChip(timerText: _timerText(remaining)),
              const SizedBox(width: 8),
              const Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 20),
            ],
          ),
        );
      },
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: GestureDetector(
        onTap: _openModal,
        child: AnimatedBuilder(
          animation: _borderController,
          builder: (context, child) => CustomPaint(
            painter: _ProgressBorderPainter(progress: _borderController.value, radius: 14),
            child: Padding(padding: const EdgeInsets.all(2.5), child: child),
          ),
          child: content,
        ),
      ),
    );
  }
}

class _TimerChip extends StatelessWidget {
  const _TimerChip({required this.timerText});

  final String timerText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer_outlined, color: Colors.white, size: 13),
          const SizedBox(width: 4),
          Text(
            timerText,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressBorderPainter extends CustomPainter {
  _ProgressBorderPainter({required this.progress, required this.radius});

  final double progress;
  final double radius;

  static const double _segmentRatio = 0.32;

  static final Paint _trackPaint = Paint()
    ..color = Colors.white.withValues(alpha: 0.2)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.5
    ..strokeCap = StrokeCap.round;

  static final Paint _segPaint = Paint()
    ..color = const Color(0xFFFFD600)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.5
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(1.25, 1.25, size.width - 2.5, size.height - 2.5),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    final metric = path.computeMetrics().first;
    final total = metric.length;

    canvas.drawPath(path, _trackPaint);

    final segLen = total * _segmentRatio;
    final startDist = progress * total;
    final endDist = startDist + segLen;

    if (endDist <= total) {
      canvas.drawPath(metric.extractPath(startDist, endDist), _segPaint);
    } else {
      canvas.drawPath(metric.extractPath(startDist, total), _segPaint);
      canvas.drawPath(metric.extractPath(0, endDist - total), _segPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ProgressBorderPainter oldDelegate) => oldDelegate.progress != progress;
}

class _FlashModal extends StatefulWidget {
  const _FlashModal({required this.params, required this.callbacks});

  final Map<String, dynamic> params;
  final WidgetCallbacks callbacks;

  @override
  State<_FlashModal> createState() => _FlashModalState();
}

class _FlashModalState extends State<_FlashModal> {
  late final Future<List<ProductCardData>> _future =
      widget.callbacks.fetchProducts(ProductQuery.fromParams(widget.params));
  Duration _remaining = Duration.zero;
  Timer? _timer;
  bool _expired = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    final endTimeRaw = widget.params['end_time'];
    if (endTimeRaw == null) return;
    final endTime = endTimeRaw is num
        ? DateTime.fromMillisecondsSinceEpoch(endTimeRaw.toInt() * 1000)
        : DateTime.tryParse(endTimeRaw.toString()) ?? DateTime.now();

    void tick() {
      if (!mounted) return;
      final diff = endTime.difference(DateTime.now());
      if (diff.isNegative) {
        setState(() {
          _remaining = Duration.zero;
          _expired = true;
        });
        _timer?.cancel();
      } else {
        setState(() => _remaining = diff);
      }
    }

    tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => tick());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  String get _timerText {
    final d = _remaining.inDays;
    final h = _remaining.inHours % 24;
    final m = _remaining.inMinutes % 60;
    final s = _remaining.inSeconds % 60;
    if (d > 0) return '${d}d ${_pad(h)}:${_pad(m)}:${_pad(s)}';
    if (h > 0) return '${_pad(h)}:${_pad(m)}:${_pad(s)}';
    return '${_pad(m)}:${_pad(s)}';
  }

  @override
  Widget build(BuildContext context) {
    final title = (widget.params['title'] as String?) ?? 'Flash Sale';

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 12),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFE53935), Color(0xFFFF6F00)]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bolt, color: Colors.white, size: 22),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    if (!_expired) _TimerChip(timerText: _timerText),
                    if (_expired)
                      const Text("Time's up", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: FutureBuilder<List<ProductCardData>>(
                  future: _future,
                  builder: (context, snapshot) {
                    final products = snapshot.data ?? const [];
                    if (products.isEmpty) return const SizedBox.shrink();
                    return GridView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(12),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.6,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) =>
                          RichProductCard(data: products[index], callbacks: widget.callbacks),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
