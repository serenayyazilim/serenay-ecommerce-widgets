# ORDERTRACKER

A "your order is on its way" card: an optional product image, a
title/subtitle and a step bar (Ordered → Shipped → Delivered) filled up to
the current step. The backend sends it only to users with an open order.

```json
{
  "type": "ORDERTRACKER",
  "params": {
    "title": "Your order is on its way",
    "subtitle": "Arrives tomorrow",
    "image": "https://example.com/item.jpg",
    "steps": ["Ordered", "Packed", "Shipped", "Delivered"],
    "current": 2,
    "type": "link",
    "url": "https://example.com/orders/1042"
  }
}
```

- `steps` — step labels, in order. Empty labels are dropped.
- `current` — index of the step the order is at (default `0`, clamped to
  the steps). Every step up to it is filled.

All other params are optional.

- `title` / `subtitle` / `image` — header row (each optional).
- `active_color` — filled steps, hex (default: theme `primaryColor`).
- `bg_color` — card background, hex (default: theme `surfaceColor`).
- [Action/tap contract](action-contract.md) fields (`type`, `id`, `url`,
  ...) make the whole card tappable and show a chevron.

Renders nothing when `steps` is empty.
