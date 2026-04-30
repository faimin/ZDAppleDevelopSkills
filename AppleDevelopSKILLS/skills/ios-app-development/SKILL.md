---
name: ios-app-development
description: Use when the task involves general iOS app development work, especially broad Swift, Objective-C, UIKit, mixed-language, project-structure, modernization, refactor, review, or feature-implementation requests that should first route into the repository's specialist iOS development skills.
---

# iOS App Development

## When to Use

Use this skill as the default entry point for broad iOS application work when the request is not already narrowly scoped to one specialist area.

Typical triggers:

- building or reviewing an iOS feature
- implementing an iOS app screen or flow when the UI stack is not yet clear
- modernizing legacy app code
- refactoring a mixed Swift and Objective-C module
- choosing project structure, package strategy, or libraries
- reviewing app code where the main issue is not yet classified

If the task is already clearly limited to one specialist area, go directly to that skill instead of loading this router first.

SwiftUI-first UI requests usually route through `swift-modern` rather than this router staying primary. Only pull `project-structure-architecture` alongside it when structure, package layout, or module-boundary concerns are the dominant problem.

## Default Routing

Route by the dominant problem shape:

| Problem shape | Primary skill |
| --- | --- |
| Modern Swift language behavior, concurrency, Combine, Codable, observation, Swift Testing, version-sensitive decisions | `swift-modern` |
| Objective-C ownership, blocks, runtime behavior, KVC/KVO, swizzling, forwarding, mixed-language legacy concerns | `objective-c-patterns` |
| UIKit screen construction, collection views, diffable data source, compositional layout, keyboard-safe layout, navigation, scenes, presentation | `uikit-modern` |
| Project structure, architecture selection, package strategy, dependency selection, modular boundaries, resource organization | `project-structure-architecture` |

## Triage Order

1. Decide whether the request is primarily about language, UIKit UI work, Objective-C legacy behavior, or repository architecture.
2. If multiple layers are involved, identify the dominant layer before loading additional skills.
3. Read the matching specialist skill before answering from memory.
4. Load a second specialist skill only when the task genuinely spans two domains.
5. Keep one specialist skill as the primary owner of the answer so guidance stays coherent.

## Stable Rules

- Prefer the smallest relevant specialist skill set instead of loading every iOS skill by default.
- Treat reusable engineering guidance as skill content, not as root `AGENTS.md` content.
- For mixed Swift and Objective-C requests, classify the active problem first instead of assuming the boundary itself is the problem.
- For broad iOS feature requests, start here, then route down.

## Boundaries

This skill is intentionally thin.

Do not turn it into:

- a full Swift language guide
- a UIKit API handbook
- an Objective-C runtime tutorial
- a project-structure reference library

Its job is broad trigger coverage and clean delegation to the specialist skills.
