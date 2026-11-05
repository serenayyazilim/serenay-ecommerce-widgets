# HOTSPOT

A "shop the look" image with tappable dots placed over the products in it.

```json
{
  "type": "HOTSPOT",
  "params": {
    "url": "https://example.com/look.jpg",
    "height_percent": 1.25,
    "list": [
      { "x": 0.42, "y": 0.30, "title": "Wool Coat", "subtitle": "1.299 TL", "type": "product", "id": 812 },
      { "x": 0.55, "y": 0.82, "title": "Chelsea Boots", "type": "product", "id": 640 }
    ]
  }
}
```

- `url` — the image. Renders nothing when empty.
- `list` — the dots. `x` / `y` are the dot's center as a fraction (`0`–`1`)
  of the image box, from the top-left. Each dot also takes
  [action/tap contract](action-contract.md) fields. Dots whose `x` or `y`
  isn't a number are dropped.
  - With a `title`: tapping the dot opens a small label (`title`, optional
    `subtitle`); tapping the label resolves the action.
  - Without a `title`: tapping the dot resolves the action right away.

All other params are optional. Sizes are px.

- `height_percent` — image height as a fraction of its width (default
  `1.0`). Match it to the image's own aspect ratio so the dots land on
  the right spot: with the default `fit: "cover"`, a different ratio crops
  the image but not the dot positions.
- `fit` — see [IMAGE](image.md) (default `"cover"`).
- `dot_size` — default `24`.
- `dot_color` — inner dot color, hex (default: theme `primaryColor`).
- `radius` — corner radius (default `0`).
- `padding` — space around the image (default `0`).
- Action fields (`type`, `id`, ...) next to `url` make the image itself
  tappable, like [IMAGE](image.md). A tap on the image first closes an
  open label.
