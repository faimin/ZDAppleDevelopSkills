# Concurrency

Use this file when the design question involves `async` work, cross-thread state, actor boundaries, or Swift 6 concurrency diagnostics.

## When to use
- Replacing completion handlers or GCD with structured concurrency.
- Designing parallel work with `async let` or task groups.
- Fixing cancellation bugs, actor isolation violations, or `Sendable` warnings.
- Deciding whether a model, service, or cache should be an actor or main-actor-isolated type.

## Preferred modern choices
- Prefer `async`/`await` over completion handlers for one-shot asynchronous work.
- Prefer `async let` for fixed fan-out and `withThrowingTaskGroup` for dynamic child tasks.
- Prefer actor isolation or `@MainActor` over locks and manual queue confinement.
- Prefer child tasks in the current task tree over `Task.detached`, unless you must break isolation or priority inheritance.
- Treat `Sendable` as part of the data model. Fix transfers instead of silencing diagnostics.

## Async and await
```swift
struct User: Decodable, Sendable {
    let id: String
    let name: String
}

func fetchUser(from url: URL) async throws -> User {
    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode(User.self, from: data)
}
```

## Task groups
Use task groups when the number of child tasks is data-driven and you need structured cancellation or partial collection.

```swift
func fetchUsers(ids: [String]) async throws -> [User] {
    try await withThrowingTaskGroup(of: User.self) { group in
        for id in ids {
            group.addTask {
                let url = try endpointURL(forUserID: id)
                return try await fetchUser(from: url)
            }
        }

        var users: [User] = []
        for try await user in group {
            users.append(user)
        }
        return users
    }
}
```

```swift
func endpointURL(forUserID id: String) throws -> URL {
    guard let url = URL(string: "https://example.com/users/\(id)") else {
        throw URLError(.badURL)
    }
    return url
}
```

## Cancellation
Cancellation is cooperative. Check for it in long-running work, propagate it through bridges, and avoid swallowing `CancellationError`.

```swift
func search(query: String) async throws -> [String] {
    try Task.checkCancellation()
    let results = try await service.search(query: query)
    try Task.checkCancellation()
    return results
}
```

## Actors and global actors
Use actors for shared mutable state that should not depend on the main thread. Use `@MainActor` for UI-owned models and state transitions that must stay on the main actor.

```swift
actor TokenStore {
    private var token: String?

    func read() -> String? { token }
    func write(_ newValue: String?) { token = newValue }
}

@MainActor
final class ProfileModel {
    var user: User?

    func reload(id: String) async throws {
        let url = try endpointURL(forUserID: id)
        user = try await fetchUser(from: url)
    }
}
```

## Sendable and isolation diagnostics
- `struct` and immutable value types are the easiest `Sendable` building blocks.
- Reference types crossing task boundaries need clear isolation or immutable thread-safe storage.
- `@unchecked Sendable` is a last resort that requires a real thread-safety proof.
- If a call crosses an actor boundary, both the parameter and result types must satisfy the boundary.

## Common traps
- Launching `Task.detached` from UI code to dodge main-actor restrictions.
- Mutating actor-isolated or main-actor state from callback code without hopping back through the correct isolation.
- Returning non-`Sendable` classes from async APIs that may cross actors later.
- Forgetting that cancellation must cancel the underlying operation too when bridging legacy APIs.
