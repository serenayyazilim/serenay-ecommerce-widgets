# CATEGORYMENU

A horizontal row of circular category icons with a label underneath, each
resolving through the shared [action/tap contract](action-contract.md).
Unlike [STORY](story.md), tapping an item navigates directly instead of
opening a full-screen viewer.

```json
{
  "type": "CATEGORYMENU",
  "params": {
    "list": [
      {
        "title": "Shoes",
        "image": "https://example.com/shoes.png",
        "type": "category",
        "id": 1
      },
      {
        "title": "Sale",
        "image": "https://example.com/sale.png",
        "type": "filter",
        "id": "sale"
      }
    ]
  }
}
```

Each entry in `list` is a plain [action/tap contract](action-contract.md)
object plus `title` and `image`.
