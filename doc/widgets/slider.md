# SLIDER

A swipeable image slider with a page-dot indicator. Slides themselves aren't
in `params` — only the slider's `id`; `WidgetCallbacks.fetchSlides(id)`
fetches the actual slide list (see [SlideItem](action-contract.md)).

```json
{
  "type": "SLIDER",
  "params": {
    "id": 1,
    "height_percent": 0.3,
    "padding_horizontal": 0.1,
    "padding_vertical": 0.1,
    "fit": "cover",
    "viewport_fraction": 0.8,
    "item_padding_horizontal": 5
  }
}
```

- `height_percent` — slider height as a fraction of width (default `0.3`).
- `padding_horizontal` / `padding_vertical` — outer padding, also as a
  fraction of width (default `0`).
- `fit` — how each slide image fills its frame: `"cover"` (default),
  `"contain"`, `"fill"`, `"fit_width"`, `"fit_height"`, `"scale_down"` or
  `"none"`. Unrecognized values fall back to `"cover"`.
- `viewport_fraction` — fraction of the slider's width each page occupies,
  passed straight to the underlying `PageController` (default `0.8`; the
  neighboring slide's edge peeks in). Set to `1.0` for one full-width slide
  per page.
- `item_padding_horizontal` — horizontal padding (in pixels) around each
  slide, i.e. the gap between adjacent slides (default `5`). Set to `0`
  together with `viewport_fraction: 1.0` for a full-bleed, edge-to-edge
  slider.

Slides follow the [action/tap contract](action-contract.md), plus two
slider-only targets:

- `zoom` — opens a full-screen, pinch-to-zoom gallery of every slide,
  starting at the tapped one.
- `modal` — fetches popup content via `WidgetCallbacks.fetchModal` and
  shows it in a bottom sheet.

Renders nothing if `fetchSlides` isn't provided or returns an empty list.
