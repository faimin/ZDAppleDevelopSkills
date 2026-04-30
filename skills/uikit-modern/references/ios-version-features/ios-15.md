# iOS 15 UIKit Notes

## Major Additions
- `UIKeyboardLayoutGuide` gave UIKit a constraint-based way to keep controls clear of the keyboard.
- UIKit continued its configuration-driven direction with `UIButton.Configuration` and stronger button and menu composition patterns.
- Sheet presentation became a mainstream controller pattern through `UISheetPresentationController` and standard detents.

## Recommended Usage
- Prefer `UIKeyboardLayoutGuide` over frame shifting or broad notification-only hacks when the deployment target allows it.
- Use configuration-driven buttons and menus so standard controls adapt better to system appearance and state changes.
- Favor standard sheet presentation over custom half-sheet containers for editing and focused tasks.

## Migration Notes
- If your deployment target still includes iOS 13 or 14, keep keyboard-notification fallback code isolated behind the same input coordinator.
- Replace one-off button styling code with configuration-based styling gradually; do not mix multiple state systems in the same control tree.

## Compatibility Risks
- `UIKeyboardLayoutGuide` is not an iOS 13 baseline API, so older targets still need a fallback constraint or inset path.
- Menu and button configuration logic can become inconsistent if part of the screen still mutates subviews directly.
- Custom modal containers age poorly once standard sheets and keyboard-safe guides are available.
