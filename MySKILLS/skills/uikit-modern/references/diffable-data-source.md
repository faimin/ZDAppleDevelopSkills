# Diffable Data Source

Use this reference when a list or grid needs safe animated updates without manual synchronization between model arrays and visible index paths.

## When To Use
- Rows or items can be inserted, removed, moved, filtered, or refreshed.
- Manual `performBatchUpdates` logic is becoming fragile.
- You need to express UI state as sections plus items rather than imperative mutations.

## Safety Rules
- Use `NSDiffableDataSourceSnapshot` as the source of truth for visible structure.
- Item identifiers must be stable and unique. Prefer business identity such as a database ID or UUID.
- Do not include mutable display fields in `Hashable` if identity should survive text or badge changes.
- Use targeted item or section updates when possible instead of rebuilding unrelated parts of the snapshot.
- Treat newer convenience APIs as opt-in upgrades, not baseline-safe guidance for the full iOS 13 through iOS 26 span.

## Example

```swift
enum Section: Hashable {
    case favorites
    case all
}

struct Contact: Hashable {
    let id: UUID
    var name: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Contact, rhs: Contact) -> Bool {
        lhs.id == rhs.id
    }
}

var snapshot = NSDiffableDataSourceSnapshot<Section, Contact>()
snapshot.appendSections([.favorites, .all])
snapshot.appendItems(favoriteContacts, toSection: .favorites)
snapshot.appendItems(allContacts, toSection: .all)
dataSource.apply(snapshot, animatingDifferences: true)
```

## Update Patterns
- Initial load: build all sections, then append items per section.
- Item content change with same identity: update the backing model, then use `reconfigureItems(_:)` on iOS 15+ or `reloadItems(_:)` on iOS 13 and iOS 14 as the compatible fallback.
- Section replacement: delete old items or sections explicitly, then append the new structure.
- Filtering or sorting: produce the new ordered identifiers and apply one snapshot; avoid mixing manual view mutations with diffable updates.

## Data Source Example

```swift
let dataSource: UICollectionViewDiffableDataSource<Section, Contact>

if #available(iOS 14.0, *) {
    dataSource = UICollectionViewDiffableDataSource<Section, Contact>(
        collectionView: collectionView
    ) { collectionView, indexPath, contact in
        collectionView.dequeueConfiguredReusableCell(
            using: registration,
            for: indexPath,
            item: contact
        )
    }
} else {
    collectionView.register(ContactCell.self, forCellWithReuseIdentifier: ContactCell.reuseIdentifier)
    dataSource = UICollectionViewDiffableDataSource<Section, Contact>(
        collectionView: collectionView
    ) { collectionView, indexPath, contact in
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ContactCell.reuseIdentifier,
            for: indexPath
        ) as? ContactCell
        cell?.configure(with: contact)
        return cell
    }
}
```

## Availability Notes
- `UICollectionView.CellRegistration` and `dequeueConfiguredReusableCell(using:for:item:)` are iOS 14+ conveniences. For iOS 13, register a reuse identifier and configure a classic cell subclass or contained content view explicitly.
- `reconfigureItems(_:)` is a targeted content refresh API for iOS 15+. If the deployment target includes iOS 13 or iOS 14, teach `reloadItems(_:)` as the fallback refresh path.

## Identity Modeling Guidance
- Good identity: `contact.id`, `message.serverID`, `photo.assetIdentifier`.
- Bad identity: row index, display title, timestamp string that can change formatting.
- If content changes often, keep a stable ID and store mutable display data separately in the model.

## Common Traps
- Hashing all fields and then wondering why edited content animates as delete plus insert.
- Using duplicate identifiers in the same snapshot.
- Applying snapshots from stale background state without reconciling current ordering.
- Mutating visible cells directly and expecting that to stay correct after the next snapshot.
