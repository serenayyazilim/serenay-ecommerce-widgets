import 'package:flutter/widgets.dart';

/// Rendered for any `type` the catalog doesn't recognize, so a backend can
/// roll out new widget types without breaking older app builds (§1.2 of the
/// widget catalog doc).
class UnknownWidget extends StatelessWidget {
  const UnknownWidget({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox(height: 1);
}
