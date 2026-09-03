# RECOMMENDEDFORYOU

A titled, horizontally-scrolling row of the shared rich product card — the
same [product query contract](product-query.md) as CAROUSEL, plus a header
(CAROUSEL has none) so a personalized recommendation rail reads as its own
section rather than blending into the feed.

```json
{
  "type": "RECOMMENDEDFORYOU",
  "params": {
    "title": "Recommended For You",
    "user_id": 42
  }
}
```

- `title` — header above the row. Falls back to
  `theme.recommendedForYouTitleLabel` ("Recommended For You").
- Every other field is forwarded to `ProductQuery.fromParams` (see
  [product-query.md](product-query.md)) — a typical backend keys this off
  `user_id`/browsing history server-side rather than a `category_id`, but
  the widget doesn't care what the query contains.
- Hides itself entirely when the fetched product list is empty.
