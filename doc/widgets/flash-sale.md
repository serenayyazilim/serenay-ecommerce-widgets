# FLASHSALE

An animated countdown bar. Disappears entirely once `end_time` has passed.
Supports two display modes via `display_mode`:

- `"modal"` (default) — tapping the bar opens a bottom sheet grid of
  products (fetched via the [product query contract](product-query.md),
  rendered with the same rich product card as [CAROUSEL](carousel.md)).
- `"inline"` — products are fetched eagerly and rendered as a
  horizontally-scrolling row directly beneath the bar, carousel-style. The
  bar is no longer tappable in this mode.

```json
{
  "type": "FLASHSALE",
  "params": {
    "title": "Flash Sale",
    "subtitle": "Grab it before time runs out",
    "end_time": 1782000000,
    "category_id": 75,
    "display_mode": "inline"
  }
}
```

- `end_time` — a Unix timestamp in seconds, or an ISO-8601 string. When
  omitted, the bar shows with no countdown and never expires.
- `title` / `subtitle` — shown on the bar and repeated in the bottom sheet
  header (modal mode only).
- `display_mode` — `"modal"` (default) or `"inline"`, as described above.
- Every other field is forwarded to `ProductQuery.fromParams` to fetch the
  products — see [product-query.md](product-query.md).

The bar itself animates a shifting red→orange gradient and a rotating
"comet" border segment.
