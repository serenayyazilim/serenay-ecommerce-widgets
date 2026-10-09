# IMAGELIST

Several [IMAGE](image.md) widgets laid out side by side, each taking an
equal share of the row's width.

```json
{
  "type": "IMAGELIST",
  "params": {
    "list": [
      { "url": "https://.../a.jpg", "type": "category", "id": 1 },
      { "url": "https://.../b.jpg", "type": "category", "id": 2 }
    ]
  }
}
```

Each entry in `list` uses the same fields as [IMAGE](image.md) (`url`,
`type`, `id`, `radius`, `padding`, ...) — each entry is an independent
IMAGE, just laid out in an equal-width column instead of full row width.

Unlike IMAGE, `height_percent` is ignored and `fit` defaults to
`fit_width`: each image keeps its natural aspect ratio so narrow cells
don't crop the banner. Images with different aspect ratios will end up
different heights within the same row, so use same-ratio images for an
even row.
