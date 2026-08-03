/// The navigation targets a `type` + `id`/`url` pair can resolve to. Shared
/// by SLIDER, IMAGECAROUSEL, IMAGE, MODAL and MIXEDCAROUSEL image pages.
enum WidgetActionType {
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

  static const Map<String, WidgetActionType> _byWireName = {
    'category': WidgetActionType.category,
    'main_category': WidgetActionType.mainCategory,
    'collection': WidgetActionType.collection,
    'brand': WidgetActionType.brand,
    'brands': WidgetActionType.brands,
    'group': WidgetActionType.group,
    'filter': WidgetActionType.filter,
    'search': WidgetActionType.search,
    'product': WidgetActionType.product,
    'zoom': WidgetActionType.zoom,
    'modal': WidgetActionType.modal,
    'login': WidgetActionType.login,
    'register': WidgetActionType.register,
    'cyb': WidgetActionType.cyb,
    'link': WidgetActionType.link,
  };

  /// Empty/unrecognized values fall back to [category] — the documented
  /// default target when a backend omits `type`.
  factory WidgetActionType.fromWire(String? value) =>
      _byWireName[value] ?? WidgetActionType.category;
}

/// A resolved tap target, built from a widget/item's `type`, `id`/`url` and
/// related fields. Kept a pure data class so navigation stays independent of
/// how the widget that produced it was rendered.
class WidgetAction {
  const WidgetAction({
    required this.type,
    this.id,
    this.url,
    this.filter,
    this.searchText,
    this.goto,
    this.title,
    this.name,
  });

  final WidgetActionType type;
  final dynamic id;
  final String? url;
  final String? filter;
  final String? searchText;
  final String? goto;
  final String? title;
  final String? name;

  /// Builds a [WidgetAction] from a widget/item's raw params map, following the
  /// shared tap contract (§1.3 of the widget catalog doc).
  factory WidgetAction.fromParams(Map<String, dynamic> params) {
    return WidgetAction(
      type: WidgetActionType.fromWire(params['type'] as String?),
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
