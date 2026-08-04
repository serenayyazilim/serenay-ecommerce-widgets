## 1.1.2

- Add `EcommerceWidgetTheme.viewPricesLabel` so host apps can localize/
  override the "View Prices" text shown instead of a hidden price when the
  viewer is logged out (`RichProductCard`, `MiniProductTile`).
- Fix: `MiniProductTile` (MIXEDCAROUSEL's mini 2x2 product grid) rendered
  with no card background, unlike every other product card in the catalog.
  It now wraps its content in a `theme.surfaceColor` card, matching
  `RichProductCard`.

## 1.1.1

- Fix: numeric `params` (`height`, `height_percent`, `radius`, `padding`,
  `padding_horizontal`, `padding_vertical`, `bottom`, `limit`, `page`,
  `item_count`, `fontsize_title`, `fontsize_subtitle`, plus `price`,
  `price_old`, `package_qty`, `qty_in_package` on product data) crashed
  with a `TypeCastException` when a backend sent them as numeric strings
  (e.g. `"20"`) instead of JSON numbers. All catalog widgets and contracts
  now parse these tolerantly, matching the numbers-or-numeric-strings
  behavior most backends actually send.

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
