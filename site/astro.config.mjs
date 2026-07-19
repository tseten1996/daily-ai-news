import { defineConfig } from 'astro/config';
import mdx from '@astrojs/mdx';

// Placeholder — replace with the real production origin when this pipeline
// is cut over to serve the live site (see docs/decisions/ADR-0001, "deployment
// wiring" is an explicit follow-up, not part of this scaffold).
const SITE_URL = 'https://example.com';

export default defineConfig({
  site: SITE_URL,
  integrations: [mdx()],
  build: {
    format: 'directory',
  },
});
