# Swift 5.7

## Major Changes
Swift 5.7 introduced explicit existential spelling with `any`, primary associated types, regular expressions, clock and duration APIs, opaque parameter types, and broader existential support. The release also pushed `Sendable` and isolation concepts closer to everyday code.

## Why It Matters
This release forces clearer type-system choices while also making several modern APIs practical enough for routine app code. Teams touching parsing, timing, and protocol-heavy abstractions now get clearer language for modeling those problems directly.

## Migration Notes
Use `any` when you genuinely need existential storage or dynamic dispatch, and prefer generics or `some` when the concrete type relationship matters. Reevaluate protocol-heavy abstractions, adopt `Clock` and `Duration` instead of ad hoc time units, and treat regex as a focused parsing tool rather than a replacement for readable domain logic.

## Compatibility Risks
Existential changes can trigger widespread source edits and expose architectural shortcuts. Regex adoption can also tempt teams to replace clear parsing logic with dense expressions, and `any` can be overused where `some` or plain generics would preserve better static guarantees.
