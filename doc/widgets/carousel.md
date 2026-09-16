# CAROUSEL

A horizontally-scrolling row of the rich product card (photo/variant
slider, favorite heart, discount badge, variant picker — see
[product-card-data.md](product-card-data.md)), backed by the
[product query contract](product-query.md).

```json
{
  "type": "CAROUSEL",
  "params": { "category_id": 75, "limit": 10, "autoplay": 1, "autoplay_interval": 5 }
}
```

`params` is passed straight to `ProductQuery.fromParams`, then
`WidgetCallbacks.fetchProducts(query)` supplies the products. Renders
nothing while loading resolves to an empty list.

- `autoplay` — auto-scroll the row (`1`/`true` or `0`/`false`; default off).
  Accepts a real bool, `0`/`1`, or `"true"`/`"false"`. Has no effect with
  fewer than two products, and stops permanently once the user drags the
  row manually.
- `autoplay_interval` — seconds between auto-scrolls while `autoplay` is on
  (default `5`; clamped to a minimum of `1`).

CAROUSEL, [GRID](grid.md), [PRODUCTCARD](product-card.md) and
[FLASHSALE](flash-sale.md)'s product sheet all render the exact same rich
card — CAROUSEL just lays it out in a horizontal row instead of a grid.
