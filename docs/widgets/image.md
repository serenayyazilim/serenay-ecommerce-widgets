# IMAGE

A single tappable banner image, using the shared
[action/tap contract](action-contract.md).

```json
{
  "type": "IMAGE",
  "params": {
    "url": "https://.../banner.jpg",
    "type": "category",
    "id": 42,
    "height_percent": 0.3,
    "radius": 12,
    "padding": 16
  }
}
```

- `height_percent` — height as a fraction of the available width. Omit for
  a natural/unconstrained height.
- `radius` — corner radius; `0` (default) means square corners.
- `padding` — outer padding on all sides; `0` (default) means none.
- A failed image load falls back to a placeholder icon instead of erroring.
- When `type` is `login` or `register` and `SerBuilderCallbacks.isLoggedIn`
  returns `true`, the widget hides itself entirely (no point telling an
  already-logged-in user to log in).

See [action-contract.md](action-contract.md) for every other field
(`filter`, `search_text`, `goto`, `title`, `name`) and what each `type`
value does on tap.
