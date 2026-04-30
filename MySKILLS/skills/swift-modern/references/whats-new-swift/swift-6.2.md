# Swift 6.2

## Major Changes
According to the official Swift 6.2 release announcement, this release centers on approachable concurrency and a broader "safer by default, lower friction" theme. Key changes include:

- approachable concurrency options, including main-actor-by-default isolation for executable targets
- async functions that can run in the caller's execution context rather than always hopping away through older `nonisolated async` behavior
- the new `@concurrent` attribute for explicit opt-in concurrent execution
- low-level safe systems features such as `InlineArray`, `Span`, and opt-in strict memory safety
- a typed `NotificationCenter` model and the new `Observations` async sequence for streaming observable transactions
- the new concurrency-friendly `Subprocess` package
- diagnostic-group warning controls, prebuilt `swift-syntax` support for macro-heavy builds, named tasks, and better LLDB async debugging
- Swift Testing additions such as exit testing and richer attachments
- WebAssembly support

## Why It Matters
Swift 6.2 changes the default guidance for a lot of application code. Concurrency becomes easier to adopt without as much annotation overhead, and app teams get more than just concurrency: typed notifications, transaction-aware observations, better test artifacts, and cleaner automation APIs all shift what "modern Swift baseline" should mean.

## Migration Notes
- Validate whether approachable concurrency settings fit the target before enabling them broadly; they are especially relevant to UI executables, not every module.
- If you adopt caller-context async execution, revisit older assumptions about `nonisolated async` work hopping away from the caller.
- Use `@concurrent` deliberately for work that should actually leave actor serialization.
- Prefer typed notifications and `Observations` over stringly notifications or ad hoc state fan-out when Foundation and observation availability allow it.
- Treat `InlineArray`, `Span`, and strict memory-safety checks as deliberate low-level tools, not casual replacements for ordinary collection code.
- For build-heavy macro projects, account for the new prebuilt `swift-syntax` path when evaluating CI performance.

## Compatibility Risks
The biggest risk is assuming 6.2 makes all concurrency warnings go away by default. Behavior depends on language mode and isolation settings, and low-level APIs like `Span` or strict memory safety checks should be adopted only where the team can reason clearly about memory lifetimes and unsafe boundaries. Another common mistake is adopting approachable concurrency flags without re-checking actor assumptions in existing libraries.

Sources:
- https://www.swift.org/blog/swift-6.2-released/
- https://juejin.cn/post/7546908230271975451
Last verified: 2026-04-30
