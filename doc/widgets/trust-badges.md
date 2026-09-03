# TRUSTBADGES

A static row of reassurance icons (secure payment, free shipping, easy
returns, ...) with a caption under each — purely informational, no tap
contract. Reads its entries straight from `params.list`, the same
inline-list contract as CATEGORYMENU/REVIEWS.

```json
{
  "type": "TRUSTBADGES",
  "params": {
    "list": [
      {"icon": "shipping", "label": "Free Shipping"},
      {"icon": "secure", "label": "Secure Payment"},
      {"icon": "returns", "label": "Easy Returns"}
    ]
  }
}
```

- `list` — the badges to render, each `{"icon": ..., "label": ...}`.
  `icon` is one of the built-in semantic keys below; an unrecognized or
  missing key falls back to a generic checkmark icon.

  | `icon` key  | Icon                          |
  |-------------|--------------------------------|
  | `shipping`  | `Icons.local_shipping_outlined` |
  | `secure`    | `Icons.lock_outline`            |
  | `payment`   | `Icons.credit_card`             |
  | `returns`   | `Icons.assignment_return_outlined` |
  | `support`   | `Icons.support_agent_outlined`  |
  | `guarantee` | `Icons.verified_outlined`       |

- Hides itself entirely when `list` is empty or missing.
