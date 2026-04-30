# Observation and State

Use this file when the question is about state ownership in SwiftUI-era code, especially when deciding between `@Observable`, older `ObservableObject` patterns, Combine publishers, and async tasks.

## When to use
- Designing state models for SwiftUI application code.
- Migrating from `ObservableObject` and `@Published` to `@Observable`.
- Deciding who owns state versus who reads or mutates it.
- Coordinating state changes with Combine streams or async tasks.

## Preferred modern choices
- Prefer `@Observable` for new observation models when the deployment target and codebase support it.
- Keep state ownership explicit: view-local state stays local, shared model state lives in a dedicated observable type, and app-wide mutable state gets a clear isolation boundary.
- Prefer `@MainActor` on UI-owned observable models that mutate view state.
- Prefer async tasks for request-response workflows and use Combine only when the reactive composition itself is still valuable.

## `@Observable` era guidance
`@Observable` reduces boilerplate compared with `ObservableObject` and `@Published`, and it composes well with modern SwiftUI data flow.

```swift
import Observation

@Observable
@MainActor
final class CounterModel {
    var count = 0
    var isLoading = false

    func increment() {
        count += 1
    }
}
```

## State ownership tradeoffs
- `@State`: view-local value owned by a single view instance.
- `@Bindable`: view-facing binding into an `@Observable` model.
- `@Environment`: shared dependencies or models injected down the tree.
- Dedicated model type: shared mutable feature state with behavior and isolation.

Choose the narrowest owner that matches the lifecycle. Shared state that outlives one view should not be rebuilt as view-local state.

## Interaction boundaries with Combine and async tasks
- Async tasks should usually call model methods rather than mutate scattered state directly.
- Combine pipelines should terminate at a model boundary that owns the resulting state.
- If a publisher emits off-main and the model is main-actor-isolated, hop once at the boundary rather than sprinkling queue hops through views.

```swift
@MainActor
@Observable
final class ProfileModel {
    var user: User?
    var isLoading = false
    var errorMessage: String?

    func reload(service: UserService) async {
        isLoading = true
        defer { isLoading = false }
        errorMessage = nil

        do {
            user = try await service.fetchCurrentUser()
        } catch {
            user = nil
            errorMessage = error.localizedDescription
        }
    }
}
```

## Common traps
- Keeping feature state in the view when it should belong to a longer-lived model.
- Mixing `@Published`, manual callbacks, and async tasks without a clear owner for writes.
- Updating observable model state from detached work without restoring the right actor isolation.
- Treating `@Observable` migration as a syntax swap instead of a chance to simplify ownership.
