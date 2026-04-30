# Navigation And Presentation

Use this reference when choosing between push, sheet, popover, or replacement presentation flows in a modern UIKit app.

## When To Use
- A new screen needs a clear relationship to the current context.
- Modal behavior, sheet detents, or popover anchoring is under discussion.
- Navigation stack bugs appear after mixing push and modal flows.

## Preferred Choices
- Push for drill-down navigation inside an existing hierarchy.
- Present a sheet for focused tasks, editing, creation flows, or temporary branching work.
- Use a popover for anchored secondary content on supported idioms and contexts.
- Keep navigation-stack ownership clear. A child should not push onto an arbitrary stack it does not own.
- Prefer modern sheet customization APIs when available, but keep a plain page-sheet or form-sheet fallback for older targets.

## Example

```swift
func presentFilters(from presenter: UIViewController) {
    let controller = FiltersViewController()
    controller.modalPresentationStyle = .pageSheet

    if #available(iOS 15.0, *), let sheet = controller.sheetPresentationController {
        sheet.detents = [.medium(), .large()]
        sheet.prefersGrabberVisible = true
    } else {
        controller.modalPresentationStyle = .formSheet
    }

    presenter.present(controller, animated: true)
}
```

## Push Vs Sheet Vs Popover
- Push: the next screen is part of the same navigation story.
- Sheet: the user is performing a task that can be dismissed and resumed from the current context.
- Popover: the user needs quick anchored detail or controls without taking over the full flow.

## Stack Integrity Rules
- Do not push the same semantic destination repeatedly without checking whether it is already on top.
- Avoid presenting from stale controllers that are no longer visible.
- Dismiss or delegate modal completion cleanly before mutating the underlying navigation stack.

## Availability And Fallback
- Treat `UISheetPresentationController` detents and grabber configuration as preferred upgrades, not a baseline-safe assumption for every iOS 13 deployment.
- For older targets, keep the fallback simple: use `.pageSheet` or `.formSheet`, and avoid building custom fake detents unless the product requirement is explicit.

## Common Traps
- Using a modal where users expect the back gesture and stack history.
- Presenting a sheet from a controller that is already being dismissed.
- Pushing from deep child views that do not own routing decisions.
- Ignoring sheet configuration and then reimplementing medium-height behavior manually.
