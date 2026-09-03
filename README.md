# serenay_ecommerce_widgets

[![pub package](https://img.shields.io/pub/v/serenay_ecommerce_widgets.svg)](https://pub.dev/packages/serenay_ecommerce_widgets)
[![pub points](https://img.shields.io/pub/points/serenay_ecommerce_widgets)](https://pub.dev/packages/serenay_ecommerce_widgets/score)
[![CI](https://github.com/serenayyazilim/serenay-ecommerce-widgets/actions/workflows/ci.yml/badge.svg)](https://github.com/serenayyazilim/serenay-ecommerce-widgets/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/github/license/serenayyazilim/serenay-ecommerce-widgets)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-android%20%7C%20ios%20%7C%20web-blue)](https://pub.dev/packages/serenay_ecommerce_widgets)

**[🚀 Live demo](https://serenayyazilim.github.io/serenay-ecommerce-widgets/)** ·
**[📖 Docs](https://serenayyazilim.github.io/serenay-ecommerce-widgets/docs/)**

A dynamic widget system that renders e-commerce home/category screens from
a backend-driven JSON payload. For the full widget catalog — one usage doc
per widget type, with JSON schemas and examples — see
[doc/widgets/](doc/widgets/README.md).

<p>
  <img src="doc/widgets/Video-0.webp" width="280" alt="Widget catalog demo 1" />
  <img src="doc/widgets/Video-2.webp" width="280" alt="Widget catalog demo 2" />
</p>

## Installation

```yaml
dependencies:
  serenay_ecommerce_widgets: ^1.4.0
```

## Quick start

The package is backend-agnostic: navigation, data fetching, and auth/cart
state are all injected from the host app through `WidgetCallbacks`.

```dart
final callbacks = WidgetCallbacks(
  onAction: (action) {
    // Navigate based on action.type (category, product, collection, ...).
  },
  fetchProducts: (query) => myApi.fetchProducts(query),
  fetchSlides: (id) => myApi.fetchSlides(id),
  isLoggedIn: () => myAuth.isLoggedIn,
  onToggleFavorite: (product) => myApi.toggleFavorite(product.id),
  onAddToCart: (product, variant, qty) => myCart.add(product, variant, qty),
);

final screenJson = await myApi.fetchScreen(); // { "data": [ ... ] }
final data = WidgetCatalog.fromJson(screenJson);

ListView(children: WidgetCatalog.getScreen(data: data, callbacks: callbacks));
```

Only `onAction` and `fetchProducts` are required on `WidgetCallbacks`;
callbacks for widget types you don't use (`fetchVideos`, `fetchModal`,
`visitedProducts`, ...) can be left unset — the corresponding widget just
hides itself when no data comes back, it never crashes.

See [`example/lib/main.dart`](example/lib/main.dart) for a complete working
example: a mock JSON payload and mock callbacks driving a demo screen with
every catalog widget.

## Theming

By default every widget uses the package's built-in colors and text styles.
To re-brand the catalog for your app, pass an `EcommerceWidgetTheme` to
`getScreen`:

```dart
final theme = EcommerceWidgetTheme(
  primaryColor: const Color(0xFF7B2CBF),
  secondaryColor: const Color(0xFFFF9F1C),
  discountColor: const Color(0xFFE63946),
  productTitleStyle: const TextStyle(fontWeight: FontWeight.w700),
);

WidgetCatalog.getScreen(data: data, callbacks: callbacks, theme: theme);
```

Any field you don't set falls back to the package default — see
[`EcommerceWidgetTheme`](lib/src/core/theme/ecommerce_widget_theme.dart) for
the full list of overridable colors, text styles and sizes.

The standalone building blocks the catalog composes internally —
`AddToCartButton`, `FavoriteButton`, `DiscountBadge`, `QuantityPicker`,
`RichProductCard` — are also exported, so you can use them directly outside
`WidgetCatalog` (e.g. in a custom product detail screen) with their own
constructor overrides.

## Further customization

Beyond `EcommerceWidgetTheme`, `WidgetCallbacks` has a few more override
points for cases the theme alone can't cover:

- `formatPrice: (amount, currency) => ...` — replace the built-in
  `"<amount> <symbol>"` price text with your own locale/currency formatting.
- `productCardBuilder: (data) => ...` — replace the card CAROUSEL,
  PRODUCTCARD and FLASHSALE render for each product entirely (GRID keeps its
  own `OldProductCard` design regardless).
- `imageErrorBuilder: () => ...` — replace the broken-image placeholder
  shown across every widget when a network image fails to load.

`GridWidget`/`ProductCardWidget` also read a `"columns"` value from a
widget's `params` (falling back to `theme.gridColumns`, default `2`) if a
backend wants a 3- or 4-column grid on a given screen.

If your backend sends a `type` this package doesn't ship a widget for yet,
register a builder for it instead of waiting for a package update:

```dart
WidgetCatalog.registerBuilder('CUSTOM_BANNER', (entry, callbacks, theme) {
  return MyCustomBanner(params: entry.params);
});
```

## Supported widgets

TEXT, IMAGE, SLIDER, DIVIDER, CAROUSEL, GRID, IMAGECAROUSEL, IMAGELIST,
VIDEOLIST, FASTREGISTER, STORY, VISITEDPRODUCTS, TIMEIMAGE, YOUTUBE, SEARCH,
PRODUCTCARD, FLASHSALE, MODAL, MIXEDCAROUSEL, RATING, BUNDLE, COUPON,
CATEGORYMENU, LOYALTYPROGRESS, COMPARISON, ABANDONEDCART, REVIEWS, QNA,
URGENCY, RECOMMENDEDFORYOU, SOCIALPROOF, SIZEGUIDE, TRUSTBADGES. An
unrecognized `type` renders as an empty 1px box (forward compatibility).

GRID has its own card design (taller image, inline video, a pre-order
banner, a size/package picker); CAROUSEL, PRODUCTCARD and FLASHSALE share
the same card.

For the `params` schema each widget expects, see
[doc/widgets/](doc/widgets/README.md) — one page per widget type.

## Contributing

Bug reports and PRs are welcome — see [CONTRIBUTING.md](CONTRIBUTING.md)
for setup, the widget-authoring checklist, and issue templates.
