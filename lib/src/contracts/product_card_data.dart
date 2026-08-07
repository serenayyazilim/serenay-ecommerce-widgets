import '../core/utils/param_parsing.dart';

/// A single product variant (e.g. a color), as returned inline with a
/// product-list item.
class ProductVariant {
  const ProductVariant({required this.id, required this.name, this.image});

  final dynamic id;
  final String name;
  final String? image;

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'],
      name: (json['name'] as String?) ?? '',
      image: json['image'] as String?,
    );
  }
}

/// A pick-one purchase option shown in OldProductCard's measure/quantity
/// sheet (e.g. a size or a package tier), distinct from [ProductVariant]
/// (which represents a color/style choice with its own photo).
class ProductMeasureOption {
  const ProductMeasureOption({required this.id, required this.title, this.priceText});

  final dynamic id;
  final String title;

  /// Pre-formatted price/info text for this option (e.g. "129.90 ₺"),
  /// supplied by the backend so the widget never has to compute currency
  /// formatting itself.
  final String? priceText;

  factory ProductMeasureOption.fromJson(Map<String, dynamic> json) {
    return ProductMeasureOption(
      id: json['id'],
      title: (json['title'] as String?) ?? '',
      priceText: json['price_text'] as String?,
    );
  }
}

/// A currency-specific price entry, used when a product is priced in more
/// than one currency.
class ProductPrice {
  const ProductPrice({required this.price, required this.currency});

  final num price;
  final String currency;

  factory ProductPrice.fromJson(Map<String, dynamic> json) {
    return ProductPrice(
      price: parseNum(json['price']) ?? 0,
      currency: (json['currency'] as String?) ?? 'tl',
    );
  }
}

/// The product-list item shape shared by CAROUSEL, GRID, PRODUCTCARD,
/// FLASHSALE and MIXEDCAROUSEL's `products` pages (§3 of the widget catalog
/// doc). Every field but [id]/[image]/[title] is optional — widgets must
/// degrade gracefully (hide the field or fall back) when it's missing.
class ProductCardData {
  const ProductCardData({
    required this.id,
    required this.image,
    required this.title,
    this.subtitle,
    this.subtitle2,
    this.price,
    this.priceOld,
    this.discount,
    this.currency = 'tl',
    this.brandId,
    this.variants = const [],
    this.packageQty,
    this.qtyInPackage,
    this.prices = const [],
    this.isFavorited = false,
    this.measureName,
    this.measureOptions = const [],
    this.priceText,
    this.saleDisabled = false,
    this.saleDisabledReason,
    this.unitPrice,
    this.unitPriceText,
    this.preOrder = false,
  });

  final dynamic id;
  final String image;
  final String title;
  final String? subtitle;
  final String? subtitle2;
  final num? price;
  final num? priceOld;
  final String? discount;
  final String currency;
  final dynamic brandId;
  final List<ProductVariant> variants;
  final int? packageQty;
  final int? qtyInPackage;
  final List<ProductPrice> prices;
  final bool isFavorited;
  final String? measureName;
  final List<ProductMeasureOption> measureOptions;

  /// Free-text price shown instead of [price] (e.g. "Call for price").
  final String? priceText;

  final bool saleDisabled;
  final String? saleDisabledReason;
  final String? unitPrice;
  final String? unitPriceText;

  /// Whether this product is sellable only as a pre-order (OldProductCard
  /// shows a "Pre-order" banner instead of hiding the card).
  final bool preOrder;

  bool get hasDiscount => priceOld != null && price != null && priceOld! > price!;

  ProductCardData copyWith({bool? isFavorited}) {
    return ProductCardData(
      id: id,
      image: image,
      title: title,
      subtitle: subtitle,
      subtitle2: subtitle2,
      price: price,
      priceOld: priceOld,
      discount: discount,
      currency: currency,
      brandId: brandId,
      variants: variants,
      packageQty: packageQty,
      qtyInPackage: qtyInPackage,
      prices: prices,
      isFavorited: isFavorited ?? this.isFavorited,
      measureName: measureName,
      measureOptions: measureOptions,
      priceText: priceText,
      saleDisabled: saleDisabled,
      saleDisabledReason: saleDisabledReason,
      unitPrice: unitPrice,
      unitPriceText: unitPriceText,
      preOrder: preOrder,
    );
  }

  factory ProductCardData.fromJson(Map<String, dynamic> json) {
    return ProductCardData(
      id: json['id'],
      image: (json['image'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      subtitle: json['subtitle'] as String?,
      subtitle2: json['subtitle2'] as String?,
      price: parseNum(json['price']),
      priceOld: parseNum(json['price_old']),
      discount: json['discount']?.toString(),
      currency: (json['currency'] as String?) ?? 'tl',
      brandId: json['brand_id'],
      variants: (json['variants'] as List?)
              ?.whereType<Map>()
              .map((e) => ProductVariant.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          const [],
      packageQty: parseInt(json['package_qty']),
      qtyInPackage: parseInt(json['qty_in_package']),
      prices: (json['prices'] as List?)
              ?.whereType<Map>()
              .map((e) => ProductPrice.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          const [],
      isFavorited: (json['is_favorited'] as bool?) ?? false,
      measureName: json['measure_name'] as String?,
      measureOptions: (json['measure_options'] as List?)
              ?.map(
                (e) => e is Map
                    ? ProductMeasureOption.fromJson(Map<String, dynamic>.from(e))
                    : ProductMeasureOption(id: e, title: e.toString()),
              )
              .toList() ??
          const [],
      priceText: json['price_text'] as String?,
      saleDisabled: (json['sale_disabled'] as bool?) ?? false,
      saleDisabledReason: json['sale_disabled_reason'] as String?,
      unitPrice: json['unit_price']?.toString(),
      unitPriceText: json['unit_price_text'] as String?,
      preOrder: (json['pre_order'] as bool?) ?? false,
    );
  }

  static List<ProductCardData> listFromJson(dynamic json) {
    final List<dynamic> raw = json is List ? json : const [];
    return raw
        .whereType<Map>()
        .map((e) => ProductCardData.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
