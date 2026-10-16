# STORY

An Instagram-style story tray: a horizontal row of circular thumbnails;
tapping one opens a full-screen story viewer for that entry.

```json
{
  "type": "STORY",
  "params": {
    "list": [
      {
        "thumbnail": "https://.../tray-icon.jpg",
        "urls": ["https://.../story-1.jpg", "https://.../story-2.jpg"],
        "contain": "View Product",
        "type": "product",
        "product_id_or_url": 1
      }
    ]
  }
}
```

- `thumbnail` — the tray avatar image.
- `urls` — the story's full-screen images, shown in order with a per-image
  progress bar; auto-advances every 3 seconds, tap left/right half of the
  screen to go back/forward.
- `contain` — optional footer call-to-action text; when present, a button
  at the bottom of the story triggers `product_id_or_url`:
  - `type: "product"` — resolves as `WidgetAction(type: product, id: product_id_or_url)`.
  - any other `type`, with a string `product_id_or_url` — treated as an
    external URL and resolved as `WidgetAction(type: link, goto:
    product_id_or_url)`. A non-string `product_id_or_url` with a non-
    `"product"` type does nothing on tap.

Renders nothing if `list` is empty.

## Tray params (1.5.0)

All optional; defaults keep the previous look. Sizes are px.

- `size` — thumbnail diameter (default `56`).
- `ring_width` — gradient ring thickness (default `2`).
- `ring_colors` — ring gradient as a list of hex colors, e.g.
  `["#FF512F", "#DD2476"]`; a single color draws a solid ring.
- `spacing` — gap between thumbnails (default `16`).
- `padding_horizontal` — space before the first / after the last
  thumbnail (default `16`).
- `show_title` — show each entry's `title` under its thumbnail (default
  off).
- `title_size` / `title_color` — label font size (default `12`) and hex
  color.
- `bg_color` — tray background, hex (default transparent).
