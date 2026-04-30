# Swift Testing

Use this file when writing or reviewing tests with the modern Swift Testing framework instead of adding new XCTest-first patterns by default.

## When to Use
- New Swift tests can use `import Testing` with the current toolchain and project conventions.
- The task mentions `@Test`, `#expect`, `#require`, suites, tags, traits, parameterized tests, async tests, or actor-isolated behavior.
- A legacy XCTest case should be rewritten into modern Swift testing style without losing clarity or coverage.

## Preferred Modern Choices
- Prefer `struct`-based suites and `@Test` for new coverage instead of new `XCTestCase` boilerplate.
- Prefer `#expect` for assertions and `#require` when later checks depend on successful unwrapping or setup.
- Prefer parameterized tests over copy-pasted examples when the same behavior is exercised across multiple inputs.
- Treat async and actor tests as normal design cases, not as special workarounds layered onto synchronous helpers.
- Prefer traits, tags, display names, and time limits when they clarify intent or execution boundaries.

## Core Patterns

### Suites and display names

```swift
@Suite("Authentication")
struct AuthenticationTests {
    @Test("Accepts valid credentials")
    func loginSucceeds() { }
}
```

### Basic test and expectation

```swift
import Testing

@Test
func createsUser() {
    let user = User(email: "test@example.com")
    #expect(user.isValid)
}
```

### Unwrap-or-stop boundaries

```swift
@Test
func loadsProfile() throws {
    let profile = try #require(makeProfile())
    #expect(profile.name.isEmpty == false)
}
```

### Error expectations

```swift
@Test
func invalidEmailThrows() {
    #expect(throws: ValidationError.self) {
        try validate(email: "invalid")
    }
}
```

### Parameterized coverage

```swift
@Test(arguments: [(2, 3, 5), (0, 0, 0)])
func addition(a: Int, b: Int, expected: Int) {
    #expect(a + b == expected)
}
```

- Use direct tuple arguments for compact case tables.
- Use `zip` when inputs should be paired positionally.
- Use multiple argument collections when the full Cartesian product is intended.

### Traits, tags, and execution gates

```swift
extension Tag {
    @Tag static var slow: Self
}

@Test("Refreshes cache", .tags(.slow), .timeLimit(.seconds(5)))
func refreshesCache() async throws {
    try await refreshCache()
}
```

- Use tags for selection and reporting.
- Use `.disabled(...)` or `.enabled(if:)` only when the condition is explicit and temporary.
- Use time limits for genuinely bounded work, not as a substitute for fixing race conditions.

### Async and actor-aware tests

```swift
@Test
func actorState() async {
    let counter = Counter()
    await counter.increment()
    #expect(await counter.value == 1)
}
```

- Prefer `async` tests over blocking adapters.
- Await actor state directly instead of smuggling state through detached helpers or sleeps.
- Use confirmation-style async expectations when the test is driven by callbacks, notifications, or multiple events.

## Migration Pitfalls
- Porting XCTest naming, inheritance, and setup habits mechanically instead of adopting `@Test`, value-oriented suites, and focused fixtures.
- Replacing every `XCTAssert*` call one-for-one without using `#require` or typed `#expect(throws:)` where diagnostics improve.
- Keeping repetitive single-case tests that should become parameterized inputs.
- Using sleeps, semaphores, or queue juggling in async tests when structured concurrency or actor-aware assertions express the behavior directly.
