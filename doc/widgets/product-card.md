# PRODUCTCARD

Visually and behaviorally identical to [GRID](grid.md) — a 2-column grid of
the rich product card, backed by the same
[product query contract](product-query.md). Kept as its own catalog entry
because backends address it as a distinct widget type (e.g. for a "product
card section" that's configured separately from a plain grid listing).

```json
{
  "type": "PRODUCTCARD",
  "params": { "category_id": 75 }
}
```

`PRODUCTIMAGE` (present in the type enum but with no distinct JSON schema
documented upstream) also maps to this same widget.

See [product-card-data.md](product-card-data.md) for the rich card's
favorite/discount/variant behavior.

## Layout params (1.5.0)

All optional; defaults keep the previous layout. Sizes are px.

- `columns` — cards per row (default: `EcommerceWidgetTheme.gridColumns`, `2`).
- `spacing` — horizontal gap between cards (default `8`).
- `run_spacing` — vertical gap between rows (default: same as `spacing`).
- `padding_horizontal` / `padding_vertical` — outer padding (default `8` / `8`).
- `bg_color` — background, hex `"#RRGGBB"` (default transparent).
