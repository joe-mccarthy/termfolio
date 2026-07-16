---
title: "Theme Showcase: Code and Terminal Output"
date: 2026-06-09T09:00:00Z
draft: false
summary: "A post demonstrating inline code, fenced code blocks, long lines, and syntax highlighting."
tags: ["code", "syntax highlighting", "hugo"]
categories: ["theme design"]
series: ["Theme Showcase"]
---

Inline code such as `hugo server --disableFastRender` should sit naturally inside a sentence without dominating the surrounding text.

## Shell

```bash
hugo server --themesDir ../../ --theme termfolio --bind 127.0.0.1 --port 1313
```

Long command lines should scroll horizontally inside the code block instead of breaking the layout.

## JavaScript

```js
const posts = [
  { title: "Typography and Flow", tags: ["typography", "writing"] },
  { title: "Code and Terminal Output", tags: ["code", "syntax-highlighting"] },
];

const titles = posts
  .filter((post) => post.tags.includes("code"))
  .map((post) => post.title);

console.log(titles.join(", "));
```

## Configuration

```yaml
params:
  style:
    maxWidth: 820px
    accentColor: "#386f64"
  toc:
    enabled: true
```

The theme uses Chroma classes when Hugo highlighting is configured with `noClasses: false`.
