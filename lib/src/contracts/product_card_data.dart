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

/// A currency-specific price entry, used when a product is priced in more
/// than one currency.
class ProductPrice {
  const ProductPrice({required this.price, required this.currency});

  final num price;
  final String currency;

  factory ProductPrice.fromJson(Map<String, dynamic> json) {
    return ProductPrice(
      price: (json['price'] as num?) ?? 0,
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
  final List<dynamic> measureOptions;

  /// Free-text price shown instead of [price] (e.g. "Call for price").
  final String? priceText;

  final bool saleDisabled;
  final String? saleDisabledReason;
  final String? unitPrice;
  final String? unitPriceText;

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
    );
  }

  factory ProductCardData.fromJson(Map<String, dynamic> json) {
    return ProductCardData(
      id: json['id'],
      image: (json['image'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      subtitle: json['subtitle'] as String?,
      subtitle2: json['subtitle2'] as String?,
      price: json['price'] as num?,
      priceOld: json['price_old'] as num?,
      discount: json['discount']?.toString(),
      currency: (json['currency'] as String?) ?? 'tl',
      brandId: json['brand_id'],
      variants: (json['variants'] as List?)
              ?.whereType<Map>()
              .map((e) => ProductVariant.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          const [],
      packageQty: json['package_qty'] as int?,
      qtyInPackage: json['qty_in_package'] as int?,
      prices: (json['prices'] as List?)
              ?.whereType<Map>()
              .map((e) => ProductPrice.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          const [],
      isFavorited: (json['is_favorited'] as bool?) ?? false,
      measureName: json['measure_name'] as String?,
      measureOptions: (json['measure_options'] as List?) ?? const [],
      priceText: json['price_text'] as String?,
      saleDisabled: (json['sale_disabled'] as bool?) ?? false,
      saleDisabledReason: json['sale_disabled_reason'] as String?,
      unitPrice: json['unit_price']?.toString(),
      unitPriceText: json['unit_price_text'] as String?,
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
