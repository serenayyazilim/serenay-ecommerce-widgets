# TIMEIMAGE

A banner image with an optional "countdown to date" overlay: a title plus
boxed day/hour/minute/second fields.

```json
{
  "type": "TIMEIMAGE",
  "params": {
    "url": "https://.../banner.jpg",
    "date": "2026-08-01T00:00:00",
    "title": "Campaign Ends In",
    "title_color": "#FFFFFF",
    "title_position": "left",
    "position_top": 16,
    "position_left": 16,
    "aspect_ratio": 1.78,
    "fit": "cover"
  }
}
```

- `aspect_ratio` — width/height ratio of the banner (default `16/9` ≈
  `1.78`).
- `fit` — how the banner image fills its frame (default `"cover"`); same
  values as [IMAGE](image.md)'s `fit`.
- `date` — an ISO-8601 string or Unix timestamp (seconds). The countdown
  overlay only shows while this is in the future; once it passes, the
  overlay disappears (the image stays).
- `title` / `title_color` — optional label above the countdown box.
- `title_position` — `"left"` (default) or `"right"`, controls which side
  the overlay aligns to.
- `position_top` / `position_bottom` / `position_left` / `position_right`
  (or a nested `"position": { "top": ..., "left": ... }` map) — pixel
  offsets positioning the overlay over the image; defaults to the
  top-left/bottom-left corner based on `title_position`.

The countdown box shows a day field only when more than 0 days remain, and
always shows hours/minutes/seconds.
