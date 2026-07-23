#!/usr/bin/env bash
# Verify-only check: every published HTML page under the legacy site
# (repo root, articles/, manual/) has a matching <loc> entry in
# sitemap.xml. Does not modify anything or affect what ships — see
# docs/technical-debt/backlog.md #2/#6 for why this is safe to run in CI
# without a build step.
set -euo pipefail

cd "$(dirname "$0")/.."

BASE_URL="https://tseten1996.github.io/daily-ai-news"
missing=0

while IFS= read -r -d '' file; do
  rel="${file#./}"
  dir="$(dirname "$rel")"

  if [ "$(basename "$rel")" = "index.html" ]; then
    if [ "$dir" = "." ]; then
      url="$BASE_URL/"
    else
      url="$BASE_URL/$dir/"
    fi
  else
    url="$BASE_URL/$rel"
  fi

  if ! grep -qF "<loc>$url</loc>" sitemap.xml; then
    echo "MISSING from sitemap.xml: $rel (expected <loc>$url</loc>)"
    missing=$((missing + 1))
  fi
done < <(find . -name "*.html" -not -path "./site/*" -not -path "./.git/*" -print0)

if [ "$missing" -gt 0 ]; then
  echo ""
  echo "$missing published page(s) are missing from sitemap.xml."
  exit 1
fi

echo "sitemap.xml is in sync with all published legacy pages."
