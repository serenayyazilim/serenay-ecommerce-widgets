# BUNDLE

A "frequently bought together" row: the same [product query
contract](product-query.md) as CAROUSEL/GRID (typically sent with
`is_bundle_product: true`), rendered as products joined by `+` separators
with a combined price and a single "Add All to Cart" button. Hides itself
when fewer than 2 products come back.

```json
{
  "type": "BUNDLE",
  "params": {
    "is_bundle_product": true,
    "category_id": 12,
    "title": "Frequently Bought Together"
  }
}
```

- `title` — header above the row. Falls back to
  `theme.bundleTitleLabel` ("Frequently Bought Together").
- Every other field is forwarded to `ProductQuery.fromParams` — see
  [product-query.md](product-query.md).
- The "Add All to Cart" button only appears when `WidgetCallbacks.onAddToCart`
  is set; it calls it once per product (skipping any with `sale_disabled`).
