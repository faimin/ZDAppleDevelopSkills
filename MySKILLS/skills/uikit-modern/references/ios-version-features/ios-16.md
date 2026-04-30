# iOS 16 UIKit Notes

## Major Additions
- `UISheetPresentationController` grew into a more flexible controller tool with custom detents and stronger edge-attached behavior options.
- Modern controller presentation patterns increasingly favored standard sheet APIs over bespoke bottom-sheet implementations.
- UIKit navigation and bar composition kept moving toward standard item- and action-based configuration instead of custom container chrome.

## Recommended Usage
- Use standard sheet detents, selected detent tracking, and edge-attached options before building a custom resizing sheet.
- Keep push navigation for hierarchy and sheets for temporary tasks; modern controllers behave best when those responsibilities stay separate.
- Prefer navigation items and bar-button APIs over directly managing ad hoc toolbar or bar subviews.

## Migration Notes
- If you already use sheets from iOS 15, iOS 16 is a good point to remove custom height math in favor of standard detents where product requirements allow.
- When modernizing navigation, simplify routing decisions before restyling the bar itself.

## Compatibility Risks
- Custom detents and newer sheet behavior assumptions do not automatically apply to older targets.
- Mixing push and sheet semantics in one flow still causes stack duplication, dismissal bugs, and poor state restoration.
- Over-customized bars become harder to reconcile with later system appearance changes.
