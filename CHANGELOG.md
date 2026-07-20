# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2026-07-20

### Added

- First public stable release of Termfolio as a standalone Hugo theme.
- Terminal-inspired, dark-only interface with shell-style navigation, file-list indexes, structured project pages, and locally hosted JetBrains Mono.
- Layouts for long-form posts, projects, content lists, and category, tag, and series taxonomies, including tables of contents, content metadata, and previous and next navigation.
- Built-in static search with optional Pagefind integration for larger sites.
- Figure, aside, disclosure, and external-link shortcodes for richer content.
- JSON-LD, Open Graph, Twitter Card, canonical URL, RSS, favicon, and web-app metadata.
- Complete example site, screenshots, walkthrough media, Hugo Themes gallery assets, and configuration, content, and development documentation.
- Contribution and support guidance, structured issue forms, a pull request template, and maintainer release documentation.
- Automated checks for warning-free rendering, documentation, links, shell scripts, release integrity, and accessibility.
- Validated annotated-tag release automation and exact-commit example-site deployment.

### Changed

- Declared Hugo `0.128.0` or newer as the supported range; Hugo Standard is sufficient, and CI verifies versions `0.128.0` and `0.164.0`.
- Updated the example configuration to use `defaultContentLanguage` for the rendered page language.
- Consolidated taxonomy term rendering for consistent behaviour across the tested Hugo versions.
