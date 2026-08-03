import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/widget_action.dart';
import '../../core/constants/app_colors.dart';
import 'catalog_network_image.dart';

/// SEARCH: a full-width background image with a floating, editable search
/// bar near the bottom and a separate "Search" button that navigates with
/// whatever text was typed.
class SearchWidget extends StatefulWidget {
  const SearchWidget({
    super.key,
    required this.params,
    required this.callbacks,
  });

  final Map<String, dynamic> params;
  final WidgetCallbacks callbacks;

  @override
  State<SearchWidget> createState() => _SerSearchWidgetState();
}

class _SerSearchWidgetState extends State<SearchWidget> {
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
    final hintText = (widget.params['hint_text'] as String?) ?? 'Search products...';
    final bottom = ((widget.params['bottom'] as num?) ?? 10) / 2;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final heightPercent = (widget.params['height_percent'] as num?)?.toDouble() ?? 0.5;
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: width,
              child: CatalogNetworkImage(url: url, height: width * heightPercent),
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
                            backgroundColor: Colors.yellow.shade600,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                          ),
                          onPressed: _submit,
                          child: const Center(
                            child: Text(
                              'Search',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
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
