# SIZEGUIDE

A "Size Guide" trigger button that opens a dialog with a measurement table
built from `params.headers`/`params.rows`. Entirely self-contained — no
navigation/fetch callback needed, since the table data ships inline with the
widget entry.

```json
{
  "type": "SIZEGUIDE",
  "params": {
    "button_label": "Size Guide",
    "title": "Size Guide",
    "headers": ["Size", "Chest (cm)", "Waist (cm)"],
    "rows": [
      ["S", "88-92", "72-76"],
      ["M", "96-100", "80-84"],
      ["L", "104-108", "88-92"]
    ]
  }
}
```

- `button_label` — the trigger button's text. Falls back to
  `theme.sizeGuideButtonLabel` ("Size Guide").
- `title` — the dialog's header. Falls back to the same
  `theme.sizeGuideButtonLabel`.
- `headers` — column headers.
- `rows` — one list of cell strings per row.
- Hides itself entirely when `headers` or `rows` is empty or missing.
