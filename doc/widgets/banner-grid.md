# BANNERGRID

A mosaic of tappable banner images: one large banner next to two stacked
small ones, or an even grid. Each image resolves through the shared
[action/tap contract](action-contract.md).

```json
{
  "type": "BANNERGRID",
  "params": {
    "layout": "left_big",
    "height_percent": 0.6,
    "big_ratio": 0.5,
    "spacing": 8,
    "radius": 8,
    "list": [
      { "url": "https://.../big.jpg", "type": "category", "id": 1 },
      { "url": "https://.../small-1.jpg", "type": "category", "id": 2 },
      { "url": "https://.../small-2.jpg", "type": "collection", "id": 3 }
    ]
  }
}
```

Each entry in `list` is an [action/tap contract](action-contract.md) object
plus `url` and an optional per-item `fit`.

All other params are optional. Sizes are px.

- `layout`:
  - `"left_big"` (default) — big banner on the left, two small ones stacked
    on the right.
  - `"right_big"` — mirrored.
  - `"top_big"` — big banner on top, two small ones side by side below.
  - `"grid"` — every item in equal cells, `columns` per row.

  The three preset layouts use the first three `list` items (extras are
  ignored); with fewer than three items they fall back to `"grid"`.
- `height_percent` — total height of a preset layout as a fraction of width
  (default `0.6`).
- `big_ratio` — share of the width (or height, for `top_big`) the big
  banner takes, between `0` and `1` (default `0.5`).
- `columns` — cells per row in `grid` (default `2`).
- `aspect_ratio` — cell width / height in `grid` (default `1`).
- `spacing` — gap between images (default `8`).
- `radius` — image corner radius (default `0`).
- `fit` — how images fill their cell (default `"cover"`); a per-item `fit`
  wins.
- `padding_horizontal` / `padding_vertical` — outer padding (default `0`).
- `bg_color` — background, hex (default transparent).

Renders nothing if `list` is empty.
