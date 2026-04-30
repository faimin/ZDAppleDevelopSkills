# Combine

Use this file when the problem is about publisher composition, threading, backpressure expectations, subscription lifetime, or bridging Combine with async code.

## When to use
- Maintaining or extending existing Combine-based application code.
- Choosing between a publisher pipeline and an async function or `AsyncSequence`.
- Debugging scheduler issues, dropped subscriptions, or retain cycles in pipelines.
- Bridging legacy reactive code toward structured concurrency without rewriting everything at once.

## Preferred modern choices
- Prefer async functions for single-result work and `AsyncSequence` for pull-based iteration.
- Keep Combine where the codebase already uses publisher composition, cancellation chaining, or multiple downstream subscribers.
- Prefer explicit scheduler boundaries with `subscribe(on:)` and `receive(on:)` rather than assuming thread hops.
- Prefer storing `AnyCancellable` in the owning object instead of relying on temporary locals.

## Publisher lifecycle
A Combine pipeline does nothing until it is subscribed. Once subscribed, ownership of the returned `AnyCancellable` controls lifetime.

```swift
final class SearchModel {
    private var cancellables: Set<AnyCancellable> = []

    func bind(query: AnyPublisher<String, Never>) {
        query
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { value in
                print("Searching for \(value)")
            }
            .store(in: &cancellables)
    }
}
```

## Scheduler rules
- `subscribe(on:)` affects upstream work such as subscription setup and request handling.
- `receive(on:)` affects downstream delivery from that point onward.
- UI consumers should usually receive values on the main queue or main actor boundary before mutating UI state.

```swift
service.publisher(for: request)
    .subscribe(on: queue)
    .map(\.data)
    .decode(type: User.self, decoder: decoder)
    .receive(on: DispatchQueue.main)
    .sink(receiveCompletion: handleCompletion, receiveValue: render)
    .store(in: &cancellables)
```

## Memory ownership in pipelines
- `sink` and `assign` closures can retain `self`.
- Use `[weak self]` when the pipeline should not keep the owner alive indefinitely.
- Avoid weak captures when the owner must remain alive for correctness; redesign the ownership boundary instead of guessing.

## Bridging Combine to async sequences
Prefer a direct async API for new code, but when you already have a publisher, bridge it carefully.

```swift
func values<P: Publisher>(from publisher: P) -> AsyncThrowingStream<P.Output, Error> {
    AsyncThrowingStream { continuation in
        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .finished:
                    continuation.finish()
                case .failure(let error):
                    continuation.finish(throwing: error)
                }
            },
            receiveValue: { value in
                continuation.yield(value)
            }
        )

        continuation.onTermination = { _ in
            cancellable.cancel()
        }
    }
}
```

## Common traps
- Creating a pipeline in a local scope and losing the `AnyCancellable` immediately.
- Assuming upstream work runs on the same scheduler as downstream delivery.
- Capturing `self` strongly in long-lived pipelines without realizing the owner can never deallocate.
- Using Combine for simple request-response work that would be clearer as `async throws`.
