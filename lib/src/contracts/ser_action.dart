/// The navigation targets a `type` + `id`/`url` pair can resolve to. Shared
/// by SLIDER, IMAGECAROUSEL, IMAGE, MODAL and MIXEDCAROUSEL image pages.
enum SerActionType {
  category,
  mainCategory,
  collection,
  brand,
  brands,
  group,
  filter,
  search,
  product,
  zoom,
  modal,
  login,
  register,
  cyb,
  link;

  static const Map<String, SerActionType> _byWireName = {
    'category': SerActionType.category,
    'main_category': SerActionType.mainCategory,
    'collection': SerActionType.collection,
    'brand': SerActionType.brand,
    'brands': SerActionType.brands,
    'group': SerActionType.group,
    'filter': SerActionType.filter,
    'search': SerActionType.search,
    'product': SerActionType.product,
    'zoom': SerActionType.zoom,
    'modal': SerActionType.modal,
    'login': SerActionType.login,
    'register': SerActionType.register,
    'cyb': SerActionType.cyb,
    'link': SerActionType.link,
  };

  /// Empty/unrecognized values fall back to [category] — the documented
  /// default target when a backend omits `type`.
  factory SerActionType.fromWire(String? value) =>
      _byWireName[value] ?? SerActionType.category;
}

/// A resolved tap target, built from a widget/item's `type`, `id`/`url` and
/// related fields. Kept a pure data class so navigation stays independent of
/// how the widget that produced it was rendered.
class SerAction {
  const SerAction({
    required this.type,
    this.id,
    this.url,
    this.filter,
    this.searchText,
    this.goto,
    this.title,
    this.name,
  });

  final SerActionType type;
  final dynamic id;
  final String? url;
  final String? filter;
  final String? searchText;
  final String? goto;
  final String? title;
  final String? name;

  /// Builds a [SerAction] from a widget/item's raw params map, following the
  /// shared tap contract (§1.3 of the widget catalog doc).
  factory SerAction.fromParams(Map<String, dynamic> params) {
    return SerAction(
      type: SerActionType.fromWire(params['type'] as String?),
      id: params['id'],
      url: params['url'] as String?,
      filter: params['filter'] as String?,
      searchText: params['search_text'] as String?,
      goto: params['goto'] as String?,
      title: params['title'] as String?,
      name: params['name'] as String?,
    );
  }
}
