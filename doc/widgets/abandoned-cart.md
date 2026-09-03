# ABANDONEDCART

A "you left items in your cart" card: the same [product query
contract](product-query.md) as BUNDLE/CAROUSEL (typically the backend's
current cart/reservation contents), rendered as a horizontally-scrolling row
of product tiles under an optional reservation countdown, with a single CTA
button that resolves through the shared [action contract](action-contract.md)
— usually back to the cart or checkout screen.

```json
{
  "type": "ABANDONEDCART",
  "params": {
    "cart_id": 42,
    "title": "You left items in your cart",
    "end_time": 1782000000,
    "goto": "cart"
  }
}
```

- `title` — header above the row. Falls back to
  `theme.abandonedCartTitleLabel` ("You left items in your cart").
- `end_time` — a Unix timestamp in seconds, or an ISO-8601 string. When set,
  a countdown ("Reserved for 09:58") renders under the title and the widget
  hides itself entirely once it passes, matching COUPON/FLASHSALE. Omit it
  for a reservation with no expiry.
- Every other field is forwarded to `ProductQuery.fromParams` (see
  [product-query.md](product-query.md)) to fetch the cart's products, and to
  `WidgetAction.fromParams` (see [action-contract.md](action-contract.md)) to
  resolve the CTA button's tap target.
- Hides itself entirely when the fetched product list is empty.
