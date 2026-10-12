# IMAGECAROUSEL

Similar to [SLIDER](slider.md), but a flat horizontally-scrolling row of
individual images (not paged), optionally over a background image. Slides
are fetched by `id` via `WidgetCallbacks.fetchSlides`.

```json
{
  "type": "IMAGECAROUSEL",
  "params": {
    "id": 2,
    "height_percent": 0.3,
    "item_count": 2,
    "bg_image": "https://.../background.jpg",
    "fit": "cover",
    "bg_fit": "cover",
    "item_margin_horizontal": 5,
    "item_width_offset": 5,
    "padding_horizontal": 0.0,
    "padding_vertical": 0.0,
    "radius": 0
  }
}
```

- `height_percent` — row height as a fraction of width.
- `item_count` — how many items are visible at once; each item's width is
  computed from this so more items = narrower items (default `2`). Decimals
  are allowed (`2.5` shows two and a half items as a "peek" hint).
- `item_margin_horizontal` — space in px on each side of every item
  (default `5`), so the gap between two items is twice this.
- `item_width_offset` — px subtracted from every computed item width
  (default: same as `item_margin_horizontal`). Item width is
  `((row_width - item_count * 2 * item_margin_horizontal) / item_count) - item_width_offset`.
- `bg_image` — optional background image behind the row; omit or leave
  empty for no background.
- `fit` — how each row image fills its frame (default `"cover"`); same
  values as [IMAGE](image.md)'s `fit`.
- `bg_fit` — how `bg_image` fills its frame (default `"cover"`), independent
  of `fit`.
- `padding_horizontal` / `padding_vertical` — outer padding as a fraction of
  width, same as [SLIDER](slider.md) (default `0`). Vertical padding is
  added around the `height_percent` row, so images keep their height.
- `radius` — corner radius of each image in px (default `0`).

No `zoom`/`modal` handling here (unlike SLIDER) — every tap goes through the
default [action resolver](action-contract.md).
