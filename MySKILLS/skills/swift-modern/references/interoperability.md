# Interoperability

Use this file when Swift code crosses into Objective-C APIs, selectors, nullability boundaries, or callback-based frameworks.

## When to use
- Exposing Swift types or methods to Objective-C.
- Deciding whether `@objc`, `dynamic`, or a Swift-only wrapper is the right boundary.
- Bridging nullable Objective-C APIs into safe Swift models.
- Converting Objective-C completion handlers or delegates into async Swift code.

## Preferred modern choices
- Prefer Swift-native APIs internally and keep Objective-C interop at explicit boundary layers.
- Use `@objc` only for symbols that must participate in Objective-C runtime lookup, selectors, Interface Builder, or KVO-era APIs.
- Prefer targeted `@objc` annotations over `@objcMembers` unless nearly the entire type must be visible to Objective-C.
- Add `dynamic` only when Objective-C dynamic dispatch is actually required.
- Preserve nullability and threading semantics when wrapping Objective-C callbacks into Swift async APIs.

## `@objc`, `dynamic`, and selectors
```swift
final class PlayerController: NSObject {
    @objc func handleTap(_ sender: UIButton) {
        print(sender)
    }
}

let action = #selector(PlayerController.handleTap(_:))
```

- `@objc` exposes Swift declarations to the Objective-C runtime.
- `dynamic` forces Objective-C style dynamic dispatch and is mainly for KVO or method swizzling scenarios.
- `#selector` only works for Objective-C-visible members.

## Nullability and bridging
Objective-C nullability annotations decide whether Swift sees a value as optional, non-optional, or implicitly unwrapped. When the Objective-C API is poorly annotated, prefer a Swift wrapper that normalizes the contract.

```swift
func normalizedName(from rawValue: NSString?) -> String? {
    guard let rawValue else { return nil }
    return rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
}
```

## Callback bridging between Objective-C and Swift
Bridge one-shot completion handlers with checked continuations and preserve single-resume correctness.

```swift
func fetchToken(service: LegacyTokenService) async throws -> String {
    try await withCheckedThrowingContinuation { continuation in
        service.fetchToken { token, error in
            if let token {
                continuation.resume(returning: token)
            } else {
                continuation.resume(throwing: error ?? TokenError.missingValue)
            }
        }
    }
}

enum TokenError: Error {
    case missingValue
}
```

For multi-event delegates or notification-style APIs, prefer `AsyncStream` or a dedicated adapter object.

## Common traps
- Marking large Swift types `@objcMembers` when only one or two APIs need Objective-C visibility.
- Adding `dynamic` out of habit instead of proving the runtime behavior needs it.
- Exposing a class to Objective-C without deciding whether it should actually be `final` on the Swift side.
- Trusting nullable Objective-C contracts that are actually violated at runtime.
- Wrapping completion handlers into continuations without handling cancellation or double-callback behavior.
