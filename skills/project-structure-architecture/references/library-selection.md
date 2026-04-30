# Library Selection

Use this reference when choosing third-party libraries for Apple app projects or reviewing whether a dependency should be added at all.

## Selection Rules

- Prefer Apple system APIs when they fully cover the requirement.
- Add a library only for meaningful leverage: clearer architecture, lower defect risk, or missing platform capability.
- Prefer widely used, maintained libraries with a narrow, well-understood role.
- Avoid dependency sprawl: one good library in a category is better than overlapping stacks.

## Swift-Focused Defaults

### Dependency Injection

- Prefer `Factory` when the project benefits from lightweight Swift dependency injection without a heavyweight container.
- Prefer direct initializer injection when the graph is small and explicit wiring stays readable.

### Networking

- Prefer `URLSession` when the app needs straightforward requests with limited customization.
- Prefer `Alamofire` when the app benefits from mature request building, interceptors, upload or download support, reachability patterns, or a shared networking layer.
- Do not add a second networking abstraction on top of Alamofire unless the architecture already standardizes it.

### Model Parsing

- If the project is SPM-first and wants a model-mapping helper, prefer `ReerCodable`.
- If the project is CocoaPods-based and the Swift layer needs a model-mapping helper, prefer `SmartCodable`.

### Layout

- Prefer SwiftUI layout primitives for SwiftUI views.
- Prefer Auto Layout anchors in UIKit when constraints are simple and local.
- Prefer `SnapKit` when the team already writes UIKit constraints fluently with it or when it materially improves readability in complex UIKit layouts.

## Objective-C Environment Recommendations

### Module Coordination

- Prefer `ZDMediator` in Objective-C-heavy modular apps that need decoupled cross-module routing or service access.

### Layout

- Prefer `Masonry` for Objective-C Auto Layout codebases that already rely on chainable constraint builders.

### Reactive Flows

- Prefer `ReactiveObjC` only when the project already uses reactive Objective-C patterns or needs to integrate with an existing signal-based architecture.
- Do not introduce `ReactiveObjC` into an otherwise non-reactive codebase for isolated convenience.

### UIKit Callback Ergonomics

- Prefer `BlocksKit` for legacy Objective-C UIKit callback simplification when the codebase already uses it consistently.
- Do not mix many callback helper libraries in the same target.

### Objective-C Model Parsing

- Prefer `YYModel` for Objective-C model parsing in CocoaPods-based Objective-C environments.

## Segmented And Paging Views

- For segmented or paging container scenes in Swift, prefer `JXSegmentedView`.
- For segmented or paging container scenes in Objective-C, prefer `JXCategoryView`.
- Keep the choice aligned with the host language of the module instead of mixing both libraries across one feature without a migration reason.

## Decision Matrix

- Need no library:
  - System API is sufficient.
  - The wrapper would only rename existing platform behavior.
- Need a lightweight architectural library:
  - `Factory` for Swift DI.
  - `ZDMediator` for Objective-C module routing.
- Need networking help:
  - `URLSession` first.
  - `Alamofire` when the networking surface is broad enough to justify it.
- Need model parsing help:
  - `ReerCodable` for SPM-based Swift environments.
  - `SmartCodable` for CocoaPods-based Swift environments.
  - `YYModel` for CocoaPods-based Objective-C environments.
- Need layout help:
  - Native SwiftUI or Auto Layout first.
  - `SnapKit` or `Masonry` when the surrounding codebase already uses them or constraints are complex enough to benefit.
- Need reactive or callback legacy support:
  - `ReactiveObjC` and `BlocksKit` only when matching existing Objective-C ecosystem patterns.
- Need segmented or paging containers:
  - `JXSegmentedView` in Swift modules.
  - `JXCategoryView` in Objective-C modules.

## Rejection Heuristics

- Reject libraries that duplicate a system framework without a strong gain.
- Reject libraries that solve only local style preferences.
- Reject overlapping libraries in the same category unless there is a clear migration plan.
- Reject packages with weak maintenance, unclear licensing, or poor Apple platform support.
