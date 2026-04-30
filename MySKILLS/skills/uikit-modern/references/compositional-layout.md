# Compositional Layout

Use this reference when a collection view needs more than a plain vertical list: grids, carousels, dashboards, sidebars, magazine-style sections, or mixed layouts in one surface.

## When To Use
- Different sections need different geometry.
- A screen mixes rows, cards, and horizontally scrolling groups.
- Self-sizing content needs a clearer layout model than manual flow layout callbacks.

## Modern Layout Rules
- Think in hierarchy: item -> group -> section -> layout container.
- Start with the smallest repeatable item, then define the group that arranges it.
- Use estimated dimensions when cell height depends on content.
- Prefer boundary supplementary items for headers and footers.
- Use decoration views for section chrome, not for content.

## Example

```swift
private func makeLayout() -> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .estimated(88)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .estimated(88)
    )
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 12
    section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
    section.orthogonalScrollingBehavior = .none

    return UICollectionViewCompositionalLayout(section: section)
}
```

## Hierarchy Notes
- `NSCollectionLayoutItem`: one cell-sized unit.
- `NSCollectionLayoutGroup`: arranges one or more items horizontally, vertically, or with nesting.
- `NSCollectionLayoutSection`: adds spacing, scrolling behavior, and supplementary or decoration items.
- `UICollectionViewCompositionalLayout`: combines sections, often with a section provider closure.

## Estimated Sizing
- Use `.estimated(...)` when text or dynamic content changes height.
- Make the cell layout constraints complete so self-sizing can resolve correctly.
- Do not mix estimated height with incomplete internal constraints.

## Orthogonal Scrolling
- Use section-level orthogonal scrolling for carousels inside a vertically scrolling page.
- Keep the number of orthogonally scrolling sections intentional; too many nested scroll contexts hurt usability.

## Supplementary And Decoration Guidance
- Headers and footers: boundary supplementary items.
- Badges attached to cells: supplementary items anchored to the item or container.
- Section backgrounds or visual grouping: decoration views owned by the layout.

## Common Traps
- Treating a group like a cosmetic wrapper instead of the main sizing unit.
- Using absolute sizes everywhere and then fighting rotation, split view, or dynamic type.
- Expecting estimated sizing to work while the cell subviews have ambiguous constraints.
- Putting content into decoration views that the data source does not own.
