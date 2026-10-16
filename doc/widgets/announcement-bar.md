# ANNOUNCEMENTBAR

A thin full-width strip with a short message, usually at the top of the
screen ("Free shipping over 500 TL"). Several messages rotate in place.

```json
{
  "type": "ANNOUNCEMENTBAR",
  "params": {
    "bg_color": "#111111",
    "text_color": "#FFFFFF",
    "interval": 4,
    "list": [
      "Free shipping over 500 TL",
      { "text": "Autumn sale: up to 50% off", "type": "category", "id": 75 }
    ]
  }
}
```

- `text` — a single message. Ignored when `list` is set. Add
  [action/tap contract](action-contract.md) fields (`type`, `id`, ...) next
  to it to make the bar tappable.
- `list` — messages to rotate. Each item is either a plain string or a
  `{ "text": ..., <action fields> }` object; only items with a `type` are
  tappable.

All other params are optional. Sizes are px.

- `interval` — seconds between messages (default `4`, minimum `1`).
- `bg_color` — background, hex (default: theme `primaryColor`).
- `text_color` — hex (default white).
- `text_size` — default `13`.
- `bold` — semi-bold text (default on).
- `align` — `"left"`, `"center"` (default) or `"right"`.
- `padding_horizontal` / `padding_vertical` — default `16` / `8`.

Messages are a single line, truncated with an ellipsis. Renders nothing
when there is no non-empty message.
