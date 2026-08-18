/// The set of dynamic widget types a backend can send in a backend-driven
/// screen JSON. Unknown/unmapped `type` strings resolve to [unknown].
enum WidgetType {
  text,
  image,
  slider,
  divider,
  carousel,
  grid,
  imageCarousel,
  unknown,
  imageList,
  videoList,
  fastRegister,
  productImage,
  story,
  visitedProducts,
  timeImage,
  youtube,
  search,
  productCard,
  flashSale,
  modal,
  mixedCarousel,
  rating,
  bundle,
  coupon,
  categoryMenu,
  loyaltyProgress,
  comparison;

  static const Map<String, WidgetType> _byWireName = {
    'TEXT': WidgetType.text,
    'IMAGE': WidgetType.image,
    'SLIDER': WidgetType.slider,
    'DIVIDER': WidgetType.divider,
    'CAROUSEL': WidgetType.carousel,
    'GRID': WidgetType.grid,
    'IMAGECAROUSEL': WidgetType.imageCarousel,
    'IMAGELIST': WidgetType.imageList,
    'VIDEOLIST': WidgetType.videoList,
    'FASTREGISTER': WidgetType.fastRegister,
    'PRODUCTIMAGE': WidgetType.productImage,
    'STORY': WidgetType.story,
    'VISITEDPRODUCTS': WidgetType.visitedProducts,
    'TIMEIMAGE': WidgetType.timeImage,
    'YOUTUBE': WidgetType.youtube,
    'SEARCH': WidgetType.search,
    'PRODUCTCARD': WidgetType.productCard,
    'FLASHSALE': WidgetType.flashSale,
    'MODAL': WidgetType.modal,
    'MIXEDCAROUSEL': WidgetType.mixedCarousel,
    'RATING': WidgetType.rating,
    'BUNDLE': WidgetType.bundle,
    'COUPON': WidgetType.coupon,
    'CATEGORYMENU': WidgetType.categoryMenu,
    'LOYALTYPROGRESS': WidgetType.loyaltyProgress,
    'COMPARISON': WidgetType.comparison,
  };

  /// Parses the backend wire value (exact-match, case-sensitive). Any
  /// unmapped value resolves to [unknown] so the screen never crashes on a
  /// type it doesn't recognize yet.
  factory WidgetType.fromWire(String? value) =>
      _byWireName[value] ?? WidgetType.unknown;
}
