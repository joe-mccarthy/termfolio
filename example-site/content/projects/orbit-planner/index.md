---
title: "Orbit Planner"
date: 2023-12-04T09:00:00Z
draft: false
weight: 60
summary: "A lightweight launch calendar for small teams coordinating releases, reviews, and dependency checks."
subtitle: "A release planning calendar for small product teams."
year: 2023
status: "Archived"
license: "MIT"
role: "Planning system"
---

## Problem

Release work was scattered across calendar events, pull requests, and private notes. The team needed one small place to see what was blocked and what was ready.

## Approach

Orbit Planner keeps each release as a markdown record with milestones, owners, and checklist items.[^records] The generated site groups upcoming work by week.

## Result

The project made launch readiness visible without introducing another project management tool.

[^records]: Release records used the same fields for every launch, which made blocked reviews and missing approvals easier to compare.
