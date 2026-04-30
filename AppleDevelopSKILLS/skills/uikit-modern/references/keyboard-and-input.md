# Keyboard And Input

Use this reference when text fields, text views, search bars, or inline editors must stay visible and predictable while the keyboard appears, changes size, or moves across scenes.

## When To Use
- A screen contains editable controls near the bottom of the viewport.
- Scroll views need to keep the active field visible during editing.
- Manual frame shifting or notification-only keyboard code is causing overlap regressions.

## Preferred Modern Choices
- Use `UIKeyboardLayoutGuide` for keyboard-safe bottom constraints when available.
- Coordinate keyboard movement with scroll views through content inset or focused-item visibility updates.
- Move first responder deliberately during submit, next, or validation transitions.
- Prefer directional anchors and layout guides when expressing the surrounding input layout.
- Keep notification-based fallback code isolated for cases where layout guides cannot cover the screen structure.

## Example

```swift
final class ComposerViewController: UIViewController {
    private let textField = UITextField()
    private let sendButton = UIButton(type: .system)
    private var keyboardFallbackConstraint: NSLayoutConstraint?
    private var keyboardObservers: [NSObjectProtocol] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(textField)
        view.addSubview(sendButton)

        textField.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false

        let leading = textField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
        let trailing = textField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -12)
        let buttonTrailing = sendButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        let buttonCenterY = sendButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor)

        if #available(iOS 15.0, *) {
            let guide = view.keyboardLayoutGuide
            NSLayoutConstraint.activate([
                leading,
                trailing,
                buttonTrailing,
                buttonCenterY,
                textField.bottomAnchor.constraint(equalTo: guide.topAnchor, constant: -12)
            ])
        } else {
            keyboardFallbackConstraint = textField.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -12
            )
            if let keyboardFallbackConstraint {
                NSLayoutConstraint.activate([
                    leading,
                    trailing,
                    buttonTrailing,
                    buttonCenterY,
                    keyboardFallbackConstraint
                ])
            }
            startKeyboardFallbackObservation()
        }
    }

    deinit {
        for observer in keyboardObservers {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    private func startKeyboardFallbackObservation() {
        let center = NotificationCenter.default
        keyboardObservers = [
            center.addObserver(
                forName: UIResponder.keyboardWillChangeFrameNotification,
                object: nil,
                queue: .main
            ) { [weak self] notification in
                self?.handleKeyboard(notification: notification)
            },
            center.addObserver(
                forName: UIResponder.keyboardWillHideNotification,
                object: nil,
                queue: .main
            ) { [weak self] notification in
                self?.handleKeyboard(notification: notification)
            }
        ]
    }

    private func handleKeyboard(notification: Notification) {
        guard let keyboardFallbackConstraint else { return }

        let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect) ?? .zero
        let convertedFrame = view.convert(endFrame, from: view.window)
        let intersectionHeight = max(0, view.bounds.maxY - convertedFrame.minY)
        let safeAreaBottom = view.safeAreaInsets.bottom
        let bottomSpacing = max(0, intersectionHeight - safeAreaBottom)
        keyboardFallbackConstraint.constant = -(bottomSpacing + 12)

        let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0.25
        let curveRawValue = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt) ?? 7
        let curve = UIView.AnimationOptions(rawValue: curveRawValue << 16)

        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: [curve, .beginFromCurrentState]
        ) {
            self.view.layoutIfNeeded()
        }
    }
}
```

The iOS 15+ path uses `UIKeyboardLayoutGuide` and needs no notifications. The iOS 13 and iOS 14 fallback is complete only if it actively listens for `keyboardWillChangeFrame` or `keyboardWillHide` and updates the stored bottom constraint, as shown above.

## Scroll View Coordination
- If the active editor lives inside a scroll view, ensure the focused rect can scroll above the keyboard-safe area.
- Keep insets and scroll indicators in sync if manual adjustments are still required.
- Avoid fighting the system by animating both constraints and manual frame changes at the same time.

## Layout Defaults
- Prefer `leadingAnchor` and `trailingAnchor` over left and right anchors.
- Prefer `UILayoutGuide` for non-rendering spacing or alignment helpers instead of adding empty `UIView` instances.

## First Responder Transitions
- Use the return key and explicit next or submit behavior to move focus predictably.
- Resign first responder on dismissal or scene deactivation only when doing so does not discard user intent.

## Fallback Strategies
- On targets where `UIKeyboardLayoutGuide` is unavailable, use keyboard notifications to update a stored bottom constraint or scroll inset, including matching the keyboard animation timing.
- Use keyboard notifications only when the layout cannot be expressed with a keyboard guide, such as legacy container structures that are not yet modernized.
- Keep fallback code localized to one coordinator or controller instead of scattering notification handlers everywhere.

## Common Traps
- Pinning input bars to the safe area and expecting the keyboard to avoid them automatically.
- Updating `view.frame.origin.y` directly, which fights rotation, sheets, and multitasking.
- Forgetting scroll indicator insets when content inset changes.
- Forcing first responder changes during validation failures and creating focus loops.
