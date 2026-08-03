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
`type`, `id`, `radius`, `padding`, ...), except `height_percent` is ignored —
images size to a fixed row height instead.
