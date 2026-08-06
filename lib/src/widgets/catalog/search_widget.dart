import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/widget_action.dart';
import '../../core/theme/ecommerce_widget_theme.dart';
import '../../core/utils/param_parsing.dart';
import 'catalog_network_image.dart';

/// SEARCH: a full-width background image with a floating, editable search
/// bar near the bottom and a separate "Search" button that navigates with
/// whatever text was typed.
class SearchWidget extends StatefulWidget {
  const SearchWidget({
    super.key,
    required this.params,
    required this.callbacks,
    this.theme = const EcommerceWidgetTheme(),
  });

  final Map<String, dynamic> params;
  final WidgetCallbacks callbacks;
  final EcommerceWidgetTheme theme;

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    widget.callbacks.onAction(
      WidgetAction(type: WidgetActionType.search, searchText: _controller.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final url = (widget.params['url'] as String?) ?? '';
    final hintText = (widget.params['hint_text'] as String?) ?? widget.theme.searchHintLabel;
    final bottom = (parseNum(widget.params['bottom']) ?? 10) / 2;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final heightPercent = parseDouble(widget.params['height_percent']) ?? 0.5;
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: width,
              child: CatalogNetworkImage(
                url: url,
                height: width * heightPercent,
                width: width,
                fit: BoxFit.fitWidth,
              ),
            ),
            Positioned(
              bottom: bottom.toDouble(),
              left: 10,
              right: 10,
              child: Container(
                color: Colors.white.withValues(alpha: 0.95),
                height: 65,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(fontSize: 17),
                        onSubmitted: (_) => _submit(),
                        decoration: InputDecoration(
                          hintText: hintText,
                          hintStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: width * 0.25,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.theme.secondaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                          ),
                          onPressed: _submit,
                          child: Center(
                            child: Text(
                              widget.theme.searchButtonLabel,
                              style: widget.theme.buttonLabelStyle.copyWith(fontSize: 14),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
