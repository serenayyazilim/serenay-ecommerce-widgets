# VIDEOLIST

One or more silent, looping, auto-playing videos fetched by `id` via
`SerBuilderCallbacks.fetchVideos`, which returns a list of `SerVideoItem`
(`video` URL, [action](action-contract.md), optional `title`/`subtitle`).

```json
{
  "type": "VIDEOLIST",
  "params": {
    "id": 1,
    "width_percent": 1.0,
    "height_percent": 0.3,
    "scroll_direction": "vertical",
    "textparams": {
      "horizontal": "left",
      "vertical": "bottom",
      "fontcolor_title": "FFFFFF",
      "fontsize_title": 16,
      "fontweight_title": "bold",
      "fontcolor_subtitle": "FFFFFF",
      "fontsize_subtitle": 13,
      "fontweight_subtitle": "regular"
    }
  }
}
```

- A single fetched video renders full-width/height (`width_percent` /
  `height_percent`), tappable, with an optional `textparams` title/subtitle
  overlay — `horizontal`/`vertical` control the overlay's alignment,
  `fontcolor_*`/`fontsize_*`/`fontweight_*` (`regular`/`normal`/`bold`)
  style it.
- More than one video scrolls in a row/column per `scroll_direction`
  (`"horizontal"` or `"vertical"`, default `"vertical"`), each sized by
  `width_percent`/`height_percent` and separated by `horizontal_padding`/
  `vertical_padding`. `textparams` only applies to the single-video layout.
- Tapping a video resolves its `action` through the
  [action/tap contract](action-contract.md).
