# FLASHSALE

An animated countdown bar. Tapping it opens a bottom sheet of products
(fetched via the [product query contract](product-query.md), rendered with
the same rich product card as [GRID](grid.md)). Disappears entirely once
`end_time` has passed.

```json
{
  "type": "FLASHSALE",
  "params": {
    "title": "Flash Sale",
    "subtitle": "Grab it before time runs out",
    "end_time": 1782000000,
    "category_id": 75
  }
}
```

- `end_time` — a Unix timestamp in seconds, or an ISO-8601 string. When
  omitted, the bar shows with no countdown and never expires.
- `title` / `subtitle` — shown on the bar and repeated in the bottom sheet
  header.
- Every other field is forwarded to `ProductQuery.fromParams` to fetch the
  products shown in the sheet — see [product-query.md](product-query.md).

The bar itself animates a shifting red→orange gradient and a rotating
"comet" border segment.
