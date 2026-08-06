# MIXEDCAROUSEL

An auto-playing carousel (stops once the user drags) whose pages are either
a 2x2 mini product grid or a full-page image, each with its own background
color, title and description.

```json
{
  "type": "MIXEDCAROUSEL",
  "params": {
    "height_percent": 1.1,
    "items": [
      {
        "item_type": "image",
        "bg_color": "#222222",
        "title": "Lowest Price of the Year",
        "title_color": "#FFFFFF",
        "url": "https://.../banner.jpg",
        "type": "category",
        "id": 1
      },
      {
        "item_type": "products",
        "bg_color": "#FFF7EC",
        "title": "Just For You",
        "description": "Optional",
        "title_color": "#212121",
        "description_color": "#616161",
        "category_id": 75
      }
    ]
  }
}
```

- `height_percent` — page height as a fraction of width (default `1.1`).
- Each entry in `items` is one page:
  - `item_type: "image"` — uses the same fields as [IMAGE](image.md)
    (`url`, `type`, `id`, ...) via the [action contract](action-contract.md).
  - `item_type: "products"` — the rest of the entry is a
    [product query](product-query.md); the first 4 results render as a 2x2
    mini grid (plain image/title/price cards, no favorite heart or variant
    picker — a simpler card than GRID/CAROUSEL's).
  - `bg_color`, `title`/`title_color`, `description`/`description_color`
    style that page's card shell — these apply to **both** `item_type`
    values; an `"image"` page can carry its own `title`/`description` on
    top of the photo, same as a `"products"` page.

Auto-plays every 5 seconds; stops permanently the first time the user
drags a page.
