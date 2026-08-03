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
  - any other `type` — treated as an external URL and resolved as
    `WidgetAction(type: link, goto: product_id_or_url)`.

Renders nothing if `list` is empty.
