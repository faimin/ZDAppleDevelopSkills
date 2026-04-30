# Swift 5.10

## Major Changes
Swift 5.10 significantly tightened concurrency diagnostics and completed more of the data-isolation model when strict concurrency checking is enabled. It also introduced targeted unsafe escape hatches such as `nonisolated(unsafe)` for specific storage cases.

## Why It Matters
This release creates real migration pressure toward Swift 6. It is the point where concurrency warnings stop feeling theoretical and start exposing model flaws that will matter even more in Swift 6 language mode.

## Migration Notes
Turn on strict concurrency checking early, fix leaf `Sendable` and isolation issues first, and use `nonisolated(unsafe)` or `@unchecked Sendable` only with written justification. Treat warnings here as preparation work for Swift 6, not optional cleanup.

## Compatibility Risks
Older queue-protected globals, singleton initialization patterns, and non-`Sendable` reference types often begin failing or warning here. The biggest risk is silencing warnings instead of redesigning ownership and isolation.
