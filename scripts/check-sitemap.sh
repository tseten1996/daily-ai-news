#!/usr/bin/env bash
# Verify-only check: sitemap.xml must exactly match what
# scripts/generate-sitemap.sh produces from the current published pages
# and their git history. Does not modify anything or affect what ships —
# see docs/technical-debt/backlog.md #2 for why this is safe to run in CI
# without a build step.
set -euo pipefail

cd "$(dirname "$0")/.."

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

./scripts/generate-sitemap.sh "$tmp"

if ! diff -u sitemap.xml "$tmp"; then
  echo ""
  echo "sitemap.xml is out of date. Run ./scripts/generate-sitemap.sh to refresh it."
  exit 1
fi

echo "sitemap.xml is in sync with all published legacy pages."
