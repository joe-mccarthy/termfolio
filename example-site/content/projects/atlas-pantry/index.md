---
title: "Atlas Pantry"
date: 2026-02-12T09:00:00Z
draft: false
weight: 10
summary: "An offline recipe and stock planner that helps shared kitchens avoid duplicate shopping and forgotten staples."
subtitle: "An offline recipe and stock planner for shared kitchens."
year: 2026
projectType: "Offline tool"
status: "Prototype"
license: "MIT"
role: "Product design"
impact: "Shared kitchen planning"
stack: ["Hugo", "SQLite", "Service workers"]
demo: "https://example.org/projects/atlas-pantry"
repo: "https://example.org/repos/atlas-pantry"
---

## Problem

Small shared kitchens often keep recipes, stock counts, and shopping lists in different places. That makes duplicate purchases common and leaves staples buried at the back of the cupboard.

## Approach

Atlas Pantry uses a local-first catalogue that links each recipe to required ingredients, current stock, and a simple shopping queue. It works offline first, then syncs when a connection is available.[^local-first]

## Result

The prototype makes stock gaps visible before a cooking session starts. It also gives coordinators a quick way to see which recipes are realistic with the ingredients already on hand.

[^local-first]: The first prototype stored kitchen records locally so it could still be used in a basement kitchen with unreliable wireless coverage.
