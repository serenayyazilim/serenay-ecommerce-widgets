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
    "bg_fit": "cover"
  }
}
```

- `height_percent` — row height as a fraction of width.
- `item_count` — how many items are visible at once; each item's width is
  computed from this so more items = narrower items (default `2`).
- `bg_image` — optional background image behind the row; omit or leave
  empty for no background.
- `fit` — how each row image fills its frame (default `"cover"`); same
  values as [IMAGE](image.md)'s `fit`.
- `bg_fit` — how `bg_image` fills its frame (default `"cover"`), independent
  of `fit`.

No `zoom`/`modal` handling here (unlike SLIDER) — every tap goes through the
default [action resolver](action-contract.md).
