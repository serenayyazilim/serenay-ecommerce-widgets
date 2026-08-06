import 'package:flutter/material.dart';

import '../../callbacks/widget_callbacks.dart';
import '../../contracts/widget_action.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/theme/ecommerce_widget_theme.dart';
import '../../core/utils/param_parsing.dart';
import 'catalog_network_image.dart';

/// MODAL: shows an announcement/campaign popup automatically once per app
/// session for a given `url`+`type`+`id` combination — not persisted, so it
/// reappears on the next app launch. Occupies no layout space itself.
class ModalWidget extends StatefulWidget {
  const ModalWidget({
    super.key,
    required this.params,
    required this.callbacks,
    this.theme = const EcommerceWidgetTheme(),
  });

  final Map<String, dynamic> params;
  final WidgetCallbacks callbacks;
  final EcommerceWidgetTheme theme;

  @override
  State<ModalWidget> createState() => _ModalWidgetState();
}

class _ModalWidgetState extends State<ModalWidget> {
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
    final radius = parseDouble(params['radius']) ?? 16;
    final action = WidgetAction.fromParams(params);

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceL, vertical: 40),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(dialogContext).pop();
                  widget.callbacks.onAction(action);
                },
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: params['height_percent'] != null
                        ? MediaQuery.of(context).size.width * (parseDouble(params['height_percent']) ?? 1.1)
                        : MediaQuery.of(context).size.height * 0.7,
                  ),
                  child: CatalogNetworkImage(url: url, width: double.infinity),
                ),
              ),
            ),
            Positioned(
              top: -14,
              right: -14,
              child: GestureDetector(
                onTap: () => Navigator.of(dialogContext).pop(),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(color: widget.theme.surfaceColor, shape: BoxShape.circle),
                  child: Icon(Icons.close, size: 18, color: widget.theme.textPrimaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
