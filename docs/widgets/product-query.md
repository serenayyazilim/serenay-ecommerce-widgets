# Product query contract

Shared by CAROUSEL, GRID, PRODUCTCARD, FLASHSALE and MIXEDCAROUSEL's
`item_type: "products"` page. Each of these widgets converts its `params`
into a `ProductQuery` via `ProductQuery.fromParams`, then calls
`SerBuilderCallbacks.fetchProducts(query)` to get the products to render.

Two equivalent shapes are accepted:

**A `type` + `id` pair**, resolved the same way as the
[action contract](action-contract.md):

```json
{ "type": "category", "id": 75 }
```

| `type` | Resolves to |
|---|---|
| `category` / `main_category` | `categoryId` |
| `collection` | `collectionId` |
| `brand` / `brands` | `brandId` |
| `group` | `groupId` |
| `filter` | `filter` (uses `params.filter`, or `id` if that's absent) |
| `search` | `search` (uses `params.search_text`), or `collectionId = id` if absent |
| (other) | `categoryId` |

**Or direct filter fields**, read as-is when there's no `type`/`id`:

```json
{
  "category_id": 75,
  "collection_id": null,
  "brand_id": null,
  "group_id": null,
  "search": "OKUL",
  "search_fields": "title,subtitle",
  "order_by": "id|DESC",
  "limit": 10,
  "page": 1,
  "filter_name": "optional label",
  "except_product_ids": [1, 2, 3],
  "filter": "optional raw filter string",
  "link": "optional",
  "is_favorited_list": false,
  "is_bundle_product": false
}
```

`order_by` is a raw `"field|DIRECTION"` string (e.g. `"id|DESC"`), forwarded
to your backend unparsed.

`fetchProducts` must return a `List<ProductCardData>` — see
[product-card-data.md](product-card-data.md) for that shape.
