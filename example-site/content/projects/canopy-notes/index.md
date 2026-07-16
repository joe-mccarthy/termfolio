---
title: "Canopy Notes"
date: 2025-07-21T09:00:00Z
draft: false
weight: 30
summary: "A field notebook for urban tree surveys that keeps observations tidy, searchable, and easy to publish."
subtitle: "A publishable field notebook for urban tree surveys."
year: 2025
projectType: "Publishing system"
status: "Live"
license: "MIT"
role: "Content model"
impact: "Survey notes to maps"
stack: ["Hugo", "Markdown", "GeoJSON"]
demo: "https://example.org/projects/canopy-notes"
repo: "https://example.org/repos/canopy-notes"
---

## Problem

Volunteer survey notes were easy to collect but hard to review. Photos, species names, coordinates, and follow-up tasks drifted apart after each walk.

## Approach

Canopy Notes stores each observation as a page bundle with front matter for species, condition, and location. A small build step emits a GeoJSON index for mapping while the site remains readable without JavaScript.

## Result

Survey teams can now publish a public record and keep a maintainable private archive from the same source files.
