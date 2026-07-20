# Configuration

Termfolio uses Hugo's standard site configuration. YAML, TOML, and JSON are supported; this guide uses YAML. The repository's [example configuration](../example-config.yaml) is the canonical copy-ready starting point.

## Requirements

- Set `theme: termfolio` after installing the theme in `themes/termfolio`.
- Use Hugo `0.128.0` or newer. Hugo Extended is not required.
- Set `markup.highlight.noClasses: false` to use the bundled Chroma syntax colours.
- Set `defaultContentLanguage` so the rendered `<html lang>` value identifies the site's language.

## Complete example

```yaml
baseURL: https://example.org/
defaultContentLanguage: en-gb
title: Site Title
theme: termfolio

pagination.pagerSize: 10

markup:
  highlight:
    noClasses: false

menu:
  main:
  - identifier: home
    name: Home
    url: /
    weight: 1
  - identifier: about
    name: About
    url: /about/
    weight: 2
  - identifier: posts
    name: Posts
    url: /posts/
    weight: 3
  - identifier: projects
    name: Projects
    url: /projects/
    weight: 4
  - identifier: categories
    name: Categories
    url: /categories/
    weight: 5
  - identifier: tags
    name: Tags
    url: /tags/
    weight: 6
  - identifier: series
    name: Series
    url: /series/
    weight: 7
  - identifier: search
    name: Search
    url: /search/
    weight: 8

params:
  author: Blog Author
  description: "A short description for metadata and social previews."
  sourceURL: https://github.com/your-name/your-site
  images:
  - social-preview.png
  mainSections:
  - posts
  style:
    maxWidth: 820px
    accentColor: "#9cd4c2"
  display:
    footerAttribution: true
    taxonomyMeta: true
  toc:
    enabled: true
    title: Contents
  search:
    enabled: true
    provider: simple
  latest:
    enabled: true
    count: 3
  license:
    name: CC BY-SA 4.0
    url: https://creativecommons.org/licenses/by-sa/4.0/
  abbrDateFmt: "01/02"
  dateFmt: "06/01/02"
  social:
  - name: GitHub
    url: https://github.com/your-name/your-site
  - name: RSS
    url: index.xml
  post_nav:
    enabled: true
    show_title: false

taxonomies:
  tag: tags
  category: categories
  series: series
```

Replace example URLs, identity, licence, and social image values before publishing.

## Navigation

Termfolio renders Hugo's `main` menu in ascending `weight` order. Each item needs a stable `identifier`, a visible `name`, and a site-relative or absolute `url`.

```yaml
menu:
  main:
  - identifier: home
    name: Home
    url: /
    weight: 1
  - identifier: posts
    name: Posts
    url: /posts/
    weight: 2
```

Use leading and trailing slashes for section URLs so navigation works consistently with Hugo's generated routes. Remove menu items for sections that your site does not publish.

## Taxonomies

The theme includes index and term layouts for categories, tags, and series:

```yaml
taxonomies:
  category: categories
  tag: tags
  series: series
```

Defining a taxonomy enables its Hugo-generated index and term routes. Add a corresponding menu item when readers should be able to browse it directly. Custom taxonomies require site-level layouts if they need presentation beyond Hugo's defaults.

See the [content guide](content.md#taxonomy-pages) for term descriptions and content front matter.

## Parameters

### Identity and metadata

| Parameter | Purpose |
| --- | --- |
| `params.author` | Default author used in page metadata and the footer. The footer falls back to `Blog Author`. |
| `params.description` | Site-wide fallback description for HTML, Open Graph, and Twitter metadata. |
| `params.images` | Default social-preview image list. The first image is used when a page has no `images` value. |
| `params.prompt` | Header prompt text. The default is `guest@termfolio:~$`. |
| `params.sourceURL` | Optional source-repository link in the footer. Omit it to hide the line. |
| `params.license.name` | Content licence name shown in the footer. |
| `params.license.url` | Site-relative or absolute URL for the content licence. |
| `params.social` | Ordered footer links, each with `name` and `url`. Relative URLs are resolved against the site. |

The theme's MIT licence covers its source code. `params.license` describes the separate licence you choose for your site's content.

### Lists and reading

| Parameter | Purpose |
| --- | --- |
| `params.mainSections` | Content types included on the home page and in latest-content lists. Defaults to `posts`. |
| `params.display.footerAttribution` | Shows Hugo and Termfolio attribution unless explicitly set to `false`. |
| `params.display.taxonomyMeta` | Shows category, tag, and series metadata unless explicitly set to `false`. |
| `params.toc.enabled` | Enables a table of contents for pages with headings. A page-level `toc` value can override it. |
| `params.toc.title` | Table-of-contents heading. Defaults to `Contents`. |
| `params.latest.enabled` | Shows related latest content below individual posts. |
| `params.latest.count` | Maximum latest-content links. Defaults to `3`. |
| `params.post_nav.enabled` | Enables previous and next navigation for posts and projects. Set this explicitly for consistent behaviour. |
| `params.post_nav.show_title` | Uses neighbouring page titles instead of generic previous and next labels. |
| `params.dateFmt` | Go reference-time format used for rendered page dates. |
| `params.abbrDateFmt` | Compatibility setting retained by the example configuration; current layouts use `dateFmt`. |

Hugo date formats use the reference time `Mon Jan 2 15:04:05 MST 2006`. For example:

```yaml
params:
  dateFmt: "2006-01-02"
```

### Search

| Parameter | Purpose |
| --- | --- |
| `params.search.enabled` | Enables search behaviour on a page using the `search` layout. |
| `params.search.provider` | Selects `simple` or `pagefind`; defaults to `simple` when search is enabled. |

Search is disabled unless `enabled` is `true`. The built-in provider creates its index at Hugo build time. Pagefind needs a separate post-build indexing step. See [Search](content.md#search) for setup instructions.

## Styling

Termfolio is intentionally dark-only. Site-level style parameters override the theme's CSS custom properties without replacing the main stylesheet.

### Layout and accent colour

```yaml
params:
  style:
    maxWidth: 820px
    accentColor: "#75d7ff"
```

`maxWidth` controls the main content width. Use any valid CSS length, such as `820px`, `70rem`, or `100%`.

### Full palette

```yaml
params:
  style:
    maxWidth: 1200px
    bgColor: "#050705"
    fontColor: "#d8f8d0"
    mutedColor: "#83a38c"
    linkColor: "#75d7ff"
    visitedColor: "#d7a8ff"
    accentColor: "#9bf870"
    borderColor: "#2d4a34"
    preColor: "#eaffdf"
    preBgColor: "#020402"
    codeBgColor: "#111a13"
```

After changing the palette, check text, links, controls, focus states, code blocks, and visited links for adequate contrast.

### Custom CSS

Load site-owned styles after the theme stylesheet:

```yaml
params:
  customStylesheets:
  - css/custom.css
```

Place the referenced file under the site's `static/` directory:

```css
/* static/css/custom.css */
.site-header {
  border-color: #9bf870;
}
```

Prefer small, documented overrides so future theme upgrades remain easy to review.

## Troubleshooting

| Problem | Check |
| --- | --- |
| Theme is not loading | Confirm `theme: termfolio` and that the theme is present at `themes/termfolio`. |
| Styles look incomplete | Confirm `static/css/termfolio.css` is being served and inspect custom CSS for conflicting overrides. |
| Code highlighting looks plain | Set `markup.highlight.noClasses: false` so Hugo emits Chroma classes. |
| Page language is incorrect | Set `defaultContentLanguage` to the site's primary BCP 47 language tag. |
| Content is missing | Confirm pages are not drafts, or use `hugo server --buildDrafts` during development. |
| Taxonomy routes are missing | Define the taxonomy under `taxonomies` and add terms to published content. |
| Search page is blank | Confirm search is enabled, the page uses `layout: search`, and the selected provider has been built. |

For rendering and toolchain problems, see [Development](development.md#troubleshooting).
