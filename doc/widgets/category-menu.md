# CATEGORYMENU

A horizontal row of circular category icons with a label underneath, each
resolving through the shared [action/tap contract](action-contract.md).
Unlike [STORY](story.md), tapping an item navigates directly instead of
opening a full-screen viewer.

```json
{
  "type": "CATEGORYMENU",
  "params": {
    "list": [
      {
        "title": "Shoes",
        "image": "https://example.com/shoes.png",
        "type": "category",
        "id": 1
      },
      {
        "title": "Sale",
        "image": "https://example.com/sale.png",
        "type": "filter",
        "id": "sale"
      }
    ]
  }
}
```

Each entry in `list` is a plain [action/tap contract](action-contract.md)
object plus `title` and `image`.

## Layout params (1.5.0)

All optional; defaults keep the previous look. Sizes are px.

- `image_size` — icon width/height (default `56`).
- `item_width` — width of each item, label included (default
  `image_size + 8`).
- `radius` — icon corner radius (default `image_size / 2`, i.e. a circle;
  `0` for square icons).
- `fit` — how the icon fills its frame (default `"cover"`); same values as
  [IMAGE](image.md)'s `fit`.
- `image_bg_color` — color behind the icon, useful for transparent PNGs.
- `spacing` — gap between items (default `16`).
- `padding_horizontal` — space before the first / after the last item
  (default `16`).
- `title_size` / `title_color` — label font size (default `12`) and hex
  color.
- `max_lines` — label lines before ellipsis (default `1`).
- `height` — row height; computed from `image_size` and `max_lines` when
  omitted.
- `bg_color` — row background, hex (default transparent).
