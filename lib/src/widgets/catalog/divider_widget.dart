import 'package:flutter/widgets.dart';

/// DIVIDER: pure vertical spacing between widgets.
class SerDividerWidget extends StatelessWidget {
  const SerDividerWidget({super.key, required this.params});

  final Map<String, dynamic> params;

  @override
  Widget build(BuildContext context) {
    final double height = ((params['height'] as num?) ?? 10).toDouble();
    return SizedBox(height: height);
  }
}
