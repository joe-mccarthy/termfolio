---
title: "Theme Showcase: Shortcodes in Practice"
date: 2026-06-07T09:00:00Z
draft: false
summary: "A post demonstrating the bundled aside, details, and external link shortcodes."
tags: ["hugo", "static sites", "accessibility"]
categories: ["theme design"]
series: ["Theme Showcase"]
---

Shortcodes give authors a small set of structured elements without requiring custom HTML in every article.

{{< aside title="Author note" >}}
The aside shortcode is useful for related context, cautions, or editorial notes that should stand apart from the main paragraph flow.
{{< /aside >}}

The theme also includes a details shortcode for optional information.

{{< details summary="What belongs in a details block?" >}}
Use details for supporting material that is useful but not essential on the first read. Examples include setup notes, references, definitions, or longer explanations.
{{< /details >}}

External links can be written with explicit text and safe attributes. For example, see {{< external-link href="https://gohugo.io/" text="the Hugo website" >}}.

## Plain Markdown Still Works

Shortcodes should complement ordinary markdown rather than replace it. Most posts should still be mostly headings, paragraphs, lists, and links.
