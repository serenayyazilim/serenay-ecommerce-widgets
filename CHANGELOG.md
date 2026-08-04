## 1.1.0

- Add `EcommerceWidgetTheme`: an optional `theme` parameter on
  `WidgetCatalog.getScreen` that lets a host app override the colors, text
  styles, radii and spacing used across the catalog (product cards, badges,
  buttons, flash sale, search, text, visited products) instead of the
  package's built-in look. Omitting it keeps the previous defaults.
- Export the standalone building blocks the catalog composes internally —
  `AddToCartButton`, `FavoriteButton`, `DiscountBadge`, `QuantityPicker`,
  `RichProductCard` — so they can be used directly outside `WidgetCatalog`.

## 1.0.0

- Initial release: a backend-driven dynamic widget system for e-commerce
  home/category screens.
- Supported widget types: TEXT, IMAGE, SLIDER, DIVIDER, CAROUSEL, GRID,
  IMAGECAROUSEL, IMAGELIST, VIDEOLIST, FASTREGISTER, STORY,
  VISITEDPRODUCTS, TIMEIMAGE, YOUTUBE, SEARCH, PRODUCTCARD, FLASHSALE,
  MODAL, MIXEDCAROUSEL.
