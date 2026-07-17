import { defineCollection } from 'astro:content';
import { glob } from 'astro/loaders';
import { z } from 'zod';

// Mirrors the front-matter fields every legacy article HTML file already
// carries by hand (see articles/LEDGER.md and the HTML comment front-matter
// block at the top of each articles/*.html file) — same schema, now
// machine-checked instead of author-maintained by convention.
const articles = defineCollection({
  loader: glob({ pattern: '**/*.mdx', base: './src/content/articles' }),
  schema: z.object({
    title: z.string(),
    description: z.string().max(160, 'Keep meta descriptions crawler-friendly (<=160 chars).'),
    pillar: z.string(),
    difficulty: z.enum(['Foundations', 'Practitioner', 'Principal']),
    series: z.string(),
    tags: z.array(z.string()).min(1).max(6),
    publishDate: z.date(),
    readTime: z.string(),
    draft: z.boolean().default(false),
  }),
});

export const collections = { articles };
