# QNA

A vertical "Questions & Answers" card — each entry's question and answer,
plus an optional asker name/date. Reads its entries straight from
`params.list`, the same inline-list contract as CATEGORYMENU/REVIEWS.

```json
{
  "type": "QNA",
  "params": {
    "title": "Questions & Answers",
    "list": [
      {
        "question": "Does this run small?",
        "answer": "It's true to size, order your normal size.",
        "author": "Dana",
        "date": "3 days ago"
      }
    ]
  }
}
```

- `title` — header above the list. Falls back to `theme.qnaTitleLabel`
  ("Questions & Answers").
- `list` — the entries to render:
  - `question` — required; an entry with no `question` renders nothing.
  - `answer` — optional; omit for a question with no answer yet.
  - `author` / `date` — optional caption shown under the answer.
- Hides itself entirely when `list` is empty or missing.
