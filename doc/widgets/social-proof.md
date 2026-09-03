# SOCIALPROOF

A slim "N people bought this recently" banner. When `params.list` holds more
than one recent-purchase entry, it cycles through them (one every 3s)
instead of showing a single static line.

```json
{
  "type": "SOCIALPROOF",
  "params": {
    "list": [
      {"name": "Ayşe", "time_ago": "5 min ago"},
      {"name": "Mert", "time_ago": "22 min ago"}
    ]
  }
}
```

- `text` — full override; when set, it's shown as-is and `list`/`count` are
  ignored.
- `list` — recent-purchase entries, each either `{"name": ..., "time_ago":
  ...}` or a plain string. With more than one entry, the banner cycles
  through them every 3 seconds with a fade transition.
- `count` — used only when both `text` and `list` are omitted: the widget
  builds its text from `theme.socialProofLabel` ("{count} people bought
  this recently") with `{count}` replaced by `count`.
- Hides itself entirely when there's nothing to show: no `text`, no `list`,
  and no `count`.
