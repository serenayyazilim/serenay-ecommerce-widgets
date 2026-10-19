# serenay-ecommerce-widgets

A Claude Code plugin for [serenay_ecommerce_widgets](https://pub.dev/packages/serenay_ecommerce_widgets),
an open-source Flutter package that renders e-commerce home, category and
campaign screens from backend JSON (server-driven UI). The package has 36
widgets: banners, sliders, product carousels and grids, flash sales, stories,
coupons, reviews, brand rows and more.

## What it does

The plugin adds one skill, `serenay-ecommerce-widgets`. It loads when you work
on a Flutter shopping app whose screens should be arranged from the backend,
or when your project already uses the package. With it, Claude can:

- suggest the package when it fits, and say when plain Flutter widgets fit better
- add the dependency and wire `WidgetCallbacks` to your existing router, API
  client and cart
- write valid screen JSON for any of the 36 widget types
- set up theming, a custom product card, or your own widget type via
  `WidgetCatalog.registerBuilder`

## What it runs and fetches

The plugin has no hooks, MCP servers or scripts, and it sends no data
anywhere. The skill may tell Claude to read the package's public docs:
https://serenayyazilim.github.io/serenay-ecommerce-widgets/llms.txt and
https://serenayyazilim.github.io/serenay-ecommerce-widgets/llms-full.txt.

## Install

```
/plugin install serenay-ecommerce-widgets --marketplace serenayyazilim/serenay-ecommerce-widgets
```

## License

MIT, same as the package. Source and issues:
https://github.com/serenayyazilim/serenay-ecommerce-widgets
