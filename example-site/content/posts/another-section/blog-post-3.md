---
title: "Publishing Without Tracking"
date: 2024-02-12T12:14:50Z
draft: false
summary: A note on privacy-minded publishing, with custom aside and details shortcodes.
tags: ["privacy", "static sites", "hugo"]
categories: ["publishing workflow"]
series: ["Getting Started"]
---

Static sites have a natural privacy advantage. A page can be just HTML, CSS, images, and fonts. The browser asks for the page, gets the page, and the story ends there.

{{< aside title="Design note" >}}
The theme bundles JetBrains Mono locally. That keeps the visual identity consistent without asking a font CDN to join every page view.
{{< /aside >}}

Privacy is also about restraint. If a site does not need comments, analytics, embeds, or third-party scripts, the best implementation is usually to leave them out.

{{< details summary="What about search?" >}}
Search can still be local. The theme includes a small built-in search index for regular pages, with Pagefind available as an option for larger sites.
{{< /details >}}

For more about Hugo itself, see {{< external-link href="https://gohugo.io/" text="the Hugo documentation" >}}.
