---
title: "Theme Showcase: Images and Figures"
date: 2026-06-08T09:00:00Z
draft: false
summary: "A post demonstrating page-bundle images, figure captions, alt text, and image sizing."
tags: ["images", "accessibility", "hugo"]
categories: ["theme design"]
series: ["Theme Showcase"]
images:
- posts/theme-showcase/images-and-figures/example.svg
---

Page bundles keep content and related assets together. This post uses a local SVG stored beside the markdown file.

{{< figure src="example.svg" alt="A diagram of a content page connected to image assets and rendered HTML" caption="A local page-bundle image rendered through the figure shortcode." >}}

Images stay within the content column by default. Captions use quieter text so they support the image without becoming the main content.

## Why Page Bundles Help

When images live beside the page that uses them, moving or deleting content is less error-prone. It also makes the example site easier to inspect because each asset has an obvious owner.
