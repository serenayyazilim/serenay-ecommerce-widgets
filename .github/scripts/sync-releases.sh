#!/usr/bin/env bash
# Mirrors every "## X.Y.Z" section of CHANGELOG.md into the GitHub release
# for tag vX.Y.Z: updates the notes of releases that exist, creates the
# missing ones. A version with no tag is skipped, except the current
# pubspec version, whose tag is created at $TARGET (default: HEAD).
set -euo pipefail

current=$(sed -n 's/^version: *//p' pubspec.yaml)
target=${TARGET:-$(git rev-parse HEAD)}
git fetch --tags --quiet || true

for ver in $(sed -n 's/^## \([0-9][0-9.]*\) *$/\1/p' CHANGELOG.md); do
  tag="v$ver"
  notes=$(awk -v v="$ver" '
    $0 == "## " v { on = 1; next }
    /^## / && on { exit }
    on { print }
  ' CHANGELOG.md | sed -e :a -e '/^\n*$/{$d;N;ba' -e '}' | sed '/./,$!d')

  if gh release view "$tag" >/dev/null 2>&1; then
    if [ "$(gh release view "$tag" --json body -q .body)" != "$notes" ]; then
      gh release edit "$tag" --notes "$notes" >/dev/null
      echo "updated $tag"
    fi
  elif git rev-parse -q --verify "refs/tags/$tag" >/dev/null; then
    gh release create "$tag" --verify-tag --title "$tag" --notes "$notes" --latest=false >/dev/null
    echo "created $tag"
  elif [ "$ver" = "$current" ]; then
    gh release create "$tag" --target "$target" --title "$tag" --notes "$notes" >/dev/null
    echo "created $tag at $target"
  else
    echo "skipped $tag (no tag)"
  fi
done

gh release edit "v$current" --latest >/dev/null 2>&1 && echo "latest: v$current" || true
