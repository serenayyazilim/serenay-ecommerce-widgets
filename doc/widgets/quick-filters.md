# QUICKFILTERS

A horizontally-scrolling row of pill-shaped chips ("Under 500 TL", "Free
Shipping", "New Season"). Each chip resolves through the shared
[action/tap contract](action-contract.md), usually `type: "filter"` or
`type: "search"`.

```json
{
  "type": "QUICKFILTERS",
  "params": {
    "list": [
      { "title": "Under 500 TL", "type": "filter", "id": 1, "filter": "price:0-500" },
      { "title": "Free Shipping", "type": "search", "id": 0, "search_text": "free shipping" },
      { "title": "Sneakers", "image": "https://example.com/shoe.png", "type": "category", "id": 75 }
    ]
  }
}
```

- `list` — the chips. Each needs a `title` plus [action/tap contract](action-contract.md)
  fields. `image` is an optional small icon before the title. Chips
  without a `title` are dropped.

All other params are optional. Sizes are px.

- `chip_color` — chip background, hex (default: theme `surfaceColor`).
- `text_color` — hex (default: theme `textPrimaryColor`).
- `border_color` — hex (default: theme `borderColor`).
- `text_size` — default `13`.
- `radius` — chip corner radius (default `20`).
- `spacing` — gap between chips (default `8`).
- `padding_horizontal` / `padding_vertical` — default `16` / `8`.
- `bg_color` — row background, hex.

Renders nothing when there is no titled chip.
