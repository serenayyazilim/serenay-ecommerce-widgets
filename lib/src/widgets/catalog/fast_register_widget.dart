import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// FASTREGISTER: a static WhatsApp quick-registration card — a 3-step
/// explainer (enter number, send the code, talk to a rep) followed by a
/// country code + phone field and a "Send" button that opens a WhatsApp
/// chat. `params` is currently unused — reserved by the backend contract for
/// future configuration.
class FastRegisterWidget extends StatefulWidget {
  const FastRegisterWidget({super.key, required this.params});

  final Map<String, dynamic> params;

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

  void _submit() {
    final phone = _phoneController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (phone.isEmpty) return;
    launchUrl(
      Uri.parse('https://wa.me/$_countryCode$phone'),
      mode: LaunchMode.externalApplication,
    );
  }

  Widget _step(String number, String title) {
    return Column(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 3, color: Colors.green),
          ),
          child: Center(
            child: Text(number, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 10),
        Text(title, style: const TextStyle(color: Colors.green), textAlign: TextAlign.center),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 1, color: Colors.green),
        ),
        child: Column(
          children: [
            Container(
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat, color: Colors.white, size: 20),
                  SizedBox(width: 10),
                  Text('WHATSAPP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Quick Registration System',
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.w700, fontSize: 20),
            ),
            const SizedBox(height: 5),
            const Text(
              'Register quickly via WhatsApp in 3 steps.',
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.w300, fontSize: 16),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _step('1', 'Enter Your\nNumber'),
                  const SizedBox(width: 5),
                  _step('2', 'Send the\nReceived Code'),
                  const SizedBox(width: 5),
                  _step('3', 'Talk to a\nRepresentative'),
                ],
              ),
            ),
            const SizedBox(height: 40),
            _numberField(context),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _numberField(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.65,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.green),
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
                  style: const TextStyle(color: Colors.black, fontSize: 14.2, letterSpacing: 2),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(bottom: 9.5),
                    hintText: '(_ _ _) _ _ _ _ _ _ _',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
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
              side: const WidgetStatePropertyAll(BorderSide(color: Colors.green, width: 1)),
              backgroundColor: const WidgetStatePropertyAll(Colors.green),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.send, color: Colors.white),
                SizedBox(width: 5),
                Text('Send', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
