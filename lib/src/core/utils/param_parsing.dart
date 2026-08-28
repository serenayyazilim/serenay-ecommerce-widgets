import 'package:flutter/painting.dart';

/// Parses a widget/JSON param that may arrive as a [num] or as a numeric
/// [String] — backends aren't always consistent about sending numbers as
/// JSON numbers vs. strings. Returns `null` for anything else, including
/// empty or non-numeric strings, instead of throwing.
num? parseNum(dynamic value) {
  if (value == null) return null;
  if (value is num) return value;
  if (value is String) return num.tryParse(value.trim());
  return null;
}

/// Like [parseNum], truncated to an [int].
int? parseInt(dynamic value) => parseNum(value)?.toInt();

/// Like [parseNum], converted to a [double].
double? parseDouble(dynamic value) => parseNum(value)?.toDouble();

/// Parses a widget/JSON `fit` param (e.g. `"contain"`, `"cover"`, `"fill"`,
/// `"fit_width"`, `"fit_height"`, `"scale_down"`, `"none"`) into a [BoxFit].
/// Falls back to [fallback] for anything unrecognized or null, instead of
/// throwing.
BoxFit parseBoxFit(dynamic value, {BoxFit fallback = BoxFit.cover}) {
  switch (value) {
    case 'contain':
      return BoxFit.contain;
    case 'cover':
      return BoxFit.cover;
    case 'fill':
      return BoxFit.fill;
    case 'fit_width':
      return BoxFit.fitWidth;
    case 'fit_height':
      return BoxFit.fitHeight;
    case 'scale_down':
      return BoxFit.scaleDown;
    case 'none':
      return BoxFit.none;
    default:
      return fallback;
  }
}
