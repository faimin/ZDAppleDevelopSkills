# iOS 14 UIKit Notes

## Major Additions
- `UICollectionLayoutListConfiguration` added list-style collection views as a first-class UIKit pattern.
- `UICollectionView.CellRegistration` and supplementary registrations reduced manual reuse plumbing.
- `UIListContentConfiguration` and `UIBackgroundConfiguration` moved UIKit further toward configuration-driven cells and views.

## Recommended Usage
- Prefer list-style `UICollectionView` screens over new `UITableView` work when you need grouped lists, accessories, and a future path to mixed layouts.
- Use registrations and content or background configurations instead of hand-resetting labels, image views, and backgrounds during reuse.
- Keep cell subclasses focused on truly custom layouts rather than standard list rows.

## Migration Notes
- When raising an iOS 13 screen to an iOS 14+ deployment target, replace manual registration and custom row chrome first; that yields most of the maintenance win.
- Move empty-state and row-state rendering toward configuration objects before attempting larger controller rewrites.

## Compatibility Risks
- These list and registration conveniences are not part of the iOS 13 baseline; older targets need explicit registration and manual content setup.
- Mixing configuration-driven cells with old ad hoc mutation patterns can leave reused state inconsistent.
- Treating list configuration as purely cosmetic misses its structural value for standard spacing, accessories, and swipe behavior.
