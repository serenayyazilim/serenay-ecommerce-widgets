# GRID

The same [product query contract](product-query.md) as
[CAROUSEL](carousel.md), rendered as a 2-column grid of the rich product
card instead of a horizontal row.

```json
{
  "type": "GRID",
  "params": { "search": "TEAM" }
}
```

See [product-card-data.md](product-card-data.md) for what each product in
the `fetchProducts` result should look like.

## Layout params (1.5.0)

All optional; defaults keep the previous layout. Sizes are px.

- `columns` — cards per row (default: `EcommerceWidgetTheme.gridColumns`, `2`).
- `spacing` — horizontal gap between cards (default `8`).
- `run_spacing` — vertical gap between rows (default: same as `spacing`).
- `padding_horizontal` / `padding_vertical` — outer padding (default `8` / `8`).
- `bg_color` — background, hex `"#RRGGBB"` (default transparent).
