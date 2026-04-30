# iOS Entry Skill And AGENTS Simplification Design

## Goal

Add one broad entry-point skill so general Apple and iOS development requests reliably route into the existing specialized skills, then simplify the repository `AGENTS.md` so it keeps only project-local rules and delegates reusable iOS knowledge to skills.

## Current Context

The repository already contains four specialized open-source skills under `AppleDevelopSKILLS/skills/`:

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
AppleDevelopSKILLS/
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

### Recommended Section Intent

#### 1. Scope

State that this file defines repository-local working rules. Reusable Apple and iOS engineering guidance lives in `AppleDevelopSKILLS/skills/`.

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

1. add `AppleDevelopSKILLS/skills/ios-app-development/SKILL.md`
2. update the root `AGENTS.md` to the slimmer structure
3. verify that the new `AGENTS.md` clearly separates repository policy from skill responsibility

No other skill rewrites are required unless a small cross-link is needed for consistency.
