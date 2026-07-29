/// The set of dynamic widget types a backend can send in a SerBuilder
/// screen JSON. Unknown/unmapped `type` strings resolve to [unknown].
enum SerWidgetType {
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
  mixedCarousel;

  static const Map<String, SerWidgetType> _byWireName = {
    'TEXT': SerWidgetType.text,
    'IMAGE': SerWidgetType.image,
    'SLIDER': SerWidgetType.slider,
    'DIVIDER': SerWidgetType.divider,
    'CAROUSEL': SerWidgetType.carousel,
    'GRID': SerWidgetType.grid,
    'IMAGECAROUSEL': SerWidgetType.imageCarousel,
    'IMAGELIST': SerWidgetType.imageList,
    'VIDEOLIST': SerWidgetType.videoList,
    'FASTREGISTER': SerWidgetType.fastRegister,
    'PRODUCTIMAGE': SerWidgetType.productImage,
    'STORY': SerWidgetType.story,
    'VISITEDPRODUCTS': SerWidgetType.visitedProducts,
    'TIMEIMAGE': SerWidgetType.timeImage,
    'YOUTUBE': SerWidgetType.youtube,
    'SEARCH': SerWidgetType.search,
    'PRODUCTCARD': SerWidgetType.productCard,
    'FLASHSALE': SerWidgetType.flashSale,
    'MODAL': SerWidgetType.modal,
    'MIXEDCAROUSEL': SerWidgetType.mixedCarousel,
  };

  /// Parses the backend wire value (exact-match, case-sensitive). Any
  /// unmapped value resolves to [unknown] so the screen never crashes on a
  /// type it doesn't recognize yet.
  factory SerWidgetType.fromWire(String? value) =>
      _byWireName[value] ?? SerWidgetType.unknown;
}
