# RATING

A star rating row plus an optional review count. Uses
`EcommerceWidgetTheme.ratingFilledColor` / `ratingEmptyColor` / `starSize`.

```json
{
  "type": "RATING",
  "params": {
    "rating": 4.5,
    "max_rating": 5,
    "review_count": 328
  }
}
```

- `rating` — clamped to `[0, max_rating]`; fractional values render a
  partially-filled star.
- `max_rating` — number of stars drawn. Defaults to `5`.
- `review_count` — shown as `(N)` next to the rating value, when present.
- `label` — free-text overriding the default `rating.toStringAsFixed(1)`
  text (e.g. `"4.5 / 5"`).
