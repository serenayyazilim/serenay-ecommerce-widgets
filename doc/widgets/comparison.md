# COMPARISON

Fetches products through the shared [product query
contract](product-query.md) (like CAROUSEL/GRID) and lays the first 3 out
side by side in a spec table — image, title, subtitle and price — so a
shopper can compare them without tapping in and out of each product. Hides
itself when fewer than 2 products come back.

```json
{
  "type": "COMPARISON",
  "params": {
    "category_id": 12
  }
}
```

Every field is forwarded to `ProductQuery.fromParams` — see
[product-query.md](product-query.md). Tapping a column resolves through the
shared product tap target (`WidgetActionType.product`).
