---
title: "Building a Tiny Theme"
date: 2023-02-17T12:03:03Z
draft: false
summary: A compact article showing headings, lists, tables, blockquotes, and the optional table of contents.
tags: ["hugo", "typography", "accessibility"]
categories: ["theme design"]
series: ["Getting Started"]
---

Minimal themes are easy to make sparse and surprisingly hard to make comfortable. The trick is to give ordinary writing enough structure without turning every paragraph into a component.

## Goals

This theme tries to keep four promises:

- render without tracking
- work without JavaScript by default
- keep typography calm and predictable
- leave enough hooks for a personal site

> Minimal does not have to mean indifferent. A quiet theme can still have rhythm, hierarchy, and a few considerate affordances.

## Defaults

The defaults should be useful before customization. A small site can use the theme as-is, while a larger site can change the colors, width, metadata, table of contents, taxonomy display, and footer attribution.

| Feature | Default |
| --- | --- |
| Font | Bundled JetBrains Mono |
| JavaScript | None |
| Search | Off |
| Table of contents | On for posts with headings |

## Customization

Most customizations happen in `params`. That keeps the theme files untouched and lets each site keep its own taste.

### Small Changes

Start with a link color, a max width, and whether you want taxonomy metadata below each post title. Those three settings change the feel of a site without changing the structure.
