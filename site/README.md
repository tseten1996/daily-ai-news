# site/ — Astro pilot

This is a real, working [Astro](https://astro.build) project — the target
architecture for this repository's Articles stream, decided in
[`docs/decisions/ADR-0001-adopt-astro-for-spa-migration.md`](../docs/decisions/ADR-0001-adopt-astro-for-spa-migration.md).

**This is not yet deployed.** It does not replace or affect the live site
at the repo root (`index.html`, `articles/*.html`, `manual/*.html`) — see
the ADR for why, and `docs/roadmap/roadmap.md` for the CI/deploy wiring
follow-up.

## Commands

Run from inside `site/`:

| Command | Action |
|---|---|
| `npm install` | Install dependencies |
| `npm run dev` | Start the local dev server |
| `npm run build` | Build to `dist/` (static output) |
| `npm run preview` | Preview the built output locally |
| `npx astro check` | Type-check `.astro`/`.mdx` files and content front matter |

## Adding a new article

1. Copy `src/content/articles/example-post.mdx` to a new file named after
   your slug (e.g. `my-new-topic.mdx`).
2. Fill in the front matter (see `src/content.config.ts` for the schema —
   the build fails loudly if a field is missing or the wrong type).
3. Write the body in MDX. Use the shared components from `src/components/`
   (`CodeTabs`, `Figure`, `Judgment`, `FailureBlock`) for the recurring
   patterns the legacy articles hand-code inline — see the example post
   for usage of each.
4. `npm run build` and check `dist/articles/<slug>/index.html` for the
   expected output (title, meta description, canonical, OG/Twitter, JSON-LD
   are all generated automatically from the front matter — no manual
   `<head>` authoring needed).

Do not migrate the 3 already-published legacy articles
(`articles/*.html`) into this pipeline without first resolving
`docs/technical-debt/backlog.md` item 9 (duplicate-content risk of
running both versions live).
