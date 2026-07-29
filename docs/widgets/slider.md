# SLIDER

A swipeable image slider with a page-dot indicator. Slides themselves aren't
in `params` — only the slider's `id`; `SerBuilderCallbacks.fetchSlides(id)`
fetches the actual slide list (see [SerSlideItem](action-contract.md)).

```json
{
  "type": "SLIDER",
  "params": {
    "id": 1,
    "height_percent": 0.3,
    "padding_horizontal": 0.1,
    "padding_vertical": 0.1
  }
}
```

- `height_percent` — slider height as a fraction of width (default `0.3`).
- `padding_horizontal` / `padding_vertical` — outer padding, also as a
  fraction of width (default `0`).

Slides follow the [action/tap contract](action-contract.md), plus two
slider-only targets:

- `zoom` — opens a full-screen, pinch-to-zoom gallery of every slide,
  starting at the tapped one.
- `modal` — fetches popup content via `SerBuilderCallbacks.fetchModal` and
  shows it in a bottom sheet.

Renders nothing if `fetchSlides` isn't provided or returns an empty list.
