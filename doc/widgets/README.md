# Widget catalog

[→ Live demo](../) — see every widget rendered in the browser.

<p>
  <img src="Video-0.webp" width="280" alt="Widget catalog demo 1" />
  <img src="Video-2.webp" width="280" alt="Widget catalog demo 2" />
</p>

Usage docs for every widget type `WidgetCatalog.getScreen` can render. Each page
covers the `params` a backend sends for that widget, an example JSON entry,
and any widget-specific behavior. Three contracts are shared across most
widgets and documented once:

- [Action/tap contract](action-contract.md) — the `type`/`id`/`url` shape
  used to resolve navigation (IMAGE, SLIDER, MODAL, MIXEDCAROUSEL, STORY, ...).
- [Product query contract](product-query.md) — the `params` shape
  `fetchProducts` receives (CAROUSEL, GRID, PRODUCTCARD, FLASHSALE, MIXEDCAROUSEL).
- [Product card data](product-card-data.md) — the shape each product in a
  `fetchProducts` result should have.

## Widgets

| `type` | Doc |
|---|---|
| `TEXT` | [text.md](text.md) |
| `DIVIDER` | [divider.md](divider.md) |
| `IMAGE` | [image.md](image.md) |
| `IMAGELIST` | [image-list.md](image-list.md) |
| `SLIDER` | [slider.md](slider.md) |
| `IMAGECAROUSEL` | [image-carousel.md](image-carousel.md) |
| `CAROUSEL` | [carousel.md](carousel.md) |
| `GRID` | [grid.md](grid.md) |
| `PRODUCTCARD` | [product-card.md](product-card.md) |
| `FLASHSALE` | [flash-sale.md](flash-sale.md) |
| `MODAL` | [modal.md](modal.md) |
| `MIXEDCAROUSEL` | [mixed-carousel.md](mixed-carousel.md) |
| `VIDEOLIST` | [video-list.md](video-list.md) |
| `STORY` | [story.md](story.md) |
| `VISITEDPRODUCTS` | [visited-products.md](visited-products.md) |
| `TIMEIMAGE` | [time-image.md](time-image.md) |
| `YOUTUBE` | [youtube.md](youtube.md) |
| `SEARCH` | [search.md](search.md) |
| `FASTREGISTER` | [fast-register.md](fast-register.md) |
| `RATING` | [rating.md](rating.md) |
| `BUNDLE` | [bundle.md](bundle.md) |
| `COUPON` | [coupon.md](coupon.md) |
| `CATEGORYMENU` | [category-menu.md](category-menu.md) |
| `LOYALTYPROGRESS` | [loyalty-progress.md](loyalty-progress.md) |
| `COMPARISON` | [comparison.md](comparison.md) |
| `ABANDONEDCART` | [abandoned-cart.md](abandoned-cart.md) |
| `REVIEWS` | [reviews.md](reviews.md) |
| `QNA` | [qna.md](qna.md) |
| `URGENCY` | [urgency.md](urgency.md) |
| `RECOMMENDEDFORYOU` | [recommended-for-you.md](recommended-for-you.md) |
| `SOCIALPROOF` | [social-proof.md](social-proof.md) |
| `SIZEGUIDE` | [size-guide.md](size-guide.md) |
| `TRUSTBADGES` | [trust-badges.md](trust-badges.md) |
| any other value | rendered as an empty 1px box (forward compatibility) |

For install and quick-start (`WidgetCallbacks`, `WidgetCatalog.getScreen`),
see the [root README](https://github.com/serenayyazilim/serenay-ecommerce-widgets#readme).
