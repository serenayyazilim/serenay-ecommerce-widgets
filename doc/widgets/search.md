# SEARCH

A full-width background image with a floating, editable search bar near
the bottom and a separate "Search" button.

```json
{
  "type": "SEARCH",
  "params": {
    "url": "https://.../background.jpg",
    "hint_text": "Search products, brands...",
    "height_percent": 0.5,
    "bottom": 10,
    "bar_height": 56,
    "button_height": 40,
    "radius": 20
  }
}
```

- `height_percent` — background image height as a fraction of width
  (default `0.5`).
- `bottom` — vertical offset of the floating search bar from the bottom of
  the image (in the same units as `height_percent`'s base; halved
  internally to match the source layout — default effectively `5`).
- `bar_height` — height of the floating search bar (default `56`).
- `button_height` — height of the "Search" button inside the bar (default
  `40`; keep it at or below `bar_height` to avoid clipping).
- `radius` — corner radius shared by the bar and the button (default
  `theme.radiusL`).
- Submitting (pressing "Search" or the keyboard's submit action) calls
  `onAction` with `WidgetAction(type: WidgetActionType.search, searchText: <typed text>)`.
