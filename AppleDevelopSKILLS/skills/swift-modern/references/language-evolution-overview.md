# Language Evolution Overview

Use this file when you need a migration map from older Swift to the modern baseline. It is most useful when the codebase spans multiple language eras and you need to decide what to fix first.

## When to use
- Migrating code from Swift 4.2 or early Swift 5 releases.
- Explaining why older idioms still appear in a codebase.
- Establishing which language changes matter before touching concurrency or observation.

## Preferred modern choices
- Prefer current syntax, explicit existentials with `any`, and typed errors or results over legacy ad hoc patterns.
- Prefer value semantics, `Codable`, property wrappers, result builders, and structured concurrency where available.
- Prefer namespaced extensions, `final` leaf classes, and focused extensions by responsibility over monolithic type bodies.
- Prefer Combine over KVO and structured concurrency over GCD for new app-layer code.
- Treat Swift 6 strictness as a design signal. Fix the model instead of suppressing warnings.
- Use the per-version notes for exact release details when availability, diagnostics, or migration behavior changed.

## Timeline: Swift 4.2 to 6.3
- Swift 4.2: transitional baseline before ABI stability; older collection and standard library naming still common.
- Swift 5.0: ABI stability on Apple platforms, `Result`, dynamic callable support, and a stable standard library era.
- Swift 5.1: property wrappers and opaque result types (`some`) become mainstream.
- Swift 5.2: diagnostics and package tooling improve; many codebases still remain callback-heavy.
- Swift 5.3: multiple trailing closures and package improvements reduce syntactic friction.
- Swift 5.4: result builders stabilize and SwiftUI-oriented APIs become cleaner.
- Swift 5.5: structured concurrency, `async`/`await`, actors, and `AsyncSequence` shift application architecture.
- Swift 5.6: concurrency checking expands and existential pressure increases.
- Swift 5.7: explicit `any` for existentials, primary associated types, and more realistic protocol modeling.
- Swift 5.8: macros groundwork and stricter type-checking behavior continue reducing inference surprises.
- Swift 5.9: macros ship, observation becomes practical in app code, and package plugins are established.
- Swift 5.10: stricter concurrency diagnostics prepare codebases for Swift 6 migration.
- Swift 6.0: language mode raises correctness pressure around data races, actor isolation, and `Sendable`.
- Swift 6.1: migration continues with better diagnostics and ecosystem adaptation.
- Swift 6.2: approachable concurrency, caller-context async execution, and low-level memory APIs reshape modern guidance.
- Swift 6.3: interoperability, build tooling, and optimization control broaden Swift's reach beyond traditional app code.

## Supplemental Sources
Use these alongside the local version notes when the task explicitly asks for release-by-release feature coverage:

- Swift 4.2 to 6.1 overview: `https://www.whatsnewinswift.com/?from=4.2&to=6.1`
- Swift 6.2 summary: `https://juejin.cn/post/7546908230271975451`
- Swift 6.3 summary: `https://juejin.cn/post/7620661836632424483`
- Swift 6.3 Embedded Swift notes: `https://www.swift.org/blog/embedded-swift-improvements-coming-in-swift-6.3/`

Prefer Swift.org release posts when an official source exists, and use the supplemental articles to fill migration-oriented examples or condensed release summaries.

## Migration priorities
1. Syntax and standard library cleanup.
   Replace deprecated spellings, remove obsolete collection patterns, and adopt current API names first.
2. ABI-era language features.
   Adopt `Result`, property wrappers, result builders, opaque result types, and `Codable` where they simplify design.
3. Concurrency model migration.
   Replace callback pyramids, GCD coordination, and ad hoc thread hopping with structured concurrency and actors. Replace KVO-first observation where possible with Combine or newer Swift observation tools.
4. Swift 6 strictness.
   Address `Sendable`, actor isolation, existential clarity, and cancellation semantics as correctness work.

## Example
```swift
// Before: callback and queue-driven flow common in older Swift 4.2 code.
func loadProfile(completion: @escaping (Result<User, Error>) -> Void) {
    service.fetchUser { result in
        DispatchQueue.main.async {
            completion(result)
        }
    }
}

// After: structured concurrency expresses the same intent directly.
@MainActor
func loadProfile() async throws -> User {
    try await service.fetchUser()
}
```

## Common traps
- Trying to solve Swift 6 diagnostics before cleaning obvious legacy syntax and API issues.
- Migrating to `async`/`await` while keeping hidden GCD hops and shared mutable state.
- Treating `any` and `some` as interchangeable; migration often reveals real abstraction issues.
- Assuming the latest toolchain behavior from memory instead of checking exact version notes.
