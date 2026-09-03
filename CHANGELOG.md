## 1.4.0

- Add six new catalog widgets, all backed by inline `params` (no new fetch
  callbacks) except RECOMMENDEDFORYOU:
  - `QNA` — a vertical Q&A list (`params.list` of question/answer/author/
    date).
  - `URGENCY` — a low-stock/countdown banner ("Only 3 left in stock!"),
    reusing COUPON/ABANDONEDCART's `end_time` contract.
  - `RECOMMENDEDFORYOU` — a titled product row using the same product-query
    contract as CAROUSEL.
  - `SOCIALPROOF` — a "N people bought this recently" banner that cycles
    through a list of recent purchases.
  - `SIZEGUIDE` — a button that opens a measurement-table dialog built from
    `params.headers`/`params.rows`.
  - `TRUSTBADGES` — a static row of reassurance icons (shipping, secure
    payment, returns, support, guarantee).

  Adds `EcommerceWidgetTheme.qnaTitleLabel`, `.urgencyStockLabel`,
  `.recommendedForYouTitleLabel`, `.socialProofLabel` and
  `.sizeGuideButtonLabel`. Ships with `doc/widgets/` usage pages and widget
  tests for each.

## 1.3.4

- Add a new catalog widget, `REVIEWS`: a horizontally-scrolling row of
  customer review cards (author, star rating, comment, optional "Verified
  Purchase" badge) with an optional average-rating/review-count header.
  Reads its entries straight from `params.list`, same inline-list contract
  as `CATEGORYMENU` — no fetch callback required. Adds
  `EcommerceWidgetTheme.reviewsTitleLabel` and `.reviewsVerifiedLabel`.
  Ships with a `doc/widgets/` usage page and widget tests.

## 1.3.3

- Add a new catalog widget, `ABANDONEDCART`: a "you left items in your cart"
  card using the same product-query contract as `BUNDLE`/`CAROUSEL`, showing
  a horizontally-scrolling row of the cart's products under an optional
  reservation countdown (`"end_time"`, same contract as `COUPON`) and a CTA
  button that resolves through the shared action contract back to the cart/
  checkout screen. Hides itself when the product list is empty or once
  `end_time` has passed. Adds `EcommerceWidgetTheme.abandonedCartTitleLabel`,
  `.abandonedCartReservedLabel` and `.abandonedCartCtaLabel`. Ships with a
  `doc/widgets/` usage page and widget tests.

## 1.3.2

- `FLASHSALE` gains a `"display_mode"` `params` field: `"modal"` (default,
  previous behavior — tapping the bar opens a bottom sheet grid) or
  `"inline"` (products are fetched eagerly and rendered as a
  horizontally-scrolling row directly beneath the bar, carousel-style; the
  bar is no longer tappable in this mode).
- Backward compatible: `display_mode` is optional and defaults to the
  previous `"modal"` behavior.
- Fix `BUNDLE`: its product row divided available width evenly across every
  item (`Row` + `Expanded`), so a handful of products — or a long/discounted
  price — could squeeze a tile narrow enough to overflow (`MiniProductTile`'s
  price row). It's now a horizontally-scrolling strip of fixed-width tiles,
  matching `CAROUSEL`'s pattern, and `MiniProductTile`'s price line wraps
  instead of overflowing when a host reuses it in a narrow space.

## 1.3.1

- `SLIDER` gains two `params` fields to control per-page layout instead of
  hardcoding it: `"viewport_fraction"` (default `0.8`, passed to the
  `PageController`) and `"item_padding_horizontal"` (default `5`, the
  horizontal padding around each slide). Set `viewport_fraction: 1.0` and
  `item_padding_horizontal: 0` for a full-bleed, edge-to-edge slide.
- Backward compatible: both fields are optional and default to the previous
  hardcoded values.

## 1.3.0

- Add a `"fit"` `params` field (values `"cover"`, `"contain"`, `"fill"`,
  `"fit_width"`, `"fit_height"`, `"scale_down"`, `"none"`, backed by a new
  `parseBoxFit` helper) so a backend can control how each image/video
  scales, instead of every widget hardcoding `BoxFit.cover`/`contain`. Wired
  into `SLIDER`, `IMAGE` (and `IMAGELIST` through it), `IMAGECAROUSEL` (plus
  a separate `bg_fit` for its background image), `SEARCH`, `MODAL`,
  `TIMEIMAGE`, `MIXEDCAROUSEL`'s `"image"` pages, and `VIDEOLIST`.
- Add a `"aspect_ratio"` `params` field to `TIMEIMAGE` (default `16/9`,
  previously hardcoded).
- Fix `GRID` and `PRODUCTCARD` silently ignoring a `"columns"` param sent as
  a numeric string (e.g. `"3"`) instead of a JSON number — both now parse it
  the same way every other numeric param does.
- All additions are backward compatible: `fit`/`aspect_ratio` are optional
  and default to the previous hardcoded behavior.

## 1.2.0

- Add six new catalog widgets: `RATING` (star rating + review count, the
  first consumer of the previously-unused `EcommerceWidgetTheme.
  ratingFilledColor`/`ratingEmptyColor`/`starSize`), `BUNDLE` ("frequently
  bought together" product row backed by `ProductQuery.isBundleProduct`),
  `COUPON` (copyable code with an expiry countdown), `CATEGORYMENU`
  (circular icon + label grid), `LOYALTYPROGRESS` (reward progress bar) and
  `COMPARISON` (side-by-side product spec table). Each ships with a
  `doc/widgets/` usage page, a widget test, and a demo entry in
  `example/lib/main.dart`. Adds `EcommerceWidgetTheme.bundleTitleLabel`,
  `.addAllToCartLabel`, `.couponCopyLabel` and `.couponCopiedLabel`.
- Fix `WidgetCallbacks.imageErrorBuilder` being defined but never wired up:
  `CatalogNetworkImage` now actually uses it (across every widget that
  loads a network image) instead of always falling back to its own fixed
  placeholder icon.
- Add `WidgetCallbacks.formatPrice` to let a host app replace the built-in
  `"<amount> <symbol>"` price text with its own locale/currency formatting;
  `RichProductCard`, `OldProductCard` and `MiniProductTile` now call it when
  set and fall back to the previous hardcoded formatting otherwise.
- Add `WidgetCallbacks.productCardBuilder` to let a host app replace the
  product card CAROUSEL, PRODUCTCARD and FLASHSALE render entirely, without
  forking the package (GRID keeps its own `OldProductCard` design).
- Add `WidgetCatalog.registerBuilder`/`.unregisterBuilder` so a host app can
  render a widget for a backend `type` this package doesn't ship yet,
  instead of it silently falling back to `UnknownWidget`'s empty 1px box.
  `WidgetEntry` now keeps the raw wire-format `type` string (`rawType`) so
  registered builders can key off it.
- Add a `"columns"` `params` field (falling back to the new
  `EcommerceWidgetTheme.gridColumns`, default `2`) to `GridWidget` and
  `ProductCardWidget`, so a backend can request a 3- or 4-column grid on a
  given screen without a package update.
- Add `EcommerceWidgetTheme.favoriteAnimationDuration`,
  `.flashSaleBorderDuration` and `.storyAutoAdvanceDuration` so a host app
  can tune (or shorten, for reduced-motion) the favorite "pop", the flash
  sale countdown border loop and the story auto-advance timer, which were
  previously hardcoded. `StoryWidget` now also accepts an optional `theme`.
- All additions are backward compatible: every new parameter and callback
  is optional and defaults to the previous behavior.

## 1.1.6

- Add widget catalog demo videos (converted to animated WebP, ~450KB/1.1MB)
  to the root and `doc/widgets/` READMEs, so both GitHub and pub.dev show a
  preview of the widgets in action.
- Fix `TimeImageWidget` (TIMEIMAGE): `_parseColor` used `int.parse` instead
  of `tryParse`, so a malformed backend `title_color` hex crashed the
  widget — every sibling color parser already degrades gracefully instead.
- Fix theme leaks in `RichProductCard`/`OldProductCard`'s variant/measure
  bottom sheets, `SearchWidget`'s bar, and three "not logged in" price
  buttons: they hardcoded `Colors.white`/`Colors.grey` instead of reading
  `EcommerceWidgetTheme`, so a host app's rebrand left them visibly
  off-theme.
- Fix `FastRegisterWidget` (FASTREGISTER) ignoring the theme entirely
  (hardcoded `Colors.green`): its border/header/text accent now reads from
  the new `EcommerceWidgetTheme.fastRegisterAccentColor` (defaults to
  WhatsApp green, so the default look is unchanged). Its WhatsApp
  `launchUrl` call is now awaited and checked — a failure (e.g. WhatsApp
  isn't installed) shows a snackbar via the new
  `theme.fastRegisterLaunchFailedLabel` instead of silently doing nothing.
- Deduplicate the inline muted/looping video player used by `OldProductCard`
  (GRID) and `VideoListWidget` (VIDEOLIST) into a single shared
  `MutedLoopVideo` widget, which now also falls back to a placeholder icon
  instead of a permanent black box when the video URL fails to load —
  matching `CatalogNetworkImage`'s existing graceful-degradation pattern.
- Add `ModalWidget.resetShown()` (now exported) to clear the "already shown
  this session" record for the `url`+`type`+`id` combo — useful on logout,
  or between widget tests that assert modal behavior.
- Add `Semantics`/`tooltip` labels to previously unlabeled icon-only
  buttons (`FavoriteButton`, MODAL/variant-sheet/measure-sheet close
  buttons, the STORY close button) so screen readers announce them.
  `FavoriteButton` also gains a `semanticLabel` parameter (defaults to
  `'Favorite'`).
- Add widget tests for TIMEIMAGE's color-parse fix, the SEARCH/FASTREGISTER
  theme fixes, `ModalWidget.resetShown()`, and smoke coverage for
  MIXEDCAROUSEL, STORY, SLIDER, VISITEDPRODUCTS and GRID, which previously
  had none.

## 1.1.5

- Add `GridWidget` (GRID) its own card design, `OldProductCard` — ported
  from the source app instead of sharing `RichProductCard` with CAROUSEL/
  PRODUCTCARD/FLASHSALE: a taller image, inline `.mp4` variant video, a
  left-edge discount ribbon, a pre-order banner (`ProductCardData.preOrder`),
  and a size/package-tier picker (`ProductCardData.measureOptions`, now
  typed as `ProductMeasureOption` instead of raw `dynamic`). Adds
  `EcommerceWidgetTheme.preOrderLabel` and `.quickAddLabel`.
- Fix `GridWidget` and `ProductCardWidget` (PRODUCTCARD): both used a
  `GridView` with a fixed `childAspectRatio`, which didn't match their
  card's real content height — GRID's cards overflowed at the bottom,
  PRODUCTCARD's rows had extra dead space below each card. Both now lay
  out with `Wrap`, sized to the actual card height.
- Fix `MixedCarouselWidget` (MIXEDCAROUSEL): a page's mini 2x2 product grid
  could need more vertical space than the page's height allowed (depending
  on `height_percent` and the amount of title/description text), clipping
  the bottom row of cards. The page height now grows to fit the grid
  instead of cutting it off.
- Fix `ModalWidget` and `SliderWidget`'s zoom-image dialog: `showDialog`
  defaults to the app's root `Navigator`, so the popup/barrier always
  covered the entire app regardless of where the widget was mounted. Both
  now pass `useRootNavigator: false`, matching `showModalBottomSheet`'s
  existing default, so the dialog is scoped to the nearest `Navigator`
  instead — host apps with nested navigators (e.g. a per-tab `Navigator`)
  will now see the dialog confined to that navigator's bounds rather than
  covering the whole app.
- Redesign `SearchWidget`'s floating search bar: a rounded, shadowed pill
  bar with a leading search icon and a rounded, `theme.primaryColor`
  button, replacing the flush white bar and square `secondaryColor`
  button. The bar height, button height and shared corner radius are now
  overridable per-instance via `params`: `bar_height`, `button_height`,
  `radius`.

## 1.1.4

- Fix `ModalWidget`: it was missing the circular white "X" close button, the
  dimmed barrier and the max-height constraint that the original design
  used, so the popup image had no way to be dismissed without tapping it.
  `ModalWidget` also never accepted an `EcommerceWidgetTheme`, unlike every
  other catalog widget — it now takes `theme` (wired automatically through
  `WidgetCatalog.getScreen(theme:)`) and the close button's background/icon
  colors follow `theme.surfaceColor`/`theme.textPrimaryColor` instead of
  being hardcoded white/black.
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
