# BRANDS

Brand logos on bordered tiles, as a horizontally-scrolling row (default) or
a wrapping grid. Each logo resolves through the shared
[action/tap contract](action-contract.md).

```json
{
  "type": "BRANDS",
  "params": {
    "layout": "row",
    "item_width": 88,
    "aspect_ratio": 1,
    "list": [
      { "image": "https://.../nike.png", "title": "Nike", "type": "brand", "id": 12 },
      { "image": "https://.../adidas.png", "title": "Adidas", "type": "brand", "id": 13 }
    ]
  }
}
```

Each entry in `list` is an [action/tap contract](action-contract.md) object
plus `image` and an optional `title`.

All other params are optional. Sizes are px.

- `layout` — `"row"` (default, horizontal scroll) or `"grid"`.
- `columns` — tiles per row in `grid` layout (default `4`).
- `item_width` — tile width in `row` layout (default `88`).
- `aspect_ratio` — tile width / height (default `1`, square; `2` for wide
  logos).
- `spacing` — gap between tiles (default `8`).
- `padding_horizontal` / `padding_vertical` — outer padding (default `16` /
  `8`).
- `radius` — tile corner radius (default `8`).
- `item_padding` — space between the tile edge and the logo (default `8`).
- `item_bg_color` — tile background, hex (default white).
- `border_color` / `border_width` — tile border (default: theme
  `borderColor`, `1`); `border_width: 0` removes it.
- `fit` — how the logo fills the tile (default `"contain"`); same values as
  [IMAGE](image.md)'s `fit`.
- `show_title` — show each entry's `title` under its tile (default off).
- `title_size` / `title_color` — default `12` / theme text color.
- `bg_color` — background behind the whole widget, hex (default
  transparent).

Renders nothing if `list` is empty.
