# TEXT

A simple or compound text block with three visual styles.

```json
{
  "type": "TEXT",
  "params": {
    "text": "Featured",
    "subtitle": "Optional, shown under text in section/banner_text styles",
    "style": "default | section | banner_text",
    "align": "left | center | right",
    "size": "small | medium | large | title | headline (default)",
    "color": "#RRGGBB",
    "padding_horizontal": 16,
    "padding_vertical": 12
  }
}
```

- `default` — a single styled line, sized by `size`.
- `section` — a bold heading plus an optional muted `subtitle` underneath —
  the "section title" pattern used above a CAROUSEL/GRID. Heading is a
  fixed size (18); `size` is ignored.
- `banner_text` — heading + subtitle inside a light rounded card. Heading is
  a fixed size (16); `size` is ignored.

`size` only takes effect for `style: "default"`.

Renders nothing if both `text` and `subtitle` are empty.
