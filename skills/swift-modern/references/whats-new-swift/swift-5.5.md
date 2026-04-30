# Swift 5.5

## Major Changes
Swift 5.5 introduced `async`/`await`, task groups, `async let`, actors, `Sendable`, `AsyncSequence`, and continuation APIs for bridging callback code. It established Swift's first full structured concurrency model and replaced many queue-and-closure patterns with native language features.

## Why It Matters
This is the biggest architecture shift in modern Swift. It changes how new asynchronous APIs should be written and sets the foundation for later `Sendable` and actor-isolation rules.

## Migration Notes
Prefer native async APIs for new work, bridge legacy completion handlers with checked continuations, and use actors where shared mutable state already exists instead of wrapping old queue-based designs mechanically. Move fan-out async work toward task groups or `async let` instead of adding more ad hoc dispatch logic.

## Compatibility Risks
Mixing structured concurrency with legacy GCD and callback code can hide cancellation loss, double hops to the main thread, or accidental shared mutable state. Early migration often compiles before it is truly correct.
