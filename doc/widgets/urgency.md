# URGENCY

A slim scarcity/countdown banner (e.g. "Only 3 left in stock!"), reusing
COUPON/ABANDONEDCART's `end_time` countdown contract.

```json
{
  "type": "URGENCY",
  "params": {
    "stock_left": 3,
    "threshold": 10,
    "end_time": 1782000000
  }
}
```

- `text` — full override; when set, it's shown as-is and `stock_left`/
  `threshold` are ignored.
- `stock_left` / `threshold` — when `text` is omitted, the widget builds its
  text from `theme.urgencyStockLabel` ("Only {count} left in stock!") with
  `{count}` replaced by `stock_left`. Hides itself when `stock_left` is
  above `threshold` (default `10`) — the point being to only nudge once
  stock is actually low.
- `end_time` — a Unix timestamp in seconds, or an ISO-8601 string. When set,
  a countdown renders next to the text and the widget hides itself entirely
  once it passes, matching COUPON/FLASHSALE/ABANDONEDCART.
- Hides itself entirely when there's nothing to show: no `text` override, no
  `stock_left`, or a `stock_left` above `threshold`.
