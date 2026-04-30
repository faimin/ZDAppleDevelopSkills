# Diagnostics

Use this file when the compiler or runtime is already telling you something is wrong and you need a fast mapping from symptom to likely cause.

## When to use
- Fixing non-`Sendable` warnings or actor isolation violations.
- Investigating `DecodingError` failures.
- Debugging Combine pipelines that update state on the wrong thread or stop producing values.
- Triaging migration issues while moving to stricter Swift language modes.

## Preferred modern choices
- Treat diagnostics as feedback about design boundaries, not just syntax to silence.
- Fix the ownership or isolation model before reaching for escape hatches like `@unchecked Sendable`.
- Reproduce decoding and publisher failures with the smallest real payload or pipeline that still fails.

## Non-Sendable warnings
Typical messages:
- `Sending 'x' risks causing data races`
- `Capture of 'x' with non-sendable type in a @Sendable closure`

What to check:
- Does `x` cross an actor or task boundary at all?
- Should `x` be a value type, actor, or immutable reference type?
- Is the closure implicitly `@Sendable` because of the API you passed it to?

```swift
struct SessionSnapshot: Sendable {
    let userID: String
}
```

## Actor isolation violations
Typical messages:
- `Main actor-isolated property 'x' can not be mutated from a nonisolated context`
- `Actor-isolated property 'x' can not be referenced from a nonisolated context`

What to check:
- Is the caller missing `await`?
- Should the caller itself be `@MainActor`?
- Should shared mutable state move behind an actor instead of a plain class?

```swift
@MainActor
final class ScreenModel {
    var title = ""
}
```

## Decoding failures
Typical failures:
- `DecodingError.keyNotFound`
- `DecodingError.typeMismatch`
- `DecodingError.dataCorrupted`

What to check:
- Does the payload key differ from the Swift property name?
- Is the decoder using the right date or data strategy?
- Are you decoding a heterogeneous payload into a single rigid model?

## Publisher threading mistakes
Typical symptoms:
- UI updates from background threads.
- Values never arrive because the subscription deallocated immediately.
- Pipelines retain their owner forever.

What to check:
- Is `receive(on:)` applied at the point where UI state is mutated?
- Is the `AnyCancellable` stored for the right lifetime?
- Should the operation be `async throws` instead of a publisher at all?

## Common traps
- Silencing warnings with `nonisolated(unsafe)` or `@unchecked Sendable` without a real safety case.
- Looking only at the failing property instead of the full isolation path that reaches it.
- Debugging `Codable` errors without logging the raw payload and coding path.
- Adding more queues to a Combine problem instead of clarifying ownership and scheduler boundaries.
