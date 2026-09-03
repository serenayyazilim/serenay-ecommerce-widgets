# REVIEWS

A horizontally-scrolling row of customer review cards — author, star rating,
comment and an optional "Verified Purchase" badge — with an optional
aggregate rating/count header, matching RATING's summary style. Reads its
entries straight from `params.list` (no fetch callback), the same
inline-list contract as CATEGORYMENU.

```json
{
  "type": "REVIEWS",
  "params": {
    "title": "Customer Reviews",
    "average_rating": 4.5,
    "review_count": 128,
    "list": [
      {
        "author": "Alice",
        "avatar": "https://example.com/avatar1.jpg",
        "rating": 5,
        "comment": "Loved it, fits perfectly!",
        "date": "2 days ago",
        "verified": true
      },
      {
        "author": "Bob",
        "rating": 3,
        "comment": "It was okay, shipping took a while."
      }
    ]
  }
}
```

- `title` — header above the row. Falls back to `theme.reviewsTitleLabel`
  ("Customer Reviews").
- `average_rating` / `review_count` — optional aggregate shown next to the
  title (e.g. "★ 4.5 (128)"). Omit either to hide that part of the header.
- `list` — the reviews to render, each rendered as its own card:
  - `author` — reviewer name.
  - `avatar` — optional image URL; falls back to a circle with the author's
    initial when omitted or empty.
  - `rating` — 0-5, rendered as a 5-star row (rounded to the nearest whole
    star).
  - `comment` — review text, clamped to 4 lines.
  - `date` — optional caption (e.g. "2 days ago" or a formatted date
    string — the widget doesn't parse it).
  - `verified` — when `true`, shows `theme.reviewsVerifiedLabel`
    ("Verified Purchase") next to the stars.
- Hides itself entirely when `list` is empty or missing.
