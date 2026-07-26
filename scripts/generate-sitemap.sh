#!/usr/bin/env bash
# Regenerates sitemap.xml from the current set of published legacy HTML
# pages (repo root, articles/, manual/) plus each page's own git commit
# history. Replaces a hand-maintained sitemap.xml that went stale three
# times (2026-07-19, 2026-07-22, 2026-07-25) despite a documentation
# reminder and a verify-only CI check — see docs/technical-debt/backlog.md
# #2. Writes to sitemap.xml by default, or to the path given as $1.
set -euo pipefail

cd "$(dirname "$0")/.."

BASE_URL="https://tseten1996.github.io/daily-ai-news"
OUT="${1:-sitemap.xml}"

priority_and_freq() {
  case "$1" in
    index.html) echo "1.0 daily" ;;
    articles/index.html) echo "0.9 daily" ;;
    manual/index.html) echo "0.9 weekly" ;;
    *) echo "0.7 monthly" ;;
  esac
}

url_for() {
  local rel="$1" dir
  dir="$(dirname "$rel")"
  if [ "$(basename "$rel")" = "index.html" ]; then
    if [ "$dir" = "." ]; then echo "$BASE_URL/"; else echo "$BASE_URL/$dir/"; fi
  else
    echo "$BASE_URL/$rel"
  fi
}

lastmod_for() {
  local rel="$1" date
  date="$(git log -1 --format=%ad --date=short -- "$rel" 2>/dev/null || true)"
  if [ -z "$date" ]; then
    date="$(date -u +%F)"
  fi
  echo "$date"
}

{
  echo '<?xml version="1.0" encoding="UTF-8"?>'
  echo '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
  while IFS= read -r -d '' file; do
    rel="${file#./}"
    url="$(url_for "$rel")"
    lastmod="$(lastmod_for "$rel")"
    read -r priority freq <<< "$(priority_and_freq "$rel")"
    printf '  <url>\n    <loc>%s</loc>\n    <lastmod>%s</lastmod>\n    <changefreq>%s</changefreq>\n    <priority>%s</priority>\n  </url>\n' \
      "$url" "$lastmod" "$freq" "$priority"
  done < <(find . -name "*.html" -not -path "./site/*" -not -path "./.git/*" -print0 | sort -z)
  echo '</urlset>'
} > "$OUT"
