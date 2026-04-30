# Navigation And Routing

Use this reference when choosing how an Apple app should own navigation state and route transitions.

## Preferred SwiftUI Direction

For SwiftUI-first apps, prefer stack-based routing with:
- a route enum
- a router object that owns the path
- `NavigationStack` for per-flow navigation

This keeps routing explicit and testable without burying transitions in ad hoc button handlers.

## Route Enum

Use a `Route` enum as the canonical navigation surface:

```swift
enum Route: Hashable {
    case home
    case settings
    case item(Item)
    case folder(Folder)
}
```

Benefits:
- strongly typed navigation
- one place to see possible destinations
- easier route-specific testing and review

## Router Object

Use a focused router object for each navigation stack:

```swift
@Observable
class Router {
    var routes: [Route] = []

    func navigate(route: Route) {
        routes.append(route)
    }

    func pop() {
        _ = routes.popLast()
    }
}
```

## `NavigationStack` Ownership

- Give each tab or major app area its own router when stacks should stay independent.
- Keep navigation state close to the shell that owns it.
- Do not let leaf views create hidden global routing behavior if the app shell should own the stack.

Example:

```swift
struct MainView: View {
    @State private var homeRouter = Router()
    @State private var settingsRouter = Router()

    var body: some View {
        TabView {
            NavigationStack(path: $homeRouter.routes) {
                HomeView()
            }

            NavigationStack(path: $settingsRouter.routes) {
                SettingsView()
            }
        }
    }
}
```

## When UIKit Coordinators Still Make Sense

UIKit coordinators remain reasonable when:
- the flow is still UIKit-heavy
- multiple legacy view controllers coordinate presentation and dismissal
- the app integrates with frameworks that still expect UIKit navigation ownership

Even then:
- keep coordinator boundaries explicit
- avoid giant coordinator objects that also become service locators
- prefer typed route surfaces where possible

## Review Heuristics

- If navigation can only be understood by reading many unrelated button actions, introduce a route surface.
- If one router owns unrelated stacks, split by app area.
- If SwiftUI and UIKit transitions interleave, make the bridge or host boundary explicit rather than letting navigation leak across layers.
