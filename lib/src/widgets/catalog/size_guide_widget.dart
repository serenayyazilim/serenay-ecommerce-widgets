import 'package:flutter/material.dart';

import '../../core/theme/ecommerce_widget_theme.dart';

/// SIZEGUIDE: a "Size Guide" trigger button that opens a dialog with a
/// measurement table built from `params['headers']`/`params['rows']`.
/// Entirely self-contained — no navigation/fetch callback needed, since the
/// table data ships inline with the widget entry.
class SizeGuideWidget extends StatelessWidget {
  const SizeGuideWidget({
    super.key,
    required this.params,
    this.theme = const EcommerceWidgetTheme(),
  });

  final Map<String, dynamic> params;
  final EcommerceWidgetTheme theme;

  List<String> get _headers =>
      ((params['headers'] as List?) ?? const []).map((e) => e.toString()).toList();

  List<List<String>> get _rows => ((params['rows'] as List?) ?? const [])
      .whereType<List>()
      .map((row) => row.map((e) => e.toString()).toList())
      .toList();

  @override
  Widget build(BuildContext context) {
    final headers = _headers;
    final rows = _rows;
    if (headers.isEmpty || rows.isEmpty) return const SizedBox.shrink();

    final buttonLabel = (params['button_label'] as String?) ?? theme.sizeGuideButtonLabel;
    final dialogTitle = (params['title'] as String?) ?? theme.sizeGuideButtonLabel;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: theme.spaceM, vertical: theme.spaceXs),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () => _showDialog(context, dialogTitle, headers, rows),
          style: TextButton.styleFrom(foregroundColor: theme.primaryColor, padding: EdgeInsets.zero),
          icon: const Icon(Icons.straighten, size: 18),
          label: Text(buttonLabel, style: theme.buttonLabelStyle.copyWith(color: theme.primaryColor)),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, String title, List<String> headers, List<List<String>> rows) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: theme.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(theme.radiusM)),
        child: Padding(
          padding: EdgeInsets.all(theme.spaceM),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(title, style: theme.productTitleStyle)),
                  IconButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    icon: Icon(Icons.close, color: theme.textPrimaryColor),
                  ),
                ],
              ),
              SizedBox(height: theme.spaceS),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(theme.borderColor.withValues(alpha: 0.3)),
                  columns: [for (final h in headers) DataColumn(label: Text(h, style: theme.captionStyle.copyWith(fontWeight: FontWeight.w600)))],
                  rows: [
                    for (final row in rows)
                      DataRow(cells: [for (final cell in row) DataCell(Text(cell, style: theme.captionStyle))]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
