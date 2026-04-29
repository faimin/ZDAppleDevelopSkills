# iOS Core Skills Design

## Goal

Create three distributable open-source skills under `MySKILLS/skills/`:

1. `swift-modern`
2. `objective-c-patterns`
3. `uikit-modern`

These skills should be reusable outside this repository, follow common agent-skill packaging patterns, and draw structural inspiration from the referenced open-source skills while avoiding project-specific coupling.

## Non-Goals

- Do not create many micro-skills in this iteration.
- Do not bake team-private conventions into the main skill body.
- Do not optimize for a single app architecture or dependency stack.
- Do not attempt exhaustive Apple API documentation inside `SKILL.md`.

## Source Inputs

The design should borrow from these reference skills:

- `tmp/MiniMaxSkills/skills/ios-application-dev/`
- `tmp/skills/skills/ios-developer/`
- `tmp/Swift-UIKit-Skill/`

Coverage should also be cross-checked against the broader iOS skill set already present under:

- `tmp/swift-ios-skills/skills/`

For newer platform details, the implementation may additionally verify behavior and naming against current Apple documentation.

## Recommended Structure

Use a distributable skill layout:

```text
MySKILLS/
└── skills/
    ├── swift-modern/
    │   ├── SKILL.md
    │   └── references/
    ├── objective-c-patterns/
    │   ├── SKILL.md
    │   └── references/
    └── uikit-modern/
        ├── SKILL.md
        └── references/
```

The first iteration may omit `evals/`, but each skill should be written so eval prompts can be added later without restructuring.

## Approach Options

### Option A: Single-file handbook per skill

Put all guidance inside each `SKILL.md`.

Pros:
- Fastest to author
- Minimal file count

Cons:
- Weak routing behavior
- Large `SKILL.md` files reduce clarity and trigger quality
- Hard to maintain across Swift and iOS version growth

### Option B: Router skill plus reference files

Each `SKILL.md` handles triggering, routing, checklists, diagnostics, and common mistakes. Detailed API guidance, version timelines, and code patterns live in `references/`.

Pros:
- Best balance of discoverability and maintainability
- Matches the strongest patterns from the provided open-source skills
- Easier to extend for new Swift or iOS releases

Cons:
- Slightly more authoring overhead

### Option C: Many micro-skills

Split into narrow skills such as `swift-concurrency`, `swift-codable`, and `uikit-diffable-data-source`.

Pros:
- Very precise routing
- Smaller per-skill surface area

Cons:
- Does not satisfy the current goal of creating exactly three top-level skills
- Adds packaging and discovery overhead too early

## Decision

Choose Option B.

Each of the three skills will be a hybrid of:

- a lightweight execution guide in `SKILL.md`
- deeper technical references in `references/`

This keeps the main skill discoverable while still allowing strong topic coverage.

## Shared Writing Rules

All three skills should follow these conventions:

- Use English YAML frontmatter and English main content.
- Keep the `description` field focused on triggering conditions, not workflow summaries.
- Use hyphenated lowercase skill names.
- Keep `SKILL.md` focused on:
  - when to use
  - how to route
  - correctness checks
  - common failure modes
- Move dense syntax, version-by-version notes, and long code examples into `references/`.
- Stay open-source and technology-focused rather than repository-specific.
- Prefer actionable rules over generic explanations.

## Skill 1: `swift-modern`

### Purpose

Provide modern Swift guidance across Swift 5.0 through Swift 6.3, with emphasis on language evolution, concurrency, observation, Codable, Combine, interop, and migration choices.

### Trigger Conditions

This skill should trigger when the task involves:

- writing or reviewing Swift code
- choosing between modern Swift language features
- concurrency migration or actor isolation
- Combine usage or migration
- Codable model design and decoding strategy
- Swift language version changes from 5.x to 6.x
- Swift and Objective-C interoperability

### SKILL.md Responsibilities

`swift-modern/SKILL.md` should include:

- overview and when-to-use guidance
- a topic router
- modern Swift decision rules
- correctness checklist
- quick diagnostics for common issues
- guidance on which reference file to read next

### Planned References

Create these reference files:

- `references/language-evolution-overview.md`
- `references/concurrency.md`
- `references/combine.md`
- `references/codable.md`
- `references/observation-and-state.md`
- `references/interoperability.md`
- `references/diagnostics.md`
- `references/whats-new-swift/swift-5.0.md`
- `references/whats-new-swift/swift-5.1.md`
- `references/whats-new-swift/swift-5.2.md`
- `references/whats-new-swift/swift-5.3.md`
- `references/whats-new-swift/swift-5.4.md`
- `references/whats-new-swift/swift-5.5.md`
- `references/whats-new-swift/swift-5.6.md`
- `references/whats-new-swift/swift-5.7.md`
- `references/whats-new-swift/swift-5.8.md`
- `references/whats-new-swift/swift-5.9.md`
- `references/whats-new-swift/swift-5.10.md`
- `references/whats-new-swift/swift-6.0.md`
- `references/whats-new-swift/swift-6.1.md`
- `references/whats-new-swift/swift-6.2.md`
- `references/whats-new-swift/swift-6.3.md`

### Core Content Requirements

The Swift skill must cover:

- structured concurrency
- actors, global actors, and `Sendable`
- task groups and cancellation
- async sequences and bridging legacy callbacks
- Combine operators, threading, and interop with async code
- Codable customization and resilient decoding
- observation-era state patterns where relevant to modern Swift usage
- migration notes from pre-concurrency Swift to Swift 6 strictness

## Skill 2: `objective-c-patterns`

### Purpose

Provide practical Objective-C guidance around blocks, ARC, retain cycles, runtime APIs, forwarding, associated objects, KVC/KVO, threading, and Swift bridging.

### Trigger Conditions

This skill should trigger when the task involves:

- writing or reviewing Objective-C
- block capture behavior
- retain cycles or ownership bugs
- runtime introspection or swizzling
- message forwarding chains
- associated objects
- KVC or KVO behavior
- Objective-C and Swift interoperability

### SKILL.md Responsibilities

`objective-c-patterns/SKILL.md` should include:

- overview and when-to-use guidance
- decision rules for blocks, delegates, notifications, and runtime use
- memory-management checklist
- retain-cycle debugging workflow
- topic router into references
- quick diagnostics for common Objective-C bugs

### Planned References

Create these reference files:

- `references/blocks-and-memory.md`
- `references/runtime-and-swizzling.md`
- `references/message-forwarding.md`
- `references/kvc-kvo-and-associations.md`
- `references/threading-and-gcd.md`
- `references/objc-swift-interop.md`
- `references/diagnostics.md`

### Core Content Requirements

The Objective-C skill must cover:

- block syntax patterns that are still common in UIKit and legacy APIs
- `weak` and `strong` capture patterns
- delegate ownership rules
- runtime safety constraints around swizzling
- selector-based messaging and forwarding stages
- associated objects and when not to use them
- ARC caveats with Core Foundation bridging and C APIs
- practical debugging of leaks, zombies, and unexpected deallocation

## Skill 3: `uikit-modern`

### Purpose

Provide modern UIKit guidance for iOS 13 through iOS 26, centered on collection views, compositional layout, diffable data sources, list configurations, keyboard-safe layout, scenes, navigation, and modernization of legacy controllers.

### Trigger Conditions

This skill should trigger when the task involves:

- UIKit screen implementation or review
- collection-view architecture
- diffable data sources
- compositional layout
- list cells and registrations
- keyboard-safe layout
- scene-based lifecycle changes
- UIKit modernization from older patterns

### SKILL.md Responsibilities

`uikit-modern/SKILL.md` should include:

- overview and when-to-use guidance
- task workflow for reviewing, improving, and creating UIKit code
- topic router
- modernization checklist
- quick diagnostics
- rules for choosing between legacy and modern UIKit patterns

### Planned References

Create these reference files:

- `references/collection-view-modernization.md`
- `references/diffable-data-source.md`
- `references/compositional-layout.md`
- `references/list-configurations.md`
- `references/keyboard-and-input.md`
- `references/view-controller-lifecycle-and-scenes.md`
- `references/navigation-and-presentation.md`
- `references/diagnostics.md`
- `references/ios-version-features/ios-13.md`
- `references/ios-version-features/ios-14.md`
- `references/ios-version-features/ios-15.md`
- `references/ios-version-features/ios-16.md`
- `references/ios-version-features/ios-17.md`
- `references/ios-version-features/ios-18.md`
- `references/ios-version-features/ios-26.md`

### Core Content Requirements

The UIKit skill must cover:

- `UICollectionViewCompositionalLayout`
- `NSDiffableDataSourceSnapshot`
- `UICollectionViewDiffableDataSource`
- cell registration and content configuration
- list-style collection views
- `UIKeyboardLayoutGuide`
- scene lifecycle and multi-window considerations where relevant
- migration guidance away from older imperative table and collection patterns when modernization is appropriate

## Reference Style

Reference files should be opinionated and practical:

- explain when to use a pattern
- include concise code examples
- call out traps and deprecations
- avoid copying large chunks of vendor documentation
- prefer comparison tables where choices are easy to confuse

## Borrowing Strategy from Existing Skills

Use these patterns from the provided reference skills:

- From `ios-application-dev`:
  - compact quick-reference tables
  - checklist-oriented usability
  - references index at the end
- From `ios-developer`:
  - version-aware routing
  - aggregated topic router for a broad platform domain
- From `Swift-UIKit-Skill`:
  - operational rules
  - workflow framing for review and implementation
  - quick diagnostics tied to likely causes

Do not copy their naming, claims, or exact wording wholesale. Rebuild the structure around the new three-skill boundary.

## Acceptance Criteria

The design is successful if the resulting work produces:

- three top-level skills under `MySKILLS/skills/`
- one `SKILL.md` per skill with strong trigger descriptions
- focused `references/` files instead of bloated main skills
- explicit coverage for Swift 5.0 through 6.3 in `swift-modern`
- explicit coverage for blocks, runtime, and retain-cycle issues in `objective-c-patterns`
- explicit coverage for modern UIKit features from iOS 13 through iOS 26 in `uikit-modern`
- naming and structure suitable for open-source distribution

## Risks and Mitigations

### Risk: Over-broad scope makes the main skills too large

Mitigation:
- keep `SKILL.md` to routing and decision support
- move detail into references

### Risk: Newer Swift and UIKit details are inaccurate

Mitigation:
- validate newer version coverage against official Apple or Swift sources during implementation

### Risk: Too much overlap between Swift and UIKit skills

Mitigation:
- keep Swift language and library decisions in `swift-modern`
- keep screen construction and UIKit API selection in `uikit-modern`

## Implementation Notes

During implementation:

- create the three skill directories first
- author each `SKILL.md` before filling all references
- keep terminology consistent across skills
- avoid internal project overrides in the first version
- prepare the structure so `evals/` can be added later without moving files
