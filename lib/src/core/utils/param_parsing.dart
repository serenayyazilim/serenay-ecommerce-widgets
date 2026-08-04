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
