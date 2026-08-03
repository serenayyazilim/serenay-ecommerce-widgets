# mobile_ecommerce_widgets

A dynamic widget system that renders e-commerce home/category screens from
a backend-driven JSON payload. For the full widget catalog — one usage doc
per widget type, with JSON schemas and examples — see
[doc/widgets/](doc/widgets/README.md).

## Installation

```yaml
dependencies:
  mobile_ecommerce_widgets: ^1.0.0
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

## Supported widgets

TEXT, IMAGE, SLIDER, DIVIDER, CAROUSEL, GRID, IMAGECAROUSEL, IMAGELIST,
VIDEOLIST, FASTREGISTER, STORY, VISITEDPRODUCTS, TIMEIMAGE, YOUTUBE, SEARCH,
PRODUCTCARD, FLASHSALE, MODAL, MIXEDCAROUSEL. An unrecognized `type` renders
as an empty 1px box (forward compatibility).

For the `params` schema each widget expects, see
[doc/widgets/](doc/widgets/README.md) — one page per widget type.
