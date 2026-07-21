# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.2] - 2026-07-21

### Added

- Added dedicated configuration, content-authoring, development, contribution, support, and release guides.
- Added repeatable checks for supported Hugo versions, documentation, links, shell scripts, release-candidate invariants, and route-level accessibility.

### Changed

- Standardized copy-ready configuration on `defaultContentLanguage`; legacy `languageCode` values still render correctly, although Hugo 0.158.0 and newer emit a deprecation warning while loading configuration.
- Hardened exact-commit example-site deployment and immutable annotated-tag GitHub Release automation.
- Scoped repository permissions to the CI jobs that require them and disabled dependency lifecycle scripts during quality-tool installation.

### Fixed

- Made category, tag, and series indexes and individual term pages render consistently across supported Hugo versions.
- Preserved configured page-language values in the rendered `<html lang>` attribute across Hugo's 0.158.0 language API change.
- Made accessibility checks build and serve an isolated example site with verified routes and theme assets before Lighthouse runs.

## [1.0.1] - 2026-07-16

### Fixed

- Prepared a patch release from the corrected mainline state after the `v1.0.0` tag/merge mismatch.
- Updated release-facing documentation to point at `v1.0.1` as the latest release.

## [1.0.0] - 2026-07-16

### Added

- Initial stable Termfolio release as a standalone Hugo theme.
- Terminal-inspired layout, file-list navigation, repo-style project pages, static search support, SEO metadata, and bundled JetBrains Mono assets.
- README walkthrough GIF, screenshots, and adoption-focused quick start documentation.
- Hugo Themes gallery assets and submission checklist.
- GitHub issue templates for bugs, feature requests, and showcase submissions.
- Release checklist for screenshot, GIF, and gallery metadata updates.
- Complete favicon, pinned-tab, tile, and web app manifest assets for generated sites.
- Taxonomy term description rendering, with example series descriptions in the demo site.

### Changed

- Simplified the theme to a dark-only palette.
- Updated example-site copy to describe Termfolio more clearly.
- Updated the default and example layout width to better support project grids and repo-style index pages.
- Polished site icon metadata for the final release.

## [1.0.0-rc.1] - 2026-07-16

### Added

- Initial Termfolio split as a standalone Hugo theme.
- Terminal-inspired layout, file-list navigation, repo-style project pages, static search support, SEO metadata, and bundled JetBrains Mono assets.
- README walkthrough GIF, screenshots, and adoption-focused quick start documentation.
- Hugo Themes gallery assets and submission checklist.
- GitHub issue templates for bugs, feature requests, and showcase submissions.
- Release checklist for screenshot, GIF, and gallery metadata updates.

### Changed

- Simplified the theme to a dark-only palette.
- Updated example-site copy to describe Termfolio more clearly.
