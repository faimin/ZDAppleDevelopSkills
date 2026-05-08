# Architecture Selection

Use this reference when choosing how much architectural structure an Apple app or feature actually needs.

## Core Principle

Choose the smallest architecture that keeps state ownership, effects, and navigation understandable. Do not pay TCA complexity for screens that only need straightforward local state.

## MVVM

Prefer MVVM when:
- a feature has one or a few screens
- state is mostly local to the feature
- async work is present but manageable
- the team wants a familiar default with clear test seams

Strengths:
- easy to teach
- works well with SwiftUI and UIKit
- scales well for many app features before heavier coordination is necessary

Risks:
- view models can become dumping grounds if state, navigation, and service orchestration are not split carefully

## MVI (Page-Level)

MVI applies at the **page or feature level**. Use it when a single screen or flow benefits from explicit, traceable intent → state transitions, but the complexity does not yet span multiple features.

Prefer MVI when:
- a screen has non-trivial state transitions (forms, wizards, multi-step flows)
- state derivation should be easy to trace and unit-test
- unidirectional flow is desirable without committing to a whole-app store

Strengths:
- explicit intent → state pipeline, easy to follow and test
- Combine publishers and Swift enum associated values make the pattern natural
- page-scoped: no global store, no cross-feature coupling

Risks:
- ceremony overhead for screens that only need local state

### Best Practice: MVI with Combine and Enum Associated Values

```swift
// MARK: - Intent (user actions as typed enum with associated values)
enum FeedIntent {
    case viewDidLoad
    case refresh
    case searchQueryChanged(String)
    case itemTapped(id: String)
}

// MARK: - State (value type, single source of truth for one page)
struct FeedState {
    var items: [FeedItem] = []
    var isLoading = false
    var searchQuery = ""
    var error: String?
}

// MARK: - ViewModel (page-scoped, owns the Combine lifecycle)
final class FeedViewModel {
    @Published private(set) var state = FeedState()

    private let service: FeedService
    private var cancellables = Set<AnyCancellable>()

    init(service: FeedService) {
        self.service = service
    }

    func send(_ intent: FeedIntent) {
        switch intent {
        case .viewDidLoad, .refresh:
            loadFeed()
        case .searchQueryChanged(let query):
            state.searchQuery = query
        case .itemTapped:
            break // route via coordinator — ViewModel does not own navigation
        }
    }

    private func loadFeed() {
        state.isLoading = true
        state.error = nil
        service.fetchFeed(query: state.searchQuery)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.state.isLoading = false
                    if case .failure(let error) = completion {
                        self?.state.error = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] items in self?.state.items = items }
            )
            .store(in: &cancellables)
    }
}

// MARK: - UIViewController binding
final class FeedViewController: UIViewController {
    private let viewModel: FeedViewModel
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.render($0) }
            .store(in: &cancellables)
        viewModel.send(.viewDidLoad)
    }

    private func render(_ state: FeedState) {
        // Drive all UI from a single state snapshot — no partial updates
    }
}
```

## TCA (App-Level)

TCA applies at the **app or cross-feature level**. Use it when state and effects must be coordinated across multiple features and high testability with explicit dependency injection is a core requirement.

Prefer TCA when:
- many features share state or trigger effects in each other
- reducer-driven behavior and explicit action logging are requirements
- the team is comfortable with the TCA learning curve

Strengths:
- strong consistency for large apps
- explicit state and side-effect modeling
- high leverage for complex, interconnected product flows

Risks:
- heavier learning curve
- too much ceremony for small apps or isolated screens

## Practical Defaults

- Small app or simple feature: start with MVVM.
- Single page or flow with complex state transitions: use MVI.
- Large app with shared state, effects, and deep testing requirements: use TCA.

## Avoid Over-Architecture

Warning signs:
- adding reducers, actions, and effect plumbing for a static screen
- introducing a global store before feature boundaries are understood
- choosing a pattern because it is fashionable rather than because ownership is difficult

If a feature only needs a view, a small amount of local state, one service call, and straightforward navigation, MVVM is usually enough.
