# Diagnostics

Use this reference when a modern UIKit screen behaves incorrectly and the issue smells like diffable identity, compositional layout assumptions, keyboard handling, or stale cell configuration state.

## When To Use
- Rows animate as inserts and deletes instead of clean updates.
- Layout sizing works on one device class but breaks on another.
- The keyboard overlaps controls or scroll behavior jumps during editing.
- Reused cells show the wrong badge, accessory, or background state.

## Broken Diffable Identity Symptoms
- Visible reordering that should have been a content refresh.
- Edited rows flash or lose selection state.
- Applying a snapshot triggers duplicate identifier assertions.

Safety rules:
- Check that equality and hashing use stable identity.
- Confirm the same logical item keeps the same identifier across filters and edits.

```swift
struct RowModel: Hashable {
    let id: UUID
    var title: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: RowModel, rhs: RowModel) -> Bool {
        lhs.id == rhs.id
    }
}
```

## Invalid Layout Assumptions
- Absolute sizes break under split view, dynamic type, or wider containers.
- Estimated sizing jitters because the cell constraints are incomplete.
- Orthogonal sections fight parent scrolling because too many nested scroll behaviors exist.

## Keyboard Overlap Regressions
- Bottom controls are pinned to the safe area instead of the keyboard guide.
- Scroll insets change, but the active editor still is not scrolled into view.
- Manual frame shifting conflicts with sheet presentation or rotation.

## Stale Cell State And Configuration Bugs
- A reused row shows an old accessory or highlight state.
- Custom subview mutation bypasses `contentConfiguration` and `backgroundConfiguration`.
- State logic is split across registration, delegate callbacks, and cell subclasses with no single source of truth.

## Common Traps
- Debugging animation symptoms before verifying identity semantics.
- Blaming self-sizing when the real problem is a mutable hash implementation.
- Fixing keyboard overlap with more notifications instead of better constraints.
- Resetting one reused subview manually while leaving other visual state behind.
