import '../core/utils/param_parsing.dart';

/// The common "product filter" shape every product-list widget (CAROUSEL,
/// GRID, PRODUCTCARD, FLASHSALE, MIXEDCAROUSEL products page) converts its
/// `params` into before asking the host app to fetch products.
class ProductQuery {
  const ProductQuery({
    this.categoryId,
    this.collectionId,
    this.brandId,
    this.groupId,
    this.search,
    this.searchFields,
    this.orderBy,
    this.limit,
    this.page,
    this.filterName,
    this.exceptProductIds,
    this.filter,
    this.link,
    this.isFavoritedList,
    this.isBundleProduct,
  });

  final dynamic categoryId;
  final dynamic collectionId;
  final dynamic brandId;
  final dynamic groupId;
  final String? search;
  final String? searchFields;

  /// Raw `"field|DIRECTION"` sort spec (e.g. `"id|DESC"`), kept unparsed so
  /// callers can forward it to their backend as-is.
  final String? orderBy;

  final int? limit;
  final int? page;
  final String? filterName;
  final List<dynamic>? exceptProductIds;
  final String? filter;
  final String? link;
  final bool? isFavoritedList;
  final bool? isBundleProduct;

  /// Builds a [ProductQuery] from a widget's raw `params`, following the
  /// shared product-list contract (§1.4 of the widget catalog doc): a
  /// `type` + `id` pair resolves the same way as the tap contract, and its
  /// absence falls back to reading the direct filter fields.
  factory ProductQuery.fromParams(Map<String, dynamic> params) {
    final type = params['type'] as String?;
    final id = params['id'];

    if (type != null && id != null) {
      switch (type) {
        case 'category':
        case 'main_category':
          return ProductQuery(categoryId: id);
        case 'collection':
          return ProductQuery(collectionId: id);
        case 'brand':
        case 'brands':
          return ProductQuery(brandId: id);
        case 'group':
          return ProductQuery(groupId: id);
        case 'filter':
          return ProductQuery(filter: (params['filter'] as String?) ?? '$id');
        case 'search':
          final searchText = params['search_text'] as String?;
          return searchText != null
              ? ProductQuery(search: searchText)
              : ProductQuery(collectionId: id);
        default:
          return ProductQuery(categoryId: id);
      }
    }

    return ProductQuery(
      categoryId: params['category_id'],
      collectionId: params['collection_id'],
      brandId: params['brand_id'],
      groupId: params['group_id'],
      search: params['search'] as String?,
      searchFields: params['search_fields'] as String?,
      orderBy: params['order_by'] as String?,
      limit: parseInt(params['limit']),
      page: parseInt(params['page']),
      filterName: params['filter_name'] as String?,
      exceptProductIds: (params['except_product_ids'] as List?)?.toList(),
      filter: params['filter'] as String?,
      link: params['link'] as String?,
      isFavoritedList: params['is_favorited_list'] as bool?,
      isBundleProduct: params['is_bundle_product'] as bool?,
    );
  }
}
