# VISITEDPRODUCTS

Shows the locally-tracked "recently viewed" product list — never fetched
from the backend. A history-icon header ("Recently Viewed") followed by a
horizontal row of simple cards (image + discount badge, subtitle, title,
price — no favorite heart or variant picker).

```json
{
  "type": "VISITEDPRODUCTS",
  "params": { "limit": 10 }
}
```

`limit` caps how many products are shown (default `10`). The product list
itself comes from `WidgetCallbacks.visitedProducts` — your app is
responsible for tracking which products a user has viewed and returning
that list (most recent first). Renders nothing when that list is empty.
