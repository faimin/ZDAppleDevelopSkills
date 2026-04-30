# Swift 6.0

## Major Changes
Swift 6.0 introduced the new language mode that raises correctness expectations around data isolation, actor boundaries, and `Sendable`. The release is less about flashy surface syntax and more about enforcing the concurrency model as a baseline.

## Why It Matters
This is the modern correctness inflection point. Code that seemed acceptable in Swift 5 can require structural changes in Swift 6 language mode, especially around shared mutable state and cross-actor transfers.

## Migration Notes
Adopt Swift 6 incrementally where possible, but do not treat the migration as a compiler-flag flip. Audit state ownership, actor boundaries, cancellation flow, and existential design before enabling the stricter mode widely.

## Compatibility Risks
The main risk is underestimating the amount of design work behind concurrency diagnostics. Superficial annotation-based fixes can compile while preserving fragile ownership and isolation boundaries.
