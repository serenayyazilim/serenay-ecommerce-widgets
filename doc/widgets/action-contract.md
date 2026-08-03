# Action / tap contract

Shared by IMAGE, SLIDER, IMAGECAROUSEL, MODAL, MIXEDCAROUSEL's image page,
STORY's footer CTA, and SEARCH's submit. Any of these widgets' `params` (or a
slide/story item) is parsed into a `SerAction` via `SerAction.fromParams`,
then handed to `SerBuilderCallbacks.onAction` for the host app to resolve.

```json
{
  "type": "category",
  "id": 42,
  "url": "https://.../banner.jpg",
  "filter": "optional filter string, used when type=filter",
  "search_text": "optional free-text search, used when type=search",
  "goto": "https://external.example.com, used when type=link",
  "title": "optional list-screen title, used when type=filter",
  "name": "optional widget_type hint for unrecognized category types"
}
```

## `type` values

| `type` | Meaning |
|---|---|
| `category` | Navigate to a category screen; `id` is the category id. |
| `main_category` | Navigate to a top-level category screen; `id` is the category id. |
| `collection` | Product list filtered by `id` as a collection id. |
| `brand` / `brands` | Product list for a brand, or the brand list screen. |
| `group` | Product list filtered by `id` as a group id. |
| `filter` | Product list filtered by `filter` (or `id` if `filter` is empty). |
| `search` | Free search if `search_text` is set, otherwise `id` is a collection id. |
| `product` | Product detail screen; `id` is the product id. |
| `zoom` | Full-screen pinch-zoom photo gallery (SLIDER only). |
| `modal` | Fetch popup content by `id` and show it in a bottom sheet. |
| `login` | Navigate to the login screen. |
| `register` | Navigate to the registration screen. |
| `cyb` | Navigate to a business/B2B management screen. |
| `link` | Open the external URL in `goto`. |
| (empty/other) | Falls back to `category`. |

`SerAction` is a plain data class (`type`, `id`, `url`, `filter`, `searchText`,
`goto`, `title`, `name`) — resolving it into real navigation is entirely up
to your `onAction` callback; the widget catalog never navigates on its own.
