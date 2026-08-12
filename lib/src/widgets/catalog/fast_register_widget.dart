import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/ecommerce_widget_theme.dart';

/// FASTREGISTER: a static WhatsApp quick-registration card — a 3-step
/// explainer (enter number, send the code, talk to a rep) followed by a
/// country code + phone field and a "Send" button that opens a WhatsApp
/// chat. `params` is currently unused — reserved by the backend contract for
/// future configuration.
class FastRegisterWidget extends StatefulWidget {
  const FastRegisterWidget({
    super.key,
    required this.params,
    this.theme = const EcommerceWidgetTheme(),
  });

  final Map<String, dynamic> params;
  final EcommerceWidgetTheme theme;

  @override
  State<FastRegisterWidget> createState() => _FastRegisterWidgetState();
}

class _FastRegisterWidgetState extends State<FastRegisterWidget> {
  static const _countryCodes = ['90', '1', '44', '49', '7'];

  String _countryCode = _countryCodes.first;
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final phone = _phoneController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (phone.isEmpty) return;
    final uri = Uri.parse('https://wa.me/$_countryCode$phone');
    final launched =
        await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.theme.fastRegisterLaunchFailedLabel)),
      );
    }
  }

  Widget _step(String number, String title) {
    final accent = widget.theme.fastRegisterAccentColor;
    return Column(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 3, color: accent),
          ),
          child: Center(
            child: Text(number, style: TextStyle(color: accent, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 10),
        Text(title, style: TextStyle(color: accent), textAlign: TextAlign.center),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final accent = theme.fastRegisterAccentColor;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 1, color: accent),
        ),
        child: Column(
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _WhatsAppGlyph(size: 20, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(theme.fastRegisterHeaderLabel, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Text(
              theme.fastRegisterTitleLabel,
              style: TextStyle(color: accent, fontWeight: FontWeight.w700, fontSize: 20),
            ),
            const SizedBox(height: 5),
            Text(
              theme.fastRegisterSubtitleLabel,
              style: TextStyle(color: accent, fontWeight: FontWeight.w300, fontSize: 16),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _step('1', theme.fastRegisterStep1Label),
                  const SizedBox(width: 5),
                  _step('2', theme.fastRegisterStep2Label),
                  const SizedBox(width: 5),
                  _step('3', theme.fastRegisterStep3Label),
                ],
              ),
            ),
            const SizedBox(height: 40),
            _numberField(context, theme),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _numberField(BuildContext context, EcommerceWidgetTheme theme) {
    final accent = theme.fastRegisterAccentColor;
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.65,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: accent),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 13, right: 2),
                child: DropdownButton<String>(
                  value: _countryCode,
                  underline: const SizedBox(),
                  items: _countryCodes
                      .map((code) => DropdownMenuItem(value: code, child: Text('+$code')))
                      .toList(),
                  onChanged: (value) => setState(() => _countryCode = value ?? _countryCode),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: theme.textPrimaryColor, fontSize: 14.2, letterSpacing: 2),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(bottom: 9.5),
                    hintText: '(_ _ _) _ _ _ _ _ _ _',
                    hintStyle: TextStyle(color: theme.textSecondaryColor),
                  ),
                  onSubmitted: (_) => _submit(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          height: 40,
          child: OutlinedButton(
            onPressed: _submit,
            style: ButtonStyle(
              side: WidgetStatePropertyAll(BorderSide(color: accent, width: 1)),
              backgroundColor: WidgetStatePropertyAll(accent),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.send, color: Colors.white),
                const SizedBox(width: 5),
                Text(theme.fastRegisterSendLabel, style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// A dependency-free stand-in for the WhatsApp logo (a phone handset inside
/// a rounded chat bubble) — closer to the original header icon than a
/// generic chat glyph, without bundling a trademarked asset.
class _WhatsAppGlyph extends StatelessWidget {
  const _WhatsAppGlyph({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _WhatsAppGlyphPainter(color)),
    );
  }
}

class _WhatsAppGlyphPainter extends CustomPainter {
  _WhatsAppGlyphPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final bubble = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height * 0.8),
        Radius.circular(size.width * 0.3),
      ))
      ..moveTo(size.width * 0.18, size.height * 0.72)
      ..lineTo(size.width * 0.05, size.height)
      ..lineTo(size.width * 0.38, size.height * 0.8)
      ..close();
    canvas.drawPath(bubble, paint);

    final dotPaint = Paint()..color = color.computeLuminance() > 0.5 ? Colors.green : Colors.white;
    final center = Offset(size.width / 2, size.height * 0.4);
    canvas.drawCircle(center, size.width * 0.18, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _WhatsAppGlyphPainter oldDelegate) => oldDelegate.color != color;
}
