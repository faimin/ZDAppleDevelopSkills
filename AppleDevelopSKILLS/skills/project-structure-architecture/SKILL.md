---
name: project-structure-architecture
description: Use when organizing or standardizing an Apple app repository, choosing project structure or architecture, deciding package strategy, or evaluating third-party libraries for SwiftUI-first or mixed SwiftUI/UIKit apps.
---

# Project Structure Architecture

## When to Use
- New Apple app setup or major repository reorganization.
- SwiftUI-first apps that still carry UIKit screens, wrappers, or legacy modules.
- Unclear architecture choice across MVVM, MVI, TCA, Redux, or modular boundaries.
- SPM vs CocoaPods decisions, package splitting, or third-party library selection.
- Choosing how Objective-C-heavy modules should stay consistent with the rest of the app.

## Operating Rules
- Prefer feature-first structure over layer-first folders once the app has multiple product flows.
- Prefer SwiftUI-first organization, with UIKit isolated behind explicit legacy, bridge, or host boundaries.
- Prefer `async`/`await` and structured concurrency for new Swift APIs; do not introduce new closure-first surfaces unless bridging older SDKs or Objective-C code.
- Prefer SPM for first-party modules and third-party dependencies; use CocoaPods deliberately and record the constraint that justifies it.
- In CocoaPods ecosystems that already depend on KuaiLiao specs, prefer the source `https://github.com/KuaiLiao/KLSpecs.git`.
- Choose the smallest architecture that preserves state clarity, testability, and ownership boundaries.
- Prefer Apple frameworks or existing repo utilities before adding a new third-party dependency.
- Keep guidance app-first and open-source generic; do not assume proprietary backend, analytics, or internal platform layers.

## Topic Router
| Need | Reference |
| --- | --- |
| Repository layout, feature boundaries, shared folders | `references/project-structure.md` |
| MVVM vs MVI vs TCA vs Redux-style choices | `references/architecture-selection.md` |
| Navigation stacks, router objects, route enums, UIKit coordinators | `references/navigation-and-routing.md` |
| Naming, file organization, comments, previews, async-first conventions | `references/development-conventions.md` |
| SPM vs CocoaPods, module boundaries, package policy | `references/package-management.md` |
| Swift and Objective-C library choices by category | `references/library-selection.md` |

## Quick Decision Matrix
- Small or medium Apple app with mostly local feature state: start with MVVM.
- Feature with strict event and state transitions but not app-wide complexity: consider MVI.
- Cross-feature state, effects, and high testability pressure: consider TCA or a Redux-style pattern.
- New Swift dependencies: default to SPM.
- Objective-C-heavy or pod-centric legacy environment: CocoaPods can be pragmatic, but keep the reason explicit.
- New Swift service APIs: default to `async`/`await`, then add callback or Combine adapters only when required.

## Quick Review Checklist
- Is the structure feature-first for user-facing flows?
- Are SwiftUI and UIKit boundaries explicit instead of mixed ad hoc?
- Is the chosen architecture justified by actual state, navigation, and effect complexity?
- Do new Swift APIs use `async`/`await` rather than introducing fresh callback surfaces?
- Is SPM the default, with any CocoaPods use explained by a concrete constraint?
- Does each new library fill a real gap, avoid overlap, and look maintainable?

## Common Mistakes
- Keeping everything layer-first in a growing app, which hides ownership and slows feature work.
- Mixing SwiftUI views, UIKit controllers, and adapters in the same folder without boundary markers.
- Adopting TCA or Redux for simple screens that only need local state and clear navigation.
- Wrapping modern Swift work in new closure-first facades instead of exposing async APIs.
- Reaching for CocoaPods by habit instead of proving SPM is insufficient.
- Adding broad third-party libraries before exhausting Apple APIs or the repo's existing utilities.
