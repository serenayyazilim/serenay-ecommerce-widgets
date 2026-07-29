# Product card data

The shape every product returned from `SerBuilderCallbacks.fetchProducts`
should have, used by CAROUSEL, GRID, PRODUCTCARD, FLASHSALE and
MIXEDCAROUSEL's product page. Only `id`, `image` and `title` are required —
everything else is optional and the rich product card degrades gracefully
when a field is missing (hides it, or falls back to `priceText`).

```json
{
  "id": 123,
  "image": "https://.../product.jpg",
  "title": "Product name",
  "subtitle": "Brand name",
  "subtitle2": "Optional second subtitle line",
  "price": 199.90,
  "price_old": 249.90,
  "discount": "20",
  "currency": "tl",
  "brand_id": 5,
  "variants": [
    { "id": "v1", "name": "Red", "image": "https://.../red.jpg" }
  ],
  "package_qty": 1,
  "qty_in_package": 1,
  "prices": [{ "price": 199.90, "currency": "tl" }],
  "is_favorited": false,
  "measure_name": "kg",
  "measure_options": ["S", "M", "L"],
  "price_text": "Call for price",
  "sale_disabled": false,
  "sale_disabled_reason": "Out of stock",
  "unit_price": "10.50",
  "unit_price_text": "10.50 / kg"
}
```

## Behavior notes

- **Price hiding**: when `SerBuilderCallbacks.isLoggedIn` returns `false`,
  the rich product card shows a bordered "View Prices" button instead of the
  price, and taps it call `onRequireAuth` — common in B2B/reseller apps.
- **Discount badge**: shown when `discount` is a non-empty, non-`"0"`
  string; rendered as `%{discount}` with a tag icon.
- **Variants**: with more than one entry, the card's image area becomes a
  swipeable photo slider with a dot indicator, plus a variant-count chip
  that opens a bottom sheet (color thumbnails + a quantity stepper +
  `onAddToCart`). A single variant (or none) just shows `image`.
- **`sale_disabled`**: when `true`, the variant sheet shows
  `sale_disabled_reason` instead of the quantity/add-to-cart row.
- **`price` vs `price_text`**: `price_text` (e.g. "Call for price") is shown
  instead of a numeric price whenever `price` is null or `0`.
