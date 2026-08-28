import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/widget_action.dart';
import '../../core/theme/ecommerce_widget_theme.dart';
import '../../core/utils/param_parsing.dart';
import 'catalog_network_image.dart';

/// SEARCH: a full-width background image with a floating, editable search
/// bar near the bottom and a separate "Search" button that navigates with
/// whatever text was typed.
///
/// The bar's height, the button's height, and their shared corner radius all
/// default to the package's built-in look but can be overridden per-instance
/// via `params`: `bar_height`, `button_height`, `radius`.
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
    final barHeight = parseDouble(widget.params['bar_height']) ?? 56.0;
    final buttonHeight = parseDouble(widget.params['button_height']) ?? 40.0;
    final radius = parseDouble(widget.params['radius']) ?? widget.theme.radiusL;
    final fit = parseBoxFit(widget.params['fit'], fallback: BoxFit.fitWidth);

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
                fit: fit,
                errorBuilder: widget.callbacks.imageErrorBuilder,
              ),
            ),
            Positioned(
              bottom: bottom.toDouble(),
              left: 14,
              right: 14,
              child: Container(
                height: barHeight,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: widget.theme.surfaceColor,
                  borderRadius: BorderRadius.circular(radius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: widget.theme.textSecondaryColor, size: 22),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: TextStyle(fontSize: 15, color: widget.theme.textPrimaryColor),
                        onSubmitted: (_) => _submit(),
                        decoration: InputDecoration(
                          hintText: hintText,
                          hintStyle: TextStyle(fontSize: 15, color: widget.theme.textSecondaryColor),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    SizedBox(
                      height: buttonHeight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.theme.primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(radius),
                          ),
                        ),
                        onPressed: _submit,
                        child: Text(
                          widget.theme.searchButtonLabel,
                          style: widget.theme.buttonLabelStyle.copyWith(fontSize: 14, color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
