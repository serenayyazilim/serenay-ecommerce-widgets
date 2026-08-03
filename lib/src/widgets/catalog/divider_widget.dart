import 'package:flutter/widgets.dart';

/// DIVIDER: pure vertical spacing between widgets.
class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key, required this.params});

  final Map<String, dynamic> params;

  @override
  Widget build(BuildContext context) {
    final double height = ((params['height'] as num?) ?? 10).toDouble();
    return SizedBox(height: height);
  }
}
