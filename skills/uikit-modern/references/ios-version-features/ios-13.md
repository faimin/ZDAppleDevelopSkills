# iOS 13 UIKit Notes

## Major Additions
- `UICollectionViewCompositionalLayout` established the modern collection-view layout baseline for lists, grids, and mixed sections.
- `UICollectionViewDiffableDataSource` and `NSDiffableDataSourceSnapshot` introduced snapshot-driven updates and stable item identity.
- The scene lifecycle split app lifecycle from window-scene lifecycle, which changed how UIKit apps manage activation, windows, and presentation roots.

## Recommended Usage
- Treat iOS 13 as the starting point for modern `UICollectionView` architecture: compositional layout plus diffable identity.
- Model sections and items explicitly before migrating away from `reloadData` and index-path bookkeeping.
- Route foreground, window ownership, and top-level presentation logic through scenes instead of assuming one global app window.

## Migration Notes
- On iOS 13, use compositional layout and diffable data source even if later conveniences such as list configurations or cell registrations are unavailable.
- Expect some iOS 14+ collection conveniences to be missing; keep iOS 13 fallback code localized instead of rebuilding the whole screen around older table patterns.

## Compatibility Risks
- Assuming a single window or a single foreground scene causes lifecycle and presentation bugs.
- Treating diffable identity as display state instead of stable identity still breaks animations, even on the modern baseline.
- Mixing old delegate mutation with snapshots leads to hard-to-debug list state drift.
