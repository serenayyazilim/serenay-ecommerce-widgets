import 'package:flutter/material.dart';

import '../../callbacks/ser_builder_callbacks.dart';
import '../../contracts/ser_action.dart';
import '../../core/constants/app_dimens.dart';
import 'ser_network_image.dart';

/// MODAL: shows an announcement/campaign popup automatically once per app
/// session for a given `url`+`type`+`id` combination — not persisted, so it
/// reappears on the next app launch. Occupies no layout space itself.
class SerModalWidget extends StatefulWidget {
  const SerModalWidget({
    super.key,
    required this.params,
    required this.callbacks,
  });

  final Map<String, dynamic> params;
  final SerBuilderCallbacks callbacks;

  @override
  State<SerModalWidget> createState() => _SerModalWidgetState();
}

class _SerModalWidgetState extends State<SerModalWidget> {
  static final Set<String> _shownKeys = {};

  @override
  void initState() {
    super.initState();
    final key = '${widget.params['url']}|${widget.params['type']}|${widget.params['id']}';
    if (_shownKeys.contains(key)) return;
    _shownKeys.add(key);
    WidgetsBinding.instance.addPostFrameCallback((_) => _show());
  }

  void _show() {
    if (!mounted) return;
    final params = widget.params;
    final url = params['url'] as String? ?? '';
    final radius = ((params['radius'] as num?) ?? 16).toDouble();
    final action = SerAction.fromParams(params);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        insetPadding: const EdgeInsets.all(AppDimens.spaceL),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
            widget.callbacks.onAction(action);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: SerNetworkImage(url: url),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
