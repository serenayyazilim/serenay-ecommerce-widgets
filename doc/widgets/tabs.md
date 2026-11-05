# TABS

A row of tab labels over a product row: "Best Sellers | New In | On Sale"
in one section. Each tab is its own [CAROUSEL](carousel.md) with its own
[product query](product-query.md).

```json
{
  "type": "TABS",
  "params": {
    "limit": 10,
    "tabs": [
      { "title": "Best Sellers", "category_id": 75, "order_by": "sales|DESC" },
      { "title": "New In", "category_id": 75, "order_by": "id|DESC" },
      { "title": "On Sale", "type": "collection", "id": 12 }
    ]
  }
}
```

- `tabs` — the tabs, in order. Each needs a `title`; the rest of the tab is
  a [product query](product-query.md) (`category_id`, `type` + `id`,
  `order_by`, ...). Tabs without a `title` are dropped.

A tab fetches its products the first time it's opened and keeps them when
the user switches back. A tab whose query returns no products shows an
empty row; the tab labels stay.

All other params are optional. Sizes are px.

- Any [CAROUSEL](carousel.md) param (`limit`, `item_width`, `height`,
  `item_spacing`, `padding_horizontal`, `autoplay`, ...) set next to `tabs`
  applies to every tab. The same key inside a tab overrides it for that tab.
- `initial_index` — tab open at start (default `0`).
- `selected_color` — label and underline of the open tab, hex (default:
  theme `primaryColor`).
- `text_color` — other labels, hex (default: theme `textSecondaryColor`).
- `text_size` — default `14`.
- `tab_spacing` — gap between labels (default `20`).
- `bg_color` — background of the whole section, hex.

Renders nothing when no tab has a `title`.
