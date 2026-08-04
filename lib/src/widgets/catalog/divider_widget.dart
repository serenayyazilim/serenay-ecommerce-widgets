import 'package:flutter/widgets.dart';

import '../../core/utils/param_parsing.dart';

/// DIVIDER: pure vertical spacing between widgets.
class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key, required this.params});

  final Map<String, dynamic> params;

  @override
  Widget build(BuildContext context) {
    final double height = parseDouble(params['height']) ?? 10;
    return SizedBox(height: height);
  }
}
