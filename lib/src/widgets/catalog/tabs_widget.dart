import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../core/theme/ecommerce_widget_theme.dart';
import '../../core/utils/param_parsing.dart';
import 'carousel_widget.dart';

/// TABS: a row of tab labels over a product row. Each tab is its own
/// CAROUSEL — its own product query, rendered with the same rich card — so
/// "Best Sellers | New In | On Sale" fits in one section. A tab fetches the
/// first time it's opened and keeps its products when the user switches
/// back.
class TabsWidget extends StatefulWidget {
  const TabsWidget({
    super.key,
    required this.params,
    required this.callbacks,
    this.theme = const EcommerceWidgetTheme(),
  });

  final Map<String, dynamic> params;
  final WidgetCallbacks callbacks;
  final EcommerceWidgetTheme theme;

  @override
  State<TabsWidget> createState() => _TabsWidgetState();
}

class _TabsWidgetState extends State<TabsWidget> {
  late final List<Map<String, dynamic>> _tabs = ((widget.params['tabs'] as List?) ?? const [])
      .whereType<Map>()
      .map((e) => Map<String, dynamic>.from(e))
      .where((t) => (t['title']?.toString() ?? '').isNotEmpty)
      .toList();

  /// Layout params shared by every tab's carousel; a tab's own keys win.
  late final Map<String, dynamic> _shared = Map.of(widget.params)..remove('tabs');

  late int _selected = (parseInt(widget.params['initial_index']) ?? 0).clamp(
    0,
    _tabs.isEmpty ? 0 : _tabs.length - 1,
  );
  late final Set<int> _opened = {_selected};

  @override
  Widget build(BuildContext context) {
    if (_tabs.isEmpty) return const SizedBox.shrink();

    final theme = widget.theme;
    final params = widget.params;
    final activeColor = parseColor(params['selected_color'], fallback: theme.primaryColor)!;
    final textColor = parseColor(params['text_color'], fallback: theme.textSecondaryColor)!;
    final textSize = parseDouble(params['text_size']) ?? 14;
    final paddingH = parseDouble(params['padding_horizontal']) ?? 16;

    return Container(
      color: parseColor(params['bg_color']),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: paddingH),
            child: Row(
              children: [
                for (final (i, tab) in _tabs.indexed)
                  Semantics(
                    button: true,
                    selected: i == _selected,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() {
                        _selected = i;
                        _opened.add(i);
                      }),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(4, 10, 4, 8),
                        margin: EdgeInsets.only(right: parseDouble(params['tab_spacing']) ?? 20),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: i == _selected ? activeColor : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          tab['title'].toString(),
                          style: theme.productTitleStyle.copyWith(
                            fontSize: textSize,
                            color: i == _selected ? activeColor : textColor,
                            fontWeight: i == _selected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: theme.spaceS),
          // Unopened tabs stay empty boxes, so they don't fetch until tapped.
          IndexedStack(
            index: _selected,
            children: [
              for (final (i, tab) in _tabs.indexed)
                _opened.contains(i)
                    ? CarouselWidget(
                        params: {..._shared, 'bg_color': null, ...tab},
                        callbacks: widget.callbacks,
                        theme: theme,
                      )
                    : const SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }
}
