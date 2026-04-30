# View Controller Lifecycle And Scenes

Use this reference when behavior depends on foreground activation, window ownership, child containment, or where lifecycle work should actually live in a scene-based UIKit app.

## When To Use
- A bug appears only after backgrounding, foregrounding, external display use, or multiple windows.
- Controllers are doing work in the wrong lifecycle method.
- A container controller is embedding children and state propagation is unclear.

## Modern Lifecycle Rules
- Treat the iOS 13 scene model as the baseline: app-level setup and scene-level UI ownership are separate.
- Put one-time view creation in `viewDidLoad`.
- Put layout-dependent adjustments in `viewDidLayoutSubviews` or later when geometry matters.
- Use appearance callbacks for visible-state work, and scene activation state for foreground or background behavior. Prefer `viewIsAppearing(_:)` on iOS 13+ when work must run during every appearance before the transition finishes; keep `viewDidAppear(_:)` for work that should wait until presentation, animation, or containment is fully settled.
- Respect containment boundaries: parent controllers own child installation and lifecycle forwarding.

## Example

```swift
final class HostViewController: UIViewController {
    private let child = DetailViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(child)
        view.addSubview(child.view)
        child.view.frame = view.bounds
        child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        child.didMove(toParent: self)
    }

    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        refreshVisibleStateIfNeeded()
    }
}
```

`viewIsAppearing(_:)` is the better default here because the example is about refreshing visible child state during each appearance pass, not about waiting until a presentation animation fully completes. If the refresh depends on final presentation completion, `viewDidAppear(_:)` is still the right callback.

## Scene Model Notes
- `UIApplicationDelegate` handles app-wide concerns.
- `UISceneDelegate` and scene-owned objects handle window setup and scene transitions.
- When behavior depends on whether UI is active, inspect the scene activation state instead of assuming a single foreground window.

## Multi-Window Awareness
- Do not store window-specific UI assumptions in global singletons.
- If an action needs the current presentation context, derive it from the active scene and visible controller chain.

## Containment Boundaries
- Parent installs child with `addChild`, view insertion, and `didMove(toParent:)`.
- Child controllers should not assume they control navigation or presentation outside their container contract.

## Common Traps
- Starting expensive refresh logic in `viewDidLoad` when the view may never become visible.
- Assuming app foreground implies the relevant scene is active.
- Accessing a single shared window in code paths that may run under multiple scenes.
- Forgetting containment lifecycle calls, leaving child controllers half-installed.
