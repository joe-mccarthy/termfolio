# Termfolio

A dark, terminal-inspired Hugo theme for technical blogs, project portfolios, and repository-style personal sites.

[![Build](https://img.shields.io/github/actions/workflow/status/joe-mccarthy/termfolio/render-example-test.yml?branch=main&style=flat-square&label=build)](https://github.com/joe-mccarthy/termfolio/actions/workflows/render-example-test.yml) [![Quality gate](https://img.shields.io/sonar/quality_gate/joe-mccarthy_termfolio?server=https%3A%2F%2Fsonarcloud.io&style=flat-square)](https://sonarcloud.io/summary/overall?id=joe-mccarthy_termfolio) [![Latest release](https://img.shields.io/github/v/release/joe-mccarthy/termfolio?sort=semver&style=flat-square&label=release)](https://github.com/joe-mccarthy/termfolio/releases/latest) [![MIT licence](https://img.shields.io/github/license/joe-mccarthy/termfolio?style=flat-square)](LICENSE)

Termfolio presents static content through a filesystem-inspired interface. It combines shell prompts and file-list navigation with layouts for long-form writing, structured project metadata, locally hosted fonts, and privacy-conscious defaults.

![Termfolio example site walkthrough](static/images/termfolio-example.gif)

[Live demo](https://joe-mccarthy.github.io/termfolio/) · [Screenshots](#screenshots) · [Quick start](#quick-start) · [Documentation](#documentation) · [Releases](https://github.com/joe-mccarthy/termfolio/releases)

## Features

| Feature | Description |
| --- | --- |
| Terminal-inspired interface | Shell prompts, command-style labels, and file-list navigation provide a consistent visual language. |
| Dark-only design | A focused terminal palette remains consistent across browsers and operating systems. |
| Privacy-conscious defaults | No analytics, cookies, comments, tracking, CDN fonts, or third-party runtime dependencies. |
| Minimal client-side code | Standard pages are HTML and CSS; JavaScript is used only when optional search is enabled. |
| Long-form content | Prose, footnotes, tables, figures, blockquotes, code blocks, and Chroma highlighting are styled by default. |
| Structured projects | Project layouts support stack, status, role, impact, demo, repository, licence, and year metadata. |
| Optional static search | Use the built-in search provider or Pagefind for larger content collections. |
| Rich site metadata | JSON-LD, Open Graph, Twitter Cards, canonical URLs, RSS, active navigation, and taxonomy pages are included. |

## Screenshots

| Home | Post |
| --- | --- |
| <img src="static/images/screenshots/home.png" alt="Termfolio homepage screenshot" width="420"> | <img src="static/images/screenshots/post.png" alt="Termfolio post screenshot" width="420"> |

| Projects | Search |
| --- | --- |
| <img src="static/images/screenshots/projects.png" alt="Termfolio projects screenshot" width="420"> | <img src="static/images/screenshots/search.png" alt="Termfolio search screenshot" width="420"> |

## Requirements

- Hugo `0.128.0` or newer; Hugo Extended is not required.
- Git, when installing the theme as a submodule.
- YAML, TOML, or JSON configuration. This documentation uses YAML.
- Pagefind, only when using `params.search.provider: pagefind`.

Termfolio is designed for technical blogs, engineering notebooks, personal portfolios, repository indexes, and privacy-conscious publications. Its dark-only, content-first design is less suitable for image-led magazines, conversion-focused marketing sites, or applications with substantial client-side interaction.

## Quick start

Create a Hugo site and install Termfolio as a Git submodule:

```bash
hugo new site mysite -f yaml
cd mysite
git init
git submodule add https://github.com/joe-mccarthy/termfolio themes/termfolio
```

Add a minimal `config.yaml`:

```yaml
baseURL: https://example.org/
defaultContentLanguage: en-gb
title: My Termfolio Site
theme: termfolio

pagination.pagerSize: 10

markup:
  highlight:
    noClasses: false

params:
  author: Your Name
  description: "A short description for metadata and social previews."
  mainSections:
  - posts
  style:
    accentColor: "#9bf870"
```

Create a post and start the development server:

```bash
hugo new content/posts/hello-terminal.md
hugo server --buildDrafts
```

Open [http://localhost:1313/](http://localhost:1313/). See the [configuration guide](docs/configuration.md) before deploying a production site.

## Installation

### Git submodule

The recommended installation method keeps the theme version visible in your site's Git history:

```bash
git submodule add https://github.com/joe-mccarthy/termfolio themes/termfolio
```

Set `theme: termfolio` in your Hugo configuration. To update later:

```bash
git submodule update --remote --merge
```

Review the incoming changes before committing the updated submodule reference.

### Release archive

1. Download the [latest release](https://github.com/joe-mccarthy/termfolio/releases/latest).
2. Extract it into your site's `themes/termfolio` directory.
3. Set `theme: termfolio` in your Hugo configuration.

Release archives are convenient for installations that do not use Git submodules. Record the installed release version so upgrades remain reproducible.

## Essential configuration

The following settings enable the most commonly used theme features:

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
  - identifier: projects
    name: Projects
    url: /projects/
    weight: 3

params:
  sourceURL: https://github.com/your-name/your-site
  display:
    footerAttribution: true
    taxonomyMeta: true
  toc:
    enabled: true
    title: Contents
  latest:
    enabled: true
    count: 3
  post_nav:
    enabled: true
    show_title: false

taxonomies:
  category: categories
  tag: tags
  series: series
```

A complete, copy-ready configuration is available in [example-config.yaml](example-config.yaml). Every supported option is described in [docs/configuration.md](docs/configuration.md).

## Documentation

| Guide | Covers |
| --- | --- |
| [Configuration](docs/configuration.md) | Navigation, taxonomies, parameters, styling, search settings, and troubleshooting. |
| [Content](docs/content.md) | Posts, projects, taxonomy pages, shortcodes, search content, and local assets. |
| [Development](docs/development.md) | Example-site workflow, repository structure, checks, CI, media, and maintainer troubleshooting. |
| [Contributing](CONTRIBUTING.md) | Development setup, validation expectations, and the pull-request process. |
| [Support](SUPPORT.md) | Routes for usage questions, bug reports, feature requests, and showcase submissions. |
| [Releasing](RELEASING.md) | Versioning, candidate preparation, publication automation, and independent verification. |
| [Release checklist](docs/release-checklist.md) | The concise checklist used for an exact release candidate. |
| [Hugo Themes submission](docs/hugo-themes-submission.md) | Gallery metadata, media requirements, and submission steps. |
| [Changelog](CHANGELOG.md) | Long-term project history. |

## Demo and starter site

The bundled example demonstrates posts, projects, search, taxonomies, and the full configuration surface:

- [Home](https://joe-mccarthy.github.io/termfolio/)
- [Posts](https://joe-mccarthy.github.io/termfolio/posts/)
- [Projects](https://joe-mccarthy.github.io/termfolio/projects/)
- [Code and terminal post](https://joe-mccarthy.github.io/termfolio/posts/theme-showcase/code-and-terminal/)
- [Search](https://joe-mccarthy.github.io/termfolio/search/)
- [Theme design category](https://joe-mccarthy.github.io/termfolio/categories/theme-design/)

To run or copy the starter site, follow the [example-site instructions](docs/development.md#run-the-example-site). Public sites using Termfolio may be proposed with the repository's [showcase issue template](.github/ISSUE_TEMPLATE/showcase.yml).

## Accessibility and performance

Termfolio uses semantic landmarks, skip links, visible focus states, active navigation state, and a high-contrast palette. Standard reading and navigation do not require JavaScript. The theme bundles JetBrains Mono locally and includes no analytics, tracking scripts, remote embeds, or CDN assets by default.

Run a production build after adding your own content and assets, then audit the result in its deployment environment:

```bash
hugo --minify
```

The repository's automated checks enforce warning-free rendering and a minimum Lighthouse accessibility score. See the [development guide](docs/development.md#quality-and-compatibility) for the current quality baseline and local commands.

## Contributing

Contributions are welcome. Keep changes focused, run the documented checks, update user-facing documentation when behaviour changes, and include screenshots for visual changes. Read the [contributing guide](CONTRIBUTING.md) before opening a pull request, or use the [support guide](SUPPORT.md) to choose the appropriate issue form.

## Release history

See [CHANGELOG.md](CHANGELOG.md) for the complete version history and [GitHub Releases](https://github.com/joe-mccarthy/termfolio/releases) for published source archives and release notes.

## Licence

Termfolio is released under the [MIT License](LICENSE).

## Acknowledgements

- [Hugo](https://gohugo.io/) powers the static site pipeline.
- [JetBrains Mono](https://www.jetbrains.com/lp/mono/) provides the bundled terminal-style typeface.
