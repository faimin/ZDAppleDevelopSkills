# List Configurations

Use this reference when a collection view should behave like a modern UIKit list with standard row metrics, accessories, swipe actions, and content configurations.

## When To Use
- Building settings, mailboxes, inspector panels, sidebars, or grouped lists.
- You want UIKit to provide row styling and interaction semantics instead of custom chrome.
- Standard accessories, contextual menus, or swipe actions matter more than bespoke cell layout.

## Preferred Choices
- Use `UICollectionLayoutListConfiguration` for list layout when available.
- Use `UIListContentConfiguration` for text and image content when available.
- Use accessories for disclosure indicators, checkmarks, reorder controls, and custom aligned views.
- Keep content and background responsibilities separate with `contentConfiguration` and `backgroundConfiguration`.
- Prefer `UICollectionView` list interactions, `UIControl`, or `UIButton` for tappable affordances instead of attaching `UITapGestureRecognizer` to passive row subviews.
- Use the collection view delegate for `UIContextMenuConfiguration` instead of attaching an unsupported menu API directly to `UICollectionViewListCell`.
- Prefer `UICollectionView.CellRegistration`, `UICollectionLayoutListConfiguration`, `UIListContentConfiguration`, and `UIBackgroundConfiguration` on iOS 14 and later. On iOS 13, fall back to explicit cell registration, custom cell configuration, and compositional sections built without list conveniences.

## Example

```swift
var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
listConfiguration.trailingSwipeActionsConfigurationProvider = { indexPath in
    let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, done in
        done(true)
    }
    return UISwipeActionsConfiguration(actions: [delete])
}

let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)

let registration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> {
    cell, _, item in
    var content = UIListContentConfiguration.subtitleCell()
    content.text = item.title
    content.secondaryText = item.subtitle
    cell.contentConfiguration = content

    var background = UIBackgroundConfiguration.listGroupedCell()
    background.cornerRadius = 12
    cell.backgroundConfiguration = background
    cell.accessories = [.disclosureIndicator()]
}

func collectionView(
    _ collectionView: UICollectionView,
    contextMenuConfigurationForItemAt indexPath: IndexPath,
    point: CGPoint
) -> UIContextMenuConfiguration? {
    UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: nil) { _ in
        UIMenu(children: [
            UIAction(title: "Archive") { _ in },
            UIAction(title: "Flag") { _ in }
        ])
    }
}
```

## Accessory And Action Guidance
- Use accessories for state and navigation affordances instead of hand-placing tiny image views.
- Use swipe actions for destructive or high-frequency row actions.
- Use contextual menus through the collection view delegate for secondary actions that should not permanently occupy row space.

## Configuration Boundaries
- `UIListContentConfiguration`: text, secondary text, image, directional spacing, and text properties.
- `UIBackgroundConfiguration`: fill, stroke, corner style, selected or highlighted background treatment.
- Cell subclass custom views: only when standard content configuration is not expressive enough.
- `UILayoutGuide`: preferred for spacer, alignment, or grouping structure when no actual view needs to render.

## Availability Note
- `UICollectionView.CellRegistration`, `UICollectionLayoutListConfiguration`, `UIListContentConfiguration`, and `UIBackgroundConfiguration` are iOS 14+ conveniences. For iOS 13 fallback code, keep reuse identifiers, cell subclasses, and manual background or content setup localized so the upgrade path stays clear.

## Common Traps
- Mutating labels and image views directly without resetting state for reuse.
- Putting selection styling into the content configuration instead of the background configuration.
- Adding custom accessory views for patterns already supported by list accessories.
- Adding tap gesture recognizers to decorative subviews and then debugging highlight, focus, or accessibility inconsistencies.
- Using list layout, but then reimplementing every standard margin and background by hand.
