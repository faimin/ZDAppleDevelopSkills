# Development Conventions

Use this reference when defining app-layer coding conventions, review rules, or default file structure for Apple platform projects.

## Core Rules

- Prefer platform conventions over team-specific novelty.
- Keep files small enough to review in one pass.
- Use system APIs and language features before adding wrappers.
- Treat concurrency, ownership, and naming as correctness issues, not style-only issues.

## Naming

- Use `PascalCase` for types, protocols, and file names that define a primary type.
- Use `camelCase` for functions, properties, and local values.
- Name booleans with `is`, `has`, `can`, or `should`.
- Name protocols by role, not by implementation detail.
- Match file names to the main exported type or feature entry point.

## File Organization

- Group by feature first when the app is non-trivial; keep models, views, services, and reducers close to their feature when possible.
- Keep cross-feature shared code in clearly named shared folders such as `Shared`, `Core`, or `Infrastructure`.
- Split large files when they mix unrelated responsibilities, not just when they exceed a line count.
- Prefer one primary type per file unless tightly coupled helper types are trivial and private.
- Keep feature assets, strings, and nib or storyboard resources in feature-owned bundles rather than defaulting everything into `Bundle.main`.

## Comments

- Comment why a rule, workaround, or tradeoff exists.
- Do not narrate obvious code.
- Delete stale comments quickly; outdated comments are worse than no comments.
- Use doc comments for APIs that are reused across modules or require call-site constraints.

## SwiftUI Previews

- Keep previews next to the view they exercise unless the project already centralizes them.
- Use lightweight preview data and deterministic states.
- Preview important states explicitly: loading, empty, populated, error, and long-text or accessibility edge cases when relevant.
- Do not hide production dependency problems behind heavy preview-only mocks.

## State Ownership

- Keep state as local as possible and lift it only when multiple consumers need a shared source of truth.
- Views own ephemeral UI state. Feature models own business state. Services do not own view state.
- Prefer unidirectional data flow for complex features so ownership and mutation paths stay obvious.
- In SwiftUI, choose the wrapper that matches ownership:
  - `@State` for local value state.
  - `@StateObject` for view-owned reference state.
  - `@ObservedObject` or injected observable state when the view does not own the object.
  - `@Environment` or `@EnvironmentObject` only for broadly shared dependencies or app-level state.

## Localization And Resources

- Prefer `.xcstrings` catalogs for new localization work.
- Keep localized strings close to the feature or module that owns them when the project is modular.
- Prefer typed resource access through each module's bundle boundary rather than assuming every lookup comes from the main bundle.
- If a feature ships as a framework or package, verify its assets and localization can be loaded without app-target-only assumptions.

## Swift Concurrency Default

- Prefer `async`/`await` over new closure-based APIs in Swift code.
- Use completion handlers only when required by legacy APIs, Objective-C interop, or multi-platform constraints.
- When bridging old code, keep the callback boundary thin and expose async APIs at the application layer.
- Prefer structured concurrency over detached tasks.
- Make cancellation, actor isolation, and `Sendable` part of the design review, not post-hoc cleanup.

## Review Heuristics

- If a file mixes UI, networking, persistence, and mapping, split it.
- If a new dependency exists only to avoid a small amount of native code, reject it.
- If ownership of mutable state is unclear, simplify the flow before adding features.
- If new Swift code introduces closures where async APIs would work, treat that as a routing smell.
- If resources or strings are referenced from `Bundle.main` by habit rather than by ownership, treat that as a modularity smell.
