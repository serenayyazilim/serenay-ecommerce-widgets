# COUPON

A dashed-border coupon card with a tap-to-copy code and an optional
countdown. Disappears entirely once `end_time` has passed, like FLASHSALE.

```json
{
  "type": "COUPON",
  "params": {
    "code": "WELCOME20",
    "discount_text": "20% OFF your first order",
    "description": "Applies at checkout",
    "end_time": 1782000000
  }
}
```

- `code` — required; the widget renders nothing if it's missing or empty.
  Tapping the code copies it to the clipboard via `Clipboard.setData`.
- `discount_text` / `description` — free-text headline and subtext.
- `end_time` — a Unix timestamp in seconds, or an ISO-8601 string. When
  omitted, the coupon shows with no countdown and never expires.
