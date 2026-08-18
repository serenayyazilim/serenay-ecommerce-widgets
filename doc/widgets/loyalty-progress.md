# LOYALTYPROGRESS

A "N more to go" progress bar — purchases toward a loyalty reward, spend
toward free shipping, etc. — styled from `theme.primaryColor`.

```json
{
  "type": "LOYALTYPROGRESS",
  "params": {
    "title": "Free Shipping Progress",
    "current": 65,
    "target": 100,
    "reward_text": "35 ₺ more for free shipping"
  }
}
```

- `target` — required and must be `> 0`; the widget renders nothing
  otherwise.
- `current` — clamped to `[0, target]`.
- `title` / `reward_text` — optional header and caption.
