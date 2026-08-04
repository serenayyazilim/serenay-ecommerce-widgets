# serenay_ecommerce_widgets

A dynamic widget system that renders e-commerce home/category screens from
a backend-driven JSON payload. For the full widget catalog — one usage doc
per widget type, with JSON schemas and examples — see
[doc/widgets/](doc/widgets/README.md).

## Installation

```yaml
dependencies:
  serenay_ecommerce_widgets: ^1.1.3
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

## Supported widgets

TEXT, IMAGE, SLIDER, DIVIDER, CAROUSEL, GRID, IMAGECAROUSEL, IMAGELIST,
VIDEOLIST, FASTREGISTER, STORY, VISITEDPRODUCTS, TIMEIMAGE, YOUTUBE, SEARCH,
PRODUCTCARD, FLASHSALE, MODAL, MIXEDCAROUSEL. An unrecognized `type` renders
as an empty 1px box (forward compatibility).

For the `params` schema each widget expects, see
[doc/widgets/](doc/widgets/README.md) — one page per widget type.
