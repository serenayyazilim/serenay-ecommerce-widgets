import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/widget_action.dart';
import '../../core/utils/param_parsing.dart';
import 'catalog_network_image.dart';

/// IMAGE: a tappable single banner image following the shared tap contract
/// (§1.3 of the widget catalog doc). Hides itself when its target is
/// LOGIN/REGISTER and the user is already logged in.
class ImageWidget extends StatelessWidget {
  const ImageWidget({
    super.key,
    required this.params,
    required this.callbacks,
  });

  final Map<String, dynamic> params;
  final WidgetCallbacks callbacks;

  @override
  Widget build(BuildContext context) {
    final action = WidgetAction.fromParams(params);
    final isAuthShortcut =
        action.type == WidgetActionType.login || action.type == WidgetActionType.register;
    if (isAuthShortcut && (callbacks.isLoggedIn?.call() ?? false)) {
      return const SizedBox();
    }

    final url = params['url'] as String? ?? '';
    final heightPercent = parseDouble(params['height_percent']);
    final radius = parseDouble(params['radius']) ?? 0;
    final padding = parseDouble(params['padding']) ?? 0;
    final fit = parseBoxFit(params['fit']);

    return Padding(
      padding: EdgeInsets.all(padding),
      child: GestureDetector(
        onTap: () => callbacks.onAction(action),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            return CatalogNetworkImage(
              url: url,
              width: width,
              height: heightPercent != null ? width * heightPercent : null,
              fit: fit,
              borderRadius: radius > 0 ? BorderRadius.circular(radius) : null,
              errorBuilder: callbacks.imageErrorBuilder,
            );
          },
        ),
      ),
    );
  }
}
