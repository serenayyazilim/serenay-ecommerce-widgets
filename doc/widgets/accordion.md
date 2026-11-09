# ACCORDION

Collapsible sections: FAQ entries, "Shipping & Returns", product details.
Each section opens and closes independently. Reads its entries straight
from `params.list`, the same inline-list contract as [QNA](qna.md).

```json
{
  "type": "ACCORDION",
  "params": {
    "title": "FAQ",
    "initial_index": 0,
    "list": [
      { "title": "When will my order ship?", "text": "Orders placed before 3 PM ship the same day." },
      { "title": "How do returns work?", "text": "Return any item within 30 days for free." }
    ]
  }
}
```

- `list` — the sections. Each needs a `title` (the always-visible header);
  `text` is shown when it's open. Sections without a `title` are dropped.

All other params are optional. Sizes are px.

- `title` — header above the sections (default: none).
- `initial_index` — section open at start (default: all closed).
- `text_color` — section headers, hex (default: theme `textPrimaryColor`).
- `text_size` — section headers (default `14`).
- `bg_color` — card background, hex (default: theme `surfaceColor`).

Renders nothing when there is no titled section.
