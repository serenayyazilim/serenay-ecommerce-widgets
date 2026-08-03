# CAROUSEL

A horizontally-scrolling row of the rich product card (photo/variant
slider, favorite heart, discount badge, variant picker — see
[product-card-data.md](product-card-data.md)), backed by the
[product query contract](product-query.md).

```json
{
  "type": "CAROUSEL",
  "params": { "category_id": 75, "limit": 10 }
}
```

`params` is passed straight to `ProductQuery.fromParams`, then
`SerBuilderCallbacks.fetchProducts(query)` supplies the products. Renders
nothing while loading resolves to an empty list.

CAROUSEL, [GRID](grid.md), [PRODUCTCARD](product-card.md) and
[FLASHSALE](flash-sale.md)'s product sheet all render the exact same rich
card — CAROUSEL just lays it out in a horizontal row instead of a grid.
