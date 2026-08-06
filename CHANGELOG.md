## 1.1.4

- Fix `ModalWidget`: it was missing the circular white "X" close button, the
  dimmed barrier and the max-height constraint that the original design
  used, so the popup image had no way to be dismissed without tapping it.
- Fix `SliderWidget`: slides rendered full-bleed instead of the original
  carousel's "peek" effect (adjacent slides partially visible at the
  edges); `PageController(viewportFraction: 0.8)` restores it.
- Fix `StoryWidget`: the swipe-up CTA at the bottom of a story was a small
  outlined button instead of the original full-width, translucent-black bar
  with an up-chevron above the text.
- Fix `FastRegisterWidget`: the WhatsApp header used a generic chat icon;
  replaced with a dependency-free WhatsApp-style glyph.
- Fix `MixedCarouselWidget`:
  - `item_type: "image"` pages silently dropped `title`/`description` —
    they now render inside the same colored card shell as `products` pages,
    matching the original design.
  - The mini product grid's photos weren't square (no `imageSize` was
    passed to `MiniProductTile`), so thumbnails rendered at the source
    image's aspect ratio instead of a uniform square like every other
    product card.
- Fix a crash ("Looking up a deactivated widget's ancestor is unsafe")
  that could happen in `FlashSaleWidget` and `FavoriteButton`: both built
  their `AnimationController`s via a lazy `late final` field initializer,
  which — if `build()` never touched the field before the widget was
  disposed (e.g. an already-expired flash sale short-circuits its own
  `build()`) — ran the `vsync` lookup during `dispose()` against a
  deactivated element. Controllers are now created eagerly in `initState()`.
- Fix `SearchWidget`'s background image `BoxFit`: it used `cover` instead
  of the original `fitWidth`, cropping the image differently than the
  source design.

## 1.1.3

- Add the remaining hardcoded, non-backend UI strings to
  `EcommerceWidgetTheme` so host apps can localize/re-brand them, matching
  `viewPricesLabel`: `notAvailableForSaleLabel`, `addToCartLabel`,
  `variantColorLabel`, `recentlyViewedLabel`, `searchHintLabel`,
  `searchButtonLabel`, `flashSaleTitleLabel`, `flashSaleTimeUpLabel`, and
  the FASTREGISTER card's `fastRegisterHeaderLabel`,
  `fastRegisterSendLabel`, `fastRegisterTitleLabel`,
  `fastRegisterSubtitleLabel`, `fastRegisterStep1Label`,
  `fastRegisterStep2Label`, `fastRegisterStep3Label` (FASTREGISTER now also
  accepts `theme` via `WidgetCatalog.getScreen`).

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
