import 'package:flutter/material.dart';

import '../../callbacks/ser_builder_callbacks.dart';
import '../../contracts/ser_action.dart';
import 'ser_network_image.dart';

/// IMAGE: a tappable single banner image following the shared tap contract
/// (§1.3 of the widget catalog doc). Hides itself when its target is
/// LOGIN/REGISTER and the user is already logged in.
class SerImageWidget extends StatelessWidget {
  const SerImageWidget({
    super.key,
    required this.params,
    required this.callbacks,
  });

  final Map<String, dynamic> params;
  final SerBuilderCallbacks callbacks;

  @override
  Widget build(BuildContext context) {
    final action = SerAction.fromParams(params);
    final isAuthShortcut =
        action.type == SerActionType.login || action.type == SerActionType.register;
    if (isAuthShortcut && (callbacks.isLoggedIn?.call() ?? false)) {
      return const SizedBox();
    }

    final url = params['url'] as String? ?? '';
    final heightPercent = (params['height_percent'] as num?)?.toDouble();
    final radius = ((params['radius'] as num?) ?? 0).toDouble();
    final padding = ((params['padding'] as num?) ?? 0).toDouble();

    return Padding(
      padding: EdgeInsets.all(padding),
      child: GestureDetector(
        onTap: () => callbacks.onAction(action),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            return SerNetworkImage(
              url: url,
              width: width,
              height: heightPercent != null ? width * heightPercent : null,
              borderRadius: radius > 0 ? BorderRadius.circular(radius) : null,
            );
          },
        ),
      ),
    );
  }
}
