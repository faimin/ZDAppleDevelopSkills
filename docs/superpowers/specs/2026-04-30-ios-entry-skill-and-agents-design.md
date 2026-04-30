# iOS Entry Skill And AGENTS Simplification Design

## Goal

Add one broad entry-point skill so general Apple and iOS development requests reliably route into the existing specialized skills, then simplify the repository `AGENTS.md` so it keeps only project-local rules and delegates reusable iOS knowledge to skills.

## Current Context

The repository already contains four specialized open-source skills under `skills/`:

- `swift-modern`
- `objective-c-patterns`
- `uikit-modern`
- `project-structure-architecture`

These skills have good depth, but they are specialized. A broad request such as "做一个 iOS 页面", "重构一个模块", or "实现一个列表页" may not consistently map to the right specialist skill from trigger text alone.

At the same time, the root `AGENTS.md` still mixes two different concerns:

- project-specific workflow and repo constraints
- reusable Apple and iOS engineering guidance

That overlap now creates duplication and weakens the role of the skill system.

## Problem Statement

We need a structure where:

1. broad iOS requests trigger an iOS-oriented skill reliably
2. specialized guidance still lives in smaller focused skills
3. `AGENTS.md` remains short, local, and stable
4. reusable engineering guidance stays in versionable skill packages

## Non-Goals

- Do not merge all iOS guidance into one giant handbook skill.
- Do not remove the four existing specialized skills.
- Do not encode repository-private product logic into the open-source skills.
- Do not rewrite the actual skill content in this design step.
- Do not guarantee literal 100 percent auto-trigger certainty, which depends on the skill system's matching behavior.

## Options Considered

### Option A: Add a broad entry-point skill and slim down `AGENTS.md`

Create a new top-level routing skill and keep the existing four specialist skills unchanged except for any small cross-links needed.

Pros:

- Best trigger coverage for general iOS requests
- Preserves the maintainability of the current specialist skills
- Makes responsibilities between `AGENTS.md` and skills explicit
- Scales cleanly if more Apple-focused skills are added later

Cons:

- Adds one more skill folder
- Introduces a deliberate two-step route: broad entry skill first, specialist skill second

### Option B: Keep current skills and only adjust `AGENTS.md`

Rely on the root instructions to steer the agent toward the existing skills.

Pros:

- Minimal file changes
- No new skill package required

Cons:

- Does not materially improve broad trigger coverage
- Leaves discovery dependent on user phrasing and manual interpretation
- Keeps too much routing burden in `AGENTS.md`

### Option C: Expand `project-structure-architecture` into a catch-all iOS skill

Grow the architecture skill until it also covers Swift, UIKit, and Objective-C routing.

Pros:

- Fewer top-level skill folders

Cons:

- Blurs skill boundaries quickly
- Makes one skill too broad to maintain well
- Duplicates content already captured by the specialist skills
- Weakens future extensibility

## Decision

Choose Option A.

The repository should gain one broad entry-point skill named `ios-app-development`, while `AGENTS.md` becomes a concise project-level policy file that explicitly tells the agent to use the skill system for Apple and iOS domain guidance.

## Deliverable 1: New Entry-Point Skill

### Name

`ios-app-development`

### Location

```text

└── skills/
    └── ios-app-development/
        └── SKILL.md
```

The first version does not need deep `references/` content because its main job is routing, not domain depth.

### Purpose

This skill acts as the broad default entry point for Apple platform application work, especially iOS feature work. It should trigger on general requests and then route into the existing specialist skills.

### Trigger Surface

Its description should intentionally cover broad phrases and request shapes, including:

- iOS app development
- Apple app development
- Swift or Objective-C feature work
- UIKit screen work
- mixed Swift and Objective-C codebases
- project structure and architecture decisions
- package management and third-party library selection
- app modernization, migration, refactor, review, or implementation requests

The description should be written broadly enough that requests like these are likely matches:

- "实现一个 iOS 页面"
- "重构这个 Apple app 模块"
- "Review this Swift list implementation"
- "给这个 Objective-C 模块做现代化改造"
- "设计一下项目结构和包管理"

### SKILL.md Responsibilities

`ios-app-development/SKILL.md` should remain thin and procedural. It should contain:

- when to use this skill first
- a quick routing table for the four specialist skills
- a default triage order
- a few top-level Apple app development rules that are broad enough to stay stable

It should not duplicate the detailed rules already present in the specialist skills.

### Routing Model

The entry skill should route by active problem type:

| Problem shape | Route to |
| --- | --- |
| Modern Swift language, concurrency, Combine, Codable, Swift Testing, Swift release behavior | `swift-modern` |
| Objective-C memory, blocks, runtime, bridging, legacy async patterns | `objective-c-patterns` |
| UIKit screen construction, collection view modernization, keyboard-safe layout, presentation and scene behavior | `uikit-modern` |
| Repository structure, architecture choice, module boundaries, package strategy, third-party selection | `project-structure-architecture` |

For mixed requests, the skill should instruct the agent to read only the relevant specialist skill bodies needed for the current subproblem.

### Default Triage Order

The entry skill should instruct the agent to classify requests in this order:

1. Determine whether the problem is primarily language, UI, Objective-C legacy, or repository architecture.
2. If the request spans multiple layers, identify the dominant layer first.
3. Read the matching specialist skill before answering from memory.
4. If two specialist skills are genuinely required, load the smallest necessary subset and keep one of them as the primary owner of the answer.

### Boundaries

The entry skill should not:

- restate version-by-version Swift changes
- restate UIKit API catalogs
- embed Objective-C runtime tutorials
- replace architecture reference material

Its value is broad triggerability and clean delegation.

## Deliverable 2: Simplified `AGENTS.md`

### Desired Role

The root `AGENTS.md` should become a short repository policy document rather than a full iOS engineering handbook.

### Principle

`AGENTS.md` owns local repository constraints. Skills own reusable domain knowledge.

### Content To Keep In `AGENTS.md`

- short role and repository context
- local workflow expectations
- build or environment expectations that are specific to this repository
- security and privacy constraints
- commit and review expectations
- a short instruction that Apple and iOS development guidance should route through the installed skills

### Content To Remove Or Compress

The following material should move out of the root policy file because it is reusable skill content rather than repo-local policy:

- detailed Swift coding guidance
- general UIKit design and layout preferences
- architecture-selection heuristics such as MVVM vs MVI vs TCA vs Redux
- package manager strategy details beyond short policy statements
- dependency injection library details
- reactive framework choices
- detailed network stack and model parsing guidance
- long examples that teach generic iOS development patterns

### Recommended `AGENTS.md` Structure

```text
1. Scope
2. Repository Workflow
3. Project-Specific Constraints
4. Security And Safety
5. Skill Routing
```

## `AGENTS.md` Content Migration Map

The current root `AGENTS.md` contains a mix of content that should be split three ways:

- keep in `AGENTS.md` because it is a repository or quality-policy concern
- move into an existing specialist skill because it is reusable Apple and iOS knowledge
- remove entirely because it is example or placeholder material rather than stable policy

### Section 1: Project Overview

- Keep only real repository facts that are actually maintained in this repo.
- Remove placeholders such as project name and generic folder examples if they are not authoritative.
- Do not move placeholder project metadata into skills.

### Section 2: Development Environment And Build

- Keep concise local environment expectations in `AGENTS.md`.
- Do not move local Xcode or workflow expectations into skills unless they become reusable open-source guidance, which is not the current goal.

### Section 3: Swift Code Style

Move most of this section out of `AGENTS.md`:

- naming rules such as `PascalCase`, `camelCase`, and boolean prefixes -> `project-structure-architecture/references/development-conventions.md`
- optional-handling and force-unwrap avoidance guidance -> `project-structure-architecture/references/development-conventions.md` and `swift-modern`
- state-wrapper ownership guidance such as `@State` versus `@ObservedObject` -> `swift-modern/references/observation-and-state.md`
- general comment philosophy -> `project-structure-architecture/references/development-conventions.md`

Keep only genuinely local rules, if still desired:

- niche project-specific Objective-C property getter initialization style can stay in `AGENTS.md` if the team treats it as a local rule
- otherwise it should be dropped rather than turned into open-source skill content

### Section 4: UI And UX Guidance

Split this section carefully:

- keep Figma-first workflow, design token usage, and "do not hardcode design values" in `AGENTS.md` because those are project workflow constraints
- remove generic SwiftUI layout advice such as "prefer `VStack` or `HStack`" from `AGENTS.md`; it is too generic to be useful as a repository policy

No current existing skill needs to absorb the design-system or Figma rule, because that is not reusable open-source iOS domain guidance.

### Section 5: Architecture

Move this section to:

- `project-structure-architecture/references/architecture-selection.md`

This content is already part of the specialist-skill scope and should not remain duplicated in `AGENTS.md`.

### Section 6: Dependency Management

Move this section to:

- `project-structure-architecture/references/package-management.md`

The root policy file may retain only a short project-level preference such as "prefer the repository default package strategy unless the task justifies a deviation."

### Section 7: Dependency Injection

Move this section to:

- `project-structure-architecture/references/library-selection.md`

This is reusable dependency-selection guidance, not repository-local policy.

### Section 8: Network And Data

Split this section across existing skills:

- Swift async and concurrency-first API guidance -> `swift-modern/references/concurrency.md`
- Combine guidance -> `swift-modern/references/combine.md`
- Codable modeling and resilient decoding -> `swift-modern/references/codable.md`
- Objective-C callback and block-based interoperability -> `objective-c-patterns`
- Alamofire, ReerCodable, SmartCodable, and package-manager-specific model-library choices -> `project-structure-architecture/references/library-selection.md` and `references/package-management.md`

Keep in `AGENTS.md` only if the repository wants to enforce a quality bar such as:

- network requests must surface errors explicitly

### Section 9: Layout

Move this section to existing skills:

- UIKit and Auto Layout API preferences -> `uikit-modern`
- SnapKit selection guidance -> `project-structure-architecture/references/library-selection.md`

### Section 10: Reactive Programming And Utility Libraries

Move this section to existing skills:

- Combine -> `swift-modern/references/combine.md`
- ReactiveObjC and BlocksKit -> `project-structure-architecture/references/library-selection.md`
- block-based ownership implications -> `objective-c-patterns`

### Section 11: Testing Guidance

Split this section:

- framework-level modern Swift testing style -> `swift-modern/references/swift-testing.md`
- project quality-bar expectations such as "new business logic needs unit tests" and "critical paths need UI tests" -> keep in `AGENTS.md`

The test-file placement rule may stay in `AGENTS.md` if it is a repository convention, or move into `project-structure-architecture` if the goal is reusable structure guidance. The preferred default is to keep it in `AGENTS.md` when it reflects the repo's quality policy.

### Section 12: Workflow And Commits

- Keep in `AGENTS.md`

This is repository-local process and should not move to skills.

### Section 13: Security Constraints

- Keep in `AGENTS.md`

This is repository-local and quality-sensitive policy.

### Section 14: Example Tasks

- Remove from `AGENTS.md`
- Do not move into the skills as-is

These examples are neither durable repository policy nor particularly useful reusable skill content once the skill system becomes the main routing mechanism.

### Section 15: Final Tip

- Keep only a short version in `AGENTS.md`

For example: prefer existing project patterns and ask when requirements or implementation constraints are unclear.

### Recommended Section Intent

#### 1. Scope

State that this file defines repository-local working rules. Reusable Apple and iOS engineering guidance lives in `skills/`.

#### 2. Repository Workflow

Keep guidance such as:

- worktree usage if still desired for this repo
- commit message format
- review expectations
- any local verification expectations

#### 3. Project-Specific Constraints

Keep only rules that are actually local to this repository or this team's expected operating style.

#### 4. Security And Safety

Keep hard constraints such as:

- no hardcoded secrets
- check privacy usage descriptions when needed
- verify license constraints before adding dependencies

#### 5. Skill Routing

Explicitly state:

- use `ios-app-development` first for Apple and iOS feature work
- let that skill route into the specialist skills
- use the specialist skill directly only when the task is already clearly scoped to that area

## Existing Skill Touch-Ups Needed

Most of the target material is already covered by the current skills, but a few small additions should be made during implementation so the AGENTS cleanup does not create gaps.

### `project-structure-architecture`

Add or confirm the following in `references/development-conventions.md`:

- default access-control guidance
- explicit avoidance of unnecessary force unwraps
- the repository's boolean-naming rule in a concise reusable form

This file already covers naming, comments, localization, resource bundles, concurrency-first defaults, and review heuristics. It is the natural home for the remaining generic code-convention material.

### `swift-modern`

Add or confirm the following in `references/observation-and-state.md`:

- an explicit note about `@ObservedObject` for codebases that still mix older observation patterns with modern SwiftUI-era code

Its existing references already cover concurrency, Combine, Codable, Swift Testing, and state ownership, so no structural change is needed.

### `uikit-modern`

No major addition is required for this AGENTS cleanup. It already covers the UIKit-specific layout and interaction preferences that should leave `AGENTS.md`.

### `objective-c-patterns`

No major addition is required for this AGENTS cleanup. It already covers blocks, memory, runtime behavior, category constraints, and mixed-language boundaries.

## Responsibilities Split

### `AGENTS.md`

- repository-local operating rules
- stable workflow constraints
- safety requirements
- routing instruction into the skill system

### `ios-app-development`

- broad Apple and iOS trigger surface
- first-pass triage of incoming Apple development work
- delegation to the specialist skills

### Specialist Skills

- detailed technical guidance
- problem-specific decision rules
- references, checklists, diagnostics, and modern best practices

## Success Criteria

This design is successful if:

- a broad iOS request has a clear default skill entry point
- the existing four skills remain the main technical authorities in their domains
- `AGENTS.md` becomes noticeably shorter and easier to maintain
- there is minimal duplication between root instructions and skill packages
- future Apple-focused skills can be added without rewriting the structure again

## Implementation Scope For The Next Phase

The implementation plan should be limited to:

1. add `skills/ios-app-development/SKILL.md`
2. update the root `AGENTS.md` to the slimmer structure
3. verify that the new `AGENTS.md` clearly separates repository policy from skill responsibility

No other skill rewrites are required unless a small cross-link is needed for consistency.
