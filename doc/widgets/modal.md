# MODAL

Shows an announcement/campaign popup automatically once per app session for
a given `url`+`type`+`id` combination — not persisted, so it reappears on
the next app launch. Occupies no layout space itself.

```json
{
  "type": "MODAL",
  "params": {
    "url": "https://.../popup.jpg",
    "type": "category",
    "id": 1,
    "radius": 16,
    "height_percent": 0.5,
    "fit": "cover"
  }
}
```

- `radius` — corner radius of the popup image (default `16`).
- `height_percent` — max popup height as a fraction of width; when omitted,
  the popup is capped at 70% of screen height instead.
- `fit` — how the popup image fills its frame (default `"cover"`); same
  values as [IMAGE](image.md)'s `fit`.
- Tapping the popup image resolves `type`/`id`/... through the shared
  [action/tap contract](action-contract.md) and dismisses the popup.
- A small close (×) button floats over the top-right corner.

This is the MODAL *widget* — distinct from the `type: "modal"` tap target
used elsewhere (e.g. in SLIDER/IMAGE), which fetches popup content by `id`
via `WidgetCallbacks.fetchModal` instead of embedding `url` directly.

The "already shown this session" record is process-wide (keyed by
`url`+`type`+`id`, not per-screen), matching the "once per app session"
contract above. Call `ModalWidget.resetShown()` to clear it — e.g. on
logout, or between widget tests that assert modal behavior.
