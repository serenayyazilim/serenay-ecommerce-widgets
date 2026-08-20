# Contributing

Thanks for taking the time to contribute!

## Setup

```bash
flutter pub get
cd example && flutter pub get && cd ..
```

Run the demo app with `cd example && flutter run`.

## Before opening a PR

```bash
flutter analyze
flutter test
```

Both must pass — CI runs the same checks on every pull request.

## Adding a new widget type

Each catalog widget follows the same pattern; use an existing one (e.g.
`lib/src/widgets/catalog/rating_widget.dart`) as a template:

1. Add the widget under `lib/src/widgets/catalog/`.
2. Register it in `WidgetCatalog` (`lib/src/widgets/widget_catalog.dart`).
3. Add a usage page under `doc/widgets/` and link it from
   `doc/widgets/README.md` and `mkdocs.yml`.
4. Add a widget test under `test/`.
5. Add a demo entry to `example/lib/main.dart`.
6. Note the addition in `CHANGELOG.md`.

## Pull requests

- Keep PRs focused on a single change.
- Update `CHANGELOG.md` for any user-facing change.
- Describe what changed and why in the PR description.

## Reporting bugs / requesting features

Use the [issue templates](.github/ISSUE_TEMPLATE) — they collect the info
needed to reproduce a bug or scope a feature request.
