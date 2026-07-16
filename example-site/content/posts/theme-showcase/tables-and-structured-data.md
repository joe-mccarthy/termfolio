---
title: "Theme Showcase: Tables and Structured Data"
date: 2026-06-05T09:00:00Z
draft: false
summary: "A post demonstrating markdown tables, wide content, and compact comparison data."
tags: ["metadata", "typography", "accessibility"]
categories: ["theme design"]
series: ["Theme Showcase"]
---

Tables are useful when the reader needs to compare compact values. The theme keeps table borders visible and allows horizontal scrolling when content is too wide.

| Feature | Example setting | Why it matters |
| --- | --- | --- |
| Accent color | `params.style.accentColor` | Controls focus states and small visual accents. |
| Max width | `params.style.maxWidth` | Keeps long-form reading comfortable. |
| Table of contents | `params.toc.enabled` | Helps longer posts expose their structure. |
| Search | `params.search.enabled` | Adds local search for larger example sites. |

## Longer Cells

| Scenario | Notes |
| --- | --- |
| A compact personal site | The defaults keep setup small while still supporting posts, projects, taxonomies, search, and feeds. |
| A documentation-style site | The same typography, code blocks, headings, and table treatment can support longer technical writing. |

Tables should not replace prose, but they are useful for direct comparison.
