import 'dart:convert';

import 'widget_type.dart';

/// One entry of a backend-driven screen: a widget [type] plus its [params].
/// Screens render a list of these, in order.
class WidgetEntry {
  const WidgetEntry({required this.type, required this.params});

  final WidgetType type;
  final Map<String, dynamic> params;

  /// Parses a single `{ "type": ..., "params": ... }` entry. `params` may
  /// arrive as a `Map` or as a JSON-encoded `String`; both are accepted.
  factory WidgetEntry.fromJson(Map<String, dynamic> json) {
    return WidgetEntry(
      type: WidgetType.fromWire(json['type'] as String?),
      params: _decodeParams(json['params']),
    );
  }

  static Map<String, dynamic> _decodeParams(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    if (raw is String && raw.isNotEmpty) {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    }
    return const {};
  }

  /// Parses the full backend response shape `{ "data": [ ... ] }`, or a bare
  /// top-level list of widget entries.
  static List<WidgetEntry> listFromJson(dynamic json) {
    final List<dynamic> rawList;
    if (json is Map<String, dynamic> && json['data'] is List) {
      rawList = json['data'] as List;
    } else if (json is List) {
      rawList = json;
    } else {
      rawList = const [];
    }
    return rawList
        .whereType<Map>()
        .map((e) => WidgetEntry.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
