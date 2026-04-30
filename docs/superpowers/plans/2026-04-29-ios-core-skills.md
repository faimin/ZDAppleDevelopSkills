# iOS Core Skills Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build three distributable open-source skills under `AppleDevelopSKILLS/skills/` for modern Swift, Objective-C patterns, and modern UIKit, with routed `references/` content and starter eval prompts.

**Architecture:** Each skill is a router-style package with a compact `SKILL.md` for trigger conditions, workflow, diagnostics, and checklists, plus focused `references/` files for deeper guidance. Verification is structural rather than compiled: frontmatter validity, naming consistency, reference coverage, and eval prompt presence are all checked from the filesystem.

**Tech Stack:** Markdown, YAML frontmatter, shell verification with `rtk`, git

---

### Task 1: Scaffold the skill packages

**Files:**
- Create: `AppleDevelopSKILLS/skills/swift-modern/SKILL.md`
- Create: `AppleDevelopSKILLS/skills/swift-modern/evals/evals.json`
- Create: `AppleDevelopSKILLS/skills/objective-c-patterns/SKILL.md`
- Create: `AppleDevelopSKILLS/skills/objective-c-patterns/evals/evals.json`
- Create: `AppleDevelopSKILLS/skills/uikit-modern/SKILL.md`
- Create: `AppleDevelopSKILLS/skills/uikit-modern/evals/evals.json`

- [ ] **Step 1: Create the directory tree**

Run:
```bash
mkdir -p AppleDevelopSKILLS/skills/swift-modern/references/whats-new-swift
mkdir -p AppleDevelopSKILLS/skills/swift-modern/evals
mkdir -p AppleDevelopSKILLS/skills/objective-c-patterns/references
mkdir -p AppleDevelopSKILLS/skills/objective-c-patterns/evals
mkdir -p AppleDevelopSKILLS/skills/uikit-modern/references/ios-version-features
mkdir -p AppleDevelopSKILLS/skills/uikit-modern/evals
```
Expected: directories exist with no errors.

- [ ] **Step 2: Write the three `SKILL.md` skeletons**

Each file must start with exact YAML frontmatter and section headings matching the chosen skill boundary.

`AppleDevelopSKILLS/skills/swift-modern/SKILL.md`
```md
---
name: swift-modern
description: Use when writing, reviewing, or migrating Swift code across Swift 4.2 through 6.3, especially for concurrency, Combine, Codable, observation, interoperability, or version-specific language decisions.
---

# Swift Modern

## When to Use
## Operating Rules
## Topic Router
## Version Matrix
## Correctness Checklist
## Quick Diagnostics
## Common Mistakes
```

`AppleDevelopSKILLS/skills/objective-c-patterns/SKILL.md`
```md
---
name: objective-c-patterns
description: Use when writing or reviewing Objective-C, debugging retain cycles, reasoning about blocks or ARC, using runtime features, or bridging Objective-C with Swift.
---

# Objective-C Patterns

## When to Use
## Operating Rules
## Topic Router
## Memory Checklist
## Retain-Cycle Workflow
## Quick Diagnostics
## Common Mistakes
```

`AppleDevelopSKILLS/skills/uikit-modern/SKILL.md`
```md
---
name: uikit-modern
description: Use when building, reviewing, or modernizing UIKit screens for iOS 13 through iOS 26, especially for collection views, diffable data sources, compositional layout, keyboard-safe layout, scenes, and modern presentation patterns.
---

# UIKit Modern

## When to Use
## Operating Rules
## Task Workflow
## Topic Router
## Modernization Checklist
## Quick Diagnostics
## Common Mistakes
```

- [ ] **Step 3: Write starter eval prompts for each skill**

Use this exact JSON shape in each `evals/evals.json`:

`AppleDevelopSKILLS/skills/swift-modern/evals/evals.json`
```json
{
  "skill_name": "swift-modern",
  "evals": [
    {
      "id": 1,
      "prompt": "Review this Swift networking layer and tell me whether it should keep Combine or migrate part of it to async/await. Also flag any Sendable or actor isolation issues.",
      "expected_output": "Routes to Combine, concurrency, and diagnostics guidance with migration recommendations.",
      "files": []
    },
    {
      "id": 2,
      "prompt": "I need a Codable model for an API where keys are snake_case, some dates are ISO8601, and a few fields are nullable or inconsistent types. Show the safest decoding strategy.",
      "expected_output": "Routes to Codable guidance and resilient decoding patterns.",
      "files": []
    },
    {
      "id": 3,
      "prompt": "What changed between Swift 4.2, 5.5, and 6.2 that matters for a legacy app moving to modern concurrency?",
      "expected_output": "Routes to version timeline and migration references.",
      "files": []
    }
  ]
}
```

`AppleDevelopSKILLS/skills/objective-c-patterns/evals/evals.json`
```json
{
  "skill_name": "objective-c-patterns",
  "evals": [
    {
      "id": 1,
      "prompt": "This Objective-C view controller leaks after I add a block-based callback. Show me where the retain cycle probably is and how to rewrite it safely.",
      "expected_output": "Routes to blocks, memory, and retain-cycle diagnostics guidance.",
      "files": []
    },
    {
      "id": 2,
      "prompt": "I need to swizzle a UIKit method for analytics. What are the runtime risks, and what is the safest implementation pattern?",
      "expected_output": "Routes to runtime, swizzling, and diagnostics guidance with safety constraints.",
      "files": []
    },
    {
      "id": 3,
      "prompt": "Explain how Objective-C message forwarding works and when to use forwarding instead of just implementing the selector directly.",
      "expected_output": "Routes to message forwarding guidance.",
      "files": []
    }
  ]
}
```

`AppleDevelopSKILLS/skills/uikit-modern/evals/evals.json`
```json
{
  "skill_name": "uikit-modern",
  "evals": [
    {
      "id": 1,
      "prompt": "Refactor this legacy collection view controller from manual flow layout and reloadData calls to a modern UIKit approach.",
      "expected_output": "Routes to collection view modernization, diffable data source, and compositional layout guidance.",
      "files": []
    },
    {
      "id": 2,
      "prompt": "My form screen jumps under the keyboard. Show me the modern UIKit way to pin content above the keyboard on recent iOS versions.",
      "expected_output": "Routes to keyboard and input guidance including UIKeyboardLayoutGuide.",
      "files": []
    },
    {
      "id": 3,
      "prompt": "What UIKit features from iOS 13 onward should I use for a settings screen with list cells, accessories, and contextual actions?",
      "expected_output": "Routes to list configuration and version feature guidance.",
      "files": []
    }
  ]
}
```

- [ ] **Step 4: Verify the scaffold**

Run:
```bash
rtk find AppleDevelopSKILLS/skills -maxdepth 3 -type f | sort
```
Expected: the six scaffold files are present under the three skill packages.

- [ ] **Step 5: Commit the scaffold**

Run:
```bash
git add AppleDevelopSKILLS/skills
git commit -m "feat(skills): scaffold iOS core skill packages"
```
Expected: commit succeeds and only adds the new skill-package skeleton files.

### Task 2: Author `swift-modern`

**Files:**
- Modify: `AppleDevelopSKILLS/skills/swift-modern/SKILL.md`
- Create: `AppleDevelopSKILLS/skills/swift-modern/references/language-evolution-overview.md`
- Create: `AppleDevelopSKILLS/skills/swift-modern/references/concurrency.md`
- Create: `AppleDevelopSKILLS/skills/swift-modern/references/combine.md`
- Create: `AppleDevelopSKILLS/skills/swift-modern/references/codable.md`
- Create: `AppleDevelopSKILLS/skills/swift-modern/references/observation-and-state.md`
- Create: `AppleDevelopSKILLS/skills/swift-modern/references/interoperability.md`
- Create: `AppleDevelopSKILLS/skills/swift-modern/references/diagnostics.md`
- Create: `AppleDevelopSKILLS/skills/swift-modern/references/whats-new-swift/swift-4.2.md`
- Create: `AppleDevelopSKILLS/skills/swift-modern/references/whats-new-swift/swift-5.0.md`
- Create: `AppleDevelopSKILLS/skills/swift-modern/references/whats-new-swift/swift-5.1.md`
- Create: `AppleDevelopSKILLS/skills/swift-modern/references/whats-new-swift/swift-5.2.md`
- Create: `AppleDevelopSKILLS/skills/swift-modern/references/whats-new-swift/swift-5.3.md`
- Create: `AppleDevelopSKILLS/skills/swift-modern/references/whats-new-swift/swift-5.4.md`
- Create: `AppleDevelopSKILLS/skills/swift-modern/references/whats-new-swift/swift-5.5.md`
- Create: `AppleDevelopSKILLS/skills/swift-modern/references/whats-new-swift/swift-5.6.md`
- Create: `AppleDevelopSKILLS/skills/swift-modern/references/whats-new-swift/swift-5.7.md`
- Create: `AppleDevelopSKILLS/skills/swift-modern/references/whats-new-swift/swift-5.8.md`
- Create: `AppleDevelopSKILLS/skills/swift-modern/references/whats-new-swift/swift-5.9.md`
- Create: `AppleDevelopSKILLS/skills/swift-modern/references/whats-new-swift/swift-5.10.md`
- Create: `AppleDevelopSKILLS/skills/swift-modern/references/whats-new-swift/swift-6.0.md`
- Create: `AppleDevelopSKILLS/skills/swift-modern/references/whats-new-swift/swift-6.1.md`
- Create: `AppleDevelopSKILLS/skills/swift-modern/references/whats-new-swift/swift-6.2.md`
- Create: `AppleDevelopSKILLS/skills/swift-modern/references/whats-new-swift/swift-6.3.md`

- [ ] **Step 1: Expand `swift-modern/SKILL.md` into a router-style skill**

Write concrete content for these sections:

```md
## When to Use
- Swift application code
- migration from legacy Swift
- concurrency, Combine, Codable, observation, and interop decisions

## Operating Rules
- Prefer modern Swift over legacy escape-hatch patterns when platform support allows it.
- Route version-sensitive questions to the exact `whats-new-swift/` file before answering from memory.
- Prefer structured concurrency over detached work unless isolation boundaries require otherwise.
- Treat `Sendable`, actor isolation, and cancellation as correctness constraints, not style advice.

## Topic Router
| Need | Reference |
|------|-----------|
| Language timeline and migration | `references/language-evolution-overview.md` |
| async/await, actors, Sendable | `references/concurrency.md` |
| Publishers, schedulers, bridging | `references/combine.md` |
| Encoding and decoding strategy | `references/codable.md` |
| Observation and modern state | `references/observation-and-state.md` |
| Swift/Objective-C boundaries | `references/interoperability.md` |
| Error messages and failure modes | `references/diagnostics.md` |
```

- [ ] **Step 2: Write the core Swift references**

Each reference must contain:
- when to use the pattern
- preferred modern choices
- at least one concise code example
- common traps

Minimum content by file:

```md
language-evolution-overview.md
- timeline from 4.2 to 6.3
- migration priorities: syntax, ABI-era changes, concurrency, strictness

concurrency.md
- async/await
- task groups
- cancellation
- actors and global actors
- Sendable and isolation diagnostics

combine.md
- publisher lifecycle
- scheduler rules
- memory ownership in pipelines
- bridging Combine to async sequences

codable.md
- CodingKeys
- date/data decoding strategies
- lossy or resilient decoding techniques
- heterogeneous payload handling

observation-and-state.md
- `@Observable` era guidance
- state ownership tradeoffs
- interaction boundaries with Combine and async tasks

interoperability.md
- `@objc`, `dynamic`, selectors
- nullability and bridging
- callback bridging between Objective-C and Swift

diagnostics.md
- non-Sendable warnings
- actor isolation violations
- decoding failures
- publisher threading mistakes
```

- [ ] **Step 3: Write the Swift version notes**

Each file under `references/whats-new-swift/` must follow this exact structure:

```md
# Swift X.Y

## Major Changes
## Why It Matters
## Migration Notes
## Compatibility Risks
```

Apply this scope:
- `swift-4.2.md`: language cleanup, dynamic member lookup context, random API modernization, migration baseline
- `swift-5.0.md`: ABI stability context, `Result`, string/raw improvements
- `swift-5.1.md`: property wrappers, opaque result types
- `swift-5.2.md`: key-path and compiler quality improvements most relevant to migration
- `swift-5.3.md`: multiple trailing closures, package and language polish
- `swift-5.4.md`: result builder and tooling refinements
- `swift-5.5.md`: async/await, actors, task groups
- `swift-5.6.md`: concurrency adoption refinements
- `swift-5.7.md`: existential `any`, regex baseline, improved generics
- `swift-5.8.md`: result builder and compiler behavior refinements
- `swift-5.9.md`: macros, observation era context, package and compiler improvements
- `swift-5.10.md`: stricter concurrency diagnostics and migration pressure
- `swift-6.0.md`: language mode shift and stricter correctness expectations
- `swift-6.1.md`: incremental refinement to strict concurrency adoption
- `swift-6.2.md`: latest concurrency and language ergonomics validated against current Swift sources
- `swift-6.3.md`: latest language and tooling notes validated against current Swift sources

- [ ] **Step 4: Verify Swift skill structure and coverage**

Run:
```bash
rtk rg -n "^name: swift-modern$|^## When to Use$|^## Topic Router$|^## Correctness Checklist$" AppleDevelopSKILLS/skills/swift-modern/SKILL.md
rtk find AppleDevelopSKILLS/skills/swift-modern/references -type f | sort
rtk rg -n "Swift 4.2|Swift 5.5|Swift 6.0|Swift 6.3|Sendable|Codable|Combine" AppleDevelopSKILLS/skills/swift-modern
```
Expected: headings match, all planned reference files exist, and core coverage keywords are present.

- [ ] **Step 5: Commit the Swift skill**

Run:
```bash
git add AppleDevelopSKILLS/skills/swift-modern
git commit -m "feat(skills): add swift-modern skill"
```
Expected: commit succeeds with the Swift skill package only.

### Task 3: Author `objective-c-patterns`

**Files:**
- Modify: `AppleDevelopSKILLS/skills/objective-c-patterns/SKILL.md`
- Create: `AppleDevelopSKILLS/skills/objective-c-patterns/references/blocks-and-memory.md`
- Create: `AppleDevelopSKILLS/skills/objective-c-patterns/references/runtime-and-swizzling.md`
- Create: `AppleDevelopSKILLS/skills/objective-c-patterns/references/message-forwarding.md`
- Create: `AppleDevelopSKILLS/skills/objective-c-patterns/references/kvc-kvo-and-associations.md`
- Create: `AppleDevelopSKILLS/skills/objective-c-patterns/references/threading-and-gcd.md`
- Create: `AppleDevelopSKILLS/skills/objective-c-patterns/references/objc-swift-interop.md`
- Create: `AppleDevelopSKILLS/skills/objective-c-patterns/references/diagnostics.md`

- [ ] **Step 1: Expand `objective-c-patterns/SKILL.md` into a router-style skill**

Write concrete content for these sections:

```md
## Operating Rules
- Prefer simple Objective-C language features before reaching for runtime mutation.
- Treat retain cycles as ownership design bugs, not cleanup chores.
- Use swizzling only when a direct override, wrapper, delegate, or explicit integration point is unavailable.
- Route bridging questions to the interop reference before proposing mixed-language APIs.

## Topic Router
| Need | Reference |
|------|-----------|
| Blocks, captures, ARC ownership | `references/blocks-and-memory.md` |
| Runtime APIs and swizzling | `references/runtime-and-swizzling.md` |
| Forwarding and dynamic dispatch | `references/message-forwarding.md` |
| KVC, KVO, associations | `references/kvc-kvo-and-associations.md` |
| Queues, locks, legacy async work | `references/threading-and-gcd.md` |
| Swift bridging boundaries | `references/objc-swift-interop.md` |
| Crash and leak triage | `references/diagnostics.md` |
```

- [ ] **Step 2: Write the Objective-C references**

Minimum content by file:

```md
blocks-and-memory.md
- block syntax patterns
- stack vs heap block capture context
- weak/strong dance examples
- delegate vs block tradeoffs

runtime-and-swizzling.md
- method lookup basics
- safe swizzle checklist
- load vs initialize cautions
- association with UIKit lifecycle risk notes

message-forwarding.md
- `resolveInstanceMethod:`
- `forwardingTargetForSelector:`
- `methodSignatureForSelector:`
- `forwardInvocation:`
- concrete use cases and anti-patterns

kvc-kvo-and-associations.md
- compliant key paths
- observation lifecycle hazards
- associated object policies
- when subclassing is cleaner than association

threading-and-gcd.md
- main-thread UI rules
- serial vs concurrent queues
- legacy callback coordination
- autorelease pool considerations in background work

objc-swift-interop.md
- nullability
- naming translation
- enum and option set bridging
- exposing Swift APIs safely to Objective-C

diagnostics.md
- EXC_BAD_ACCESS triage
- over-released or unexpectedly deallocated objects
- retain-cycle checklist
- swizzle collision symptoms
```

- [ ] **Step 3: Verify Objective-C skill structure and coverage**

Run:
```bash
rtk rg -n "^name: objective-c-patterns$|^## Topic Router$|^## Retain-Cycle Workflow$|^## Quick Diagnostics$" AppleDevelopSKILLS/skills/objective-c-patterns/SKILL.md
rtk find AppleDevelopSKILLS/skills/objective-c-patterns/references -type f | sort
rtk rg -n "block|retain cycle|swizzling|forwardInvocation|KVO|associated object|EXC_BAD_ACCESS" AppleDevelopSKILLS/skills/objective-c-patterns
```
Expected: headings match, all reference files exist, and core coverage keywords are present.

- [ ] **Step 4: Commit the Objective-C skill**

Run:
```bash
git add AppleDevelopSKILLS/skills/objective-c-patterns
git commit -m "feat(skills): add objective-c-patterns skill"
```
Expected: commit succeeds with the Objective-C skill package only.

### Task 4: Author `uikit-modern`

**Files:**
- Modify: `AppleDevelopSKILLS/skills/uikit-modern/SKILL.md`
- Create: `AppleDevelopSKILLS/skills/uikit-modern/references/collection-view-modernization.md`
- Create: `AppleDevelopSKILLS/skills/uikit-modern/references/diffable-data-source.md`
- Create: `AppleDevelopSKILLS/skills/uikit-modern/references/compositional-layout.md`
- Create: `AppleDevelopSKILLS/skills/uikit-modern/references/list-configurations.md`
- Create: `AppleDevelopSKILLS/skills/uikit-modern/references/keyboard-and-input.md`
- Create: `AppleDevelopSKILLS/skills/uikit-modern/references/view-controller-lifecycle-and-scenes.md`
- Create: `AppleDevelopSKILLS/skills/uikit-modern/references/navigation-and-presentation.md`
- Create: `AppleDevelopSKILLS/skills/uikit-modern/references/diagnostics.md`
- Create: `AppleDevelopSKILLS/skills/uikit-modern/references/ios-version-features/ios-13.md`
- Create: `AppleDevelopSKILLS/skills/uikit-modern/references/ios-version-features/ios-14.md`
- Create: `AppleDevelopSKILLS/skills/uikit-modern/references/ios-version-features/ios-15.md`
- Create: `AppleDevelopSKILLS/skills/uikit-modern/references/ios-version-features/ios-16.md`
- Create: `AppleDevelopSKILLS/skills/uikit-modern/references/ios-version-features/ios-17.md`
- Create: `AppleDevelopSKILLS/skills/uikit-modern/references/ios-version-features/ios-18.md`
- Create: `AppleDevelopSKILLS/skills/uikit-modern/references/ios-version-features/ios-26.md`

- [ ] **Step 1: Expand `uikit-modern/SKILL.md` into a router-style skill**

Write concrete content for these sections:

```md
## Operating Rules
- Prefer collection-view-based modern list architectures over adding more complexity to legacy table or flow-layout code when migration is already underway.
- Treat diffable snapshots and compositional layouts as the default modern path for complex lists and grids.
- Prefer registrations, content configurations, and list configurations over manual cell mutation when platform support allows it.
- Use keyboard-safe guides and scene-aware lifecycle handling instead of notification-only hacks when modern APIs exist.

## Topic Router
| Need | Reference |
|------|-----------|
| Modernizing existing list screens | `references/collection-view-modernization.md` |
| Snapshot modeling and data sources | `references/diffable-data-source.md` |
| Grid, list, and orthogonal layout composition | `references/compositional-layout.md` |
| Cell registrations and content configs | `references/list-configurations.md` |
| Keyboard-safe forms and input handling | `references/keyboard-and-input.md` |
| Scene lifecycle and controller boundaries | `references/view-controller-lifecycle-and-scenes.md` |
| Navigation, sheets, and modern presentation | `references/navigation-and-presentation.md` |
| Failure modes and regressions | `references/diagnostics.md` |
```

- [ ] **Step 2: Write the UIKit references**

Minimum content by file:

```md
collection-view-modernization.md
- migration path from `reloadData` and ad hoc delegates
- cell registration
- list-style collection views
- when table views remain acceptable

diffable-data-source.md
- `NSDiffableDataSourceSnapshot`
- `UICollectionViewDiffableDataSource`
- identity modeling
- section and item update patterns

compositional-layout.md
- item/group/section/container hierarchy
- estimated sizing
- orthogonal scrolling
- supplementary and decoration view guidance

list-configurations.md
- `UICollectionLayoutListConfiguration`
- `UIListContentConfiguration`
- accessories, swipe actions, contextual menus
- content and background configuration boundaries

keyboard-and-input.md
- `UIKeyboardLayoutGuide`
- scroll-view coordination
- first responder transitions
- fallback strategies for older patterns when needed

view-controller-lifecycle-and-scenes.md
- iOS 13 scene model
- lifecycle entry points
- multi-window or activation-state awareness
- containment boundaries

navigation-and-presentation.md
- push vs sheet vs popover choices
- modern sheet presentation
- navigation stack integrity

diagnostics.md
- broken diffable identity symptoms
- invalid layout assumptions
- keyboard overlap regressions
- stale cell state and configuration bugs
```

- [ ] **Step 3: Write the iOS version notes**

Each file under `references/ios-version-features/` must follow this exact structure:

```md
# iOS XX UIKit Notes

## Major Additions
## Recommended Usage
## Migration Notes
## Compatibility Risks
```

Apply this scope:
- `ios-13.md`: compositional layout, diffable data source, modern collection view baseline, scene lifecycle
- `ios-14.md`: list configurations, cell registrations, content configurations
- `ios-15.md`: `UIKeyboardLayoutGuide`, button and menu refinements relevant to UIKit composition
- `ios-16.md`: sheet and navigation refinements relevant to modern controllers
- `ios-17.md`: practical UIKit interoperability notes with newer system behaviors
- `ios-18.md`: current platform refinements that materially affect UIKit decisions
- `ios-26.md`: latest UIKit additions and behavior changes validated against current Apple sources

- [ ] **Step 4: Verify UIKit skill structure and coverage**

Run:
```bash
rtk rg -n "^name: uikit-modern$|^## Task Workflow$|^## Topic Router$|^## Modernization Checklist$" AppleDevelopSKILLS/skills/uikit-modern/SKILL.md
rtk find AppleDevelopSKILLS/skills/uikit-modern/references -type f | sort
rtk rg -n "UICollectionViewCompositionalLayout|NSDiffableDataSourceSnapshot|UICollectionViewDiffableDataSource|UIKeyboardLayoutGuide|UICollectionLayoutListConfiguration" AppleDevelopSKILLS/skills/uikit-modern
```
Expected: headings match, all reference files exist, and the modern UIKit feature set is explicitly covered.

- [ ] **Step 5: Commit the UIKit skill**

Run:
```bash
git add AppleDevelopSKILLS/skills/uikit-modern
git commit -m "feat(skills): add uikit-modern skill"
```
Expected: commit succeeds with the UIKit skill package only.

### Task 5: Final consistency pass

**Files:**
- Modify: `AppleDevelopSKILLS/skills/swift-modern/SKILL.md`
- Modify: `AppleDevelopSKILLS/skills/objective-c-patterns/SKILL.md`
- Modify: `AppleDevelopSKILLS/skills/uikit-modern/SKILL.md`
- Modify: `AppleDevelopSKILLS/skills/*/evals/evals.json`

- [ ] **Step 1: Run a cross-skill terminology and structure audit**

Run:
```bash
rtk rg -n "^name: |^description: |^# |^## " AppleDevelopSKILLS/skills/*/SKILL.md
rtk rg -n "TODO|TBD|FIXME|XXX" AppleDevelopSKILLS/skills
```
Expected: each skill has clean frontmatter and no placeholder text.

- [ ] **Step 2: Validate reference links from each main skill**

Run:
```bash
rtk rg -n "references/" AppleDevelopSKILLS/skills/*/SKILL.md
rtk find AppleDevelopSKILLS/skills -type f | sort
```
Expected: every referenced file path in each `SKILL.md` exists on disk.

- [ ] **Step 3: Review eval prompt quality**

Use this checklist:
- each skill has exactly 3 eval prompts
- prompts are realistic user requests
- expected outputs describe routing behavior, not exact prose
- no prompt depends on unavailable local files

- [ ] **Step 4: Commit the final cleanup**

Run:
```bash
git add AppleDevelopSKILLS/skills
git commit -m "test(skills): add eval prompts and consistency pass"
```
Expected: commit succeeds with only final documentation cleanup and eval prompt adjustments.
