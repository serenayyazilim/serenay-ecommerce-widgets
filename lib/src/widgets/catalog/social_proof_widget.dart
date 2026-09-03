import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/ecommerce_widget_theme.dart';
import '../../core/utils/param_parsing.dart';

/// SOCIALPROOF: a slim "N people bought this recently" banner. When
/// `params['list']` holds more than one recent-purchase entry, it cycles
/// through them (one every 3s) instead of showing a single static line —
/// each entry is `{"name": ..., "time_ago": ...}` or a plain string.
///
/// Hides itself when there's nothing to show: no `text` override, no
/// `count`, and no `list`.
class SocialProofWidget extends StatefulWidget {
  const SocialProofWidget({
    super.key,
    required this.params,
    this.theme = const EcommerceWidgetTheme(),
  });

  final Map<String, dynamic> params;
  final EcommerceWidgetTheme theme;

  @override
  State<SocialProofWidget> createState() => _SocialProofWidgetState();
}

class _SocialProofWidgetState extends State<SocialProofWidget> {
  Timer? _ticker;
  int _index = 0;

  List<String> get _entries => ((widget.params['list'] as List?) ?? const [])
      .map((e) {
        if (e is Map) {
          final name = e['name'] as String?;
          final timeAgo = e['time_ago'] as String?;
          if (name == null) return null;
          return timeAgo == null ? name : '$name · $timeAgo';
        }
        return e is String ? e : null;
      })
      .whereType<String>()
      .toList();

  @override
  void initState() {
    super.initState();
    if (_entries.length > 1) {
      _ticker = Timer.periodic(const Duration(seconds: 3), (_) {
        if (!mounted) return;
        setState(() => _index = (_index + 1) % _entries.length);
      });
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final params = widget.params;
    final entries = _entries;
    final override = params['text'] as String?;
    final count = parseInt(params['count']);

    String? text = override;
    text ??= entries.isNotEmpty ? entries[_index % entries.length] : null;
    text ??= count != null ? theme.socialProofLabel.replaceAll('{count}', '$count') : null;
    if (text == null || text.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: theme.spaceM, vertical: theme.spaceXs),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: theme.spaceM, vertical: theme.spaceS),
        decoration: BoxDecoration(
          color: theme.surfaceColor,
          borderRadius: BorderRadius.circular(theme.radiusS),
          border: Border.all(color: theme.borderColor),
        ),
        child: Row(
          children: [
            Icon(Icons.trending_up, size: 16, color: theme.primaryColor),
            SizedBox(width: theme.spaceXs),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  text,
                  key: ValueKey(text),
                  style: theme.captionStyle.copyWith(color: theme.textPrimaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
