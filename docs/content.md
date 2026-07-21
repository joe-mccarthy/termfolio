# Content

Termfolio works best with conventional Hugo sections and page bundles. This guide covers the content structures understood by the theme; consult the [configuration guide](configuration.md) for site-wide settings.

## Recommended structure

```text
content/
├── _index.md
├── about/
│   └── index.md
├── posts/
│   ├── _index.md
│   └── my-first-post/
│       ├── index.md
│       └── cover.jpg
├── projects/
│   ├── _index.md
│   └── my-project/
│       └── index.md
├── categories/
│   └── theme-design/
│       └── _index.md
└── search/
    └── index.md
```

Use `_index.md` for branch bundles such as section and taxonomy landing pages. Use `index.md` for leaf bundles that keep a page and its local resources together.

## Posts

Create a post with Hugo's default archetype:

```bash
hugo new content/posts/my-first-post.md
```

For local images and other page resources, create a leaf bundle instead:

```bash
hugo new content/posts/my-first-post/index.md
```

A representative post header is:

```yaml
---
title: "My First Post"
date: 2026-07-16T10:00:00Z
draft: false
summary: "A short summary for lists, metadata, and search results."
subtitle: "An optional secondary heading."
categories: ["theme design"]
tags: ["hugo", "writing"]
series: ["Getting Started"]
toc: true
images:
- posts/my-first-post/cover.jpg
---
```

The page-level `toc` value overrides the site default. The first `images` value becomes the Open Graph and Twitter preview image; use a URL that Hugo can resolve from the published site root.

Set `draft: false` before a production build. During authoring, include drafts with `hugo server --buildDrafts`.

## Projects

Project pages use a repository-style layout with structured metadata. Create one with:

```bash
hugo new content/projects/my-project/index.md
```

The project archetype provides these fields:

```markdown
---
title: "Atlas Pantry"
date: 2026-02-12T09:00:00Z
draft: false
weight: 10
summary: "An offline recipe and stock planner for shared kitchens."
subtitle: "A concise project proposition."
year: 2026
projectType: "Offline tool"
status: "Prototype"
license: "MIT"
role: "Product design"
impact: "Shared kitchen planning"
stack: ["Hugo", "SQLite", "Service workers"]
demo: "https://example.org/projects/atlas-pantry"
repo: "https://example.org/repos/atlas-pantry"
---

## Problem

## Approach

## Result
```

| Field | Where it appears |
| --- | --- |
| `summary` | Project list cards. |
| `subtitle` | The individual project header. |
| `weight` | Project ordering. Lower values appear first. |
| `projectType`, `status`, and `license` | Project list cards and individual metadata. |
| `role`, `impact`, and `stack` | Individual project metadata. |
| `repo` and `demo` | Project action links. |
| `year` | Available to site overrides and content even though the bundled layouts currently derive the displayed update date from `date`. |

Omit empty optional values; the layouts do not render their labels when no value is present.

## Taxonomy pages

Configure categories, tags, and series in the site configuration, then assign terms in content front matter:

```yaml
categories: ["theme design"]
tags: ["hugo", "accessibility"]
series: ["Getting Started"]
```

Hugo generates an index for each taxonomy and a page for every term. Add descriptive content with a taxonomy branch bundle such as `content/categories/theme-design/_index.md`:

```yaml
---
title: Theme Design
summary: Posts about typography, layout, and code styling.
---

Posts about typography, layout, code styling, and the decisions that shape the theme.
```

Termfolio renders that introduction above the matching content list. The same structure works under `tags/` and `series/`.

## Shortcodes

Termfolio provides four content shortcodes:

### Figure

```markdown
{{< figure src="image.jpg" alt="Description" caption="A local image caption." >}}
```

Use `figure` when an image needs a caption. Always provide meaningful alternative text unless the image is purely decorative.

### Aside

```markdown
{{< aside title="Note" >}}
Short supporting text.
{{< /aside >}}
```

### Details

```markdown
{{< details summary="More context" >}}
Hidden-by-default details.
{{< /details >}}
```

### External link

```markdown
{{< external-link href="https://gohugo.io/" text="Hugo documentation" >}}
```

Use the external-link shortcode when the visual external-link treatment is useful. Ordinary Markdown links continue to work normally.

## Search

Search is optional and disabled by default. Both providers require a search content page:

```yaml
---
title: Search
layout: search
draft: false
summary: Search posts, projects, and pages.
---
```

Add `/search/` to the main menu if readers should be able to reach it from every page.

### Built-in provider

The `simple` provider creates a client-side index from regular Hugo pages:

```yaml
params:
  search:
    enabled: true
    provider: simple
```

It indexes titles, summaries or descriptions, taxonomy terms, dates, and plain-text content. Results are ranked in the browser and limited to the top 20 matches. Exclude an individual page with:

```yaml
searchExclude: true
```

The generated index grows with the site's text content. Review its size before choosing it for a large publication.

### Pagefind provider

For a larger site, configure Pagefind:

```yaml
params:
  search:
    enabled: true
    provider: pagefind
```

Build the site and run Pagefind against the output:

```bash
hugo
pagefind --site public
```

Deploy the generated `public/pagefind/` directory with the rest of the site. Termfolio loads `pagefind-ui.css` and `pagefind-ui.js` from that local directory, so the provider does not need a third-party runtime CDN.

## Images and static assets

- Put page-specific assets beside `index.md` in a leaf bundle when a shortcode or Markdown reference should resolve them as page resources.
- Put site-wide assets under the site's `static/` directory. Hugo copies them to the published root.
- Use paths relative to the configured `baseURL`, such as `images/social-preview.png`, for metadata assets stored under `static/`. This preserves any subpath in the site's base URL.
- Keep screenshots and diagrams compressed and provide descriptive alternative text.
- Markdown images scale to the content column by default; use the `figure` shortcode for captions.

Theme-owned fonts, icons, and CSS live under the theme's `static/` directory. Override them from the site only when you intend to maintain that divergence through theme upgrades.
