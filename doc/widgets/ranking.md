# RANKING

A "Top 10" row: the same [product query](product-query.md) as
[CAROUSEL](carousel.md), with a large rank number (1, 2, 3, ...) beside
each card in the order the products come back. Sort the query
(`order_by`) the way the ranking should read.

```json
{
  "type": "RANKING",
  "params": {
    "title": "Top 10 This Week",
    "category_id": 75,
    "order_by": "sales|DESC",
    "limit": 10
  }
}
```

All other params are optional. Sizes are px.

- `title` — header above the row (default: none).
- `rank_color` — rank numbers, hex (default: theme `primaryColor`).
- `item_width` — card width (default `150`).
- `height` — row height (default `260`).
- `bg_color` — section background, hex.

Uses `WidgetCallbacks.productCardBuilder` when set. Renders nothing when
the query returns no products.
