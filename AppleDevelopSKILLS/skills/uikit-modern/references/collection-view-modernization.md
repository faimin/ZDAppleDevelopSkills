# Collection View Modernization

Use this reference when moving list or grid UI away from `reloadData`, hand-managed arrays, and large delegate-driven mutation paths.

## When To Use
- A table or collection view is doing frequent inserts, deletes, reorders, or mixed-content updates.
- Cell configuration logic is spread across `cellForItemAt`, `willDisplay`, and custom reset code.
- A list now needs sections, headers, accessories, swipe actions, or a later path to grid layouts.
- You want one surface that can cover list-style and grid-style presentation without separate infrastructure.

## Preferred Modern Choices
- For new complex list and grid work, prefer `UICollectionView`.
- Prefer `UICollectionViewDiffableDataSource` and `NSDiffableDataSourceSnapshot` over manual index-path bookkeeping.
- Use list-style collection views for settings, inbox, sidebar, and grouped list surfaces when available.
- Replace ad hoc registration with `UICollectionView.CellRegistration` when available.
- Replace broad `reloadData` calls with diffable snapshot application.
- Keep `UITableView` when the screen is a simple, stable list and there is no clear modernization payoff.
- Treat list-style collection conveniences, cell registration, and content or background configuration APIs as iOS 14+ conveniences. On iOS 13, fall back to ordinary compositional layout sections, classic cell registration, and explicit cell configuration code.

## Migration Path
1. Keep the old screen behavior, but define stable item identifiers first.
2. Move cell creation into registrations where supported, or isolate iOS 13 reuse-identifier fallback code.
3. Introduce a diffable data source while preserving the visible layout.
4. Convert simple vertical lists to `UICollectionLayoutListConfiguration` on iOS 14+, or use a plain compositional single-column section on iOS 13.
5. Adopt compositional layout only where custom structure is needed.

## Example

```swift
final class MessagesViewController: UIViewController {
    enum Section: Hashable {
        case inbox
    }

    struct Message: Hashable {
        let id: UUID
        let title: String
        let preview: String

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        static func == (lhs: Message, rhs: Message) -> Bool {
            lhs.id == rhs.id
        }
    }

    final class LegacyMessageCell: UICollectionViewCell {
        static let reuseIdentifier = "MessageCell"

        private let titleLabel = UILabel()
        private let previewLabel = UILabel()

        override init(frame: CGRect) {
            super.init(frame: frame)

            titleLabel.font = .preferredFont(forTextStyle: .headline)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false

            previewLabel.font = .preferredFont(forTextStyle: .subheadline)
            previewLabel.textColor = .secondaryLabel
            previewLabel.numberOfLines = 2
            previewLabel.translatesAutoresizingMaskIntoConstraints = false

            contentView.addSubview(titleLabel)
            contentView.addSubview(previewLabel)

            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
                titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                previewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
                previewLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                previewLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
                previewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
            ])
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func configure(with message: Message) {
            titleLabel.text = message.title
            previewLabel.text = message.preview
        }
    }

    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeLayout()
    )

    private var dataSource: UICollectionViewDiffableDataSource<Section, Message>?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        configureDataSource()
    }

    private func makeLayout() -> UICollectionViewLayout {
        if #available(iOS 14.0, *) {
            let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            return UICollectionViewCompositionalLayout.list(using: configuration)
        }

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(72)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: itemSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }

    private func configureDataSource() {
        if #available(iOS 14.0, *) {
            let registration = UICollectionView.CellRegistration<UICollectionViewListCell, Message> {
                cell, _, message in
                var content = cell.defaultContentConfiguration()
                content.text = message.title
                content.secondaryText = message.preview
                cell.contentConfiguration = content
            }

            dataSource = UICollectionViewDiffableDataSource<Section, Message>(
                collectionView: collectionView
            ) { collectionView, indexPath, message in
                collectionView.dequeueConfiguredReusableCell(
                    using: registration,
                    for: indexPath,
                    item: message
                )
            }
            return
        }

        collectionView.register(
            LegacyMessageCell.self,
            forCellWithReuseIdentifier: LegacyMessageCell.reuseIdentifier
        )
        dataSource = UICollectionViewDiffableDataSource<Section, Message>(
            collectionView: collectionView
        ) { collectionView, indexPath, message in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LegacyMessageCell.reuseIdentifier,
                for: indexPath
            ) as? LegacyMessageCell
            cell?.configure(with: message)
            return cell
        }
    }

    func render(messages: [Message]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Message>()
        snapshot.appendSections([.inbox])
        snapshot.appendItems(messages, toSection: .inbox)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}
```

## When Table Views Remain Acceptable
- The UI is a straightforward single-column list with stable behavior.
- Existing table view code is already correct, readable, and cheap to maintain.
- Features like orthogonal sections, mixed grids, or modern list accessories are not needed.

## Availability Note
- For an iOS 13 deployment target, keep the fallback path explicit: standard compositional layout sections, classic registration, and manual cell setup. Treat list-style collection conveniences and registration helpers as iOS 14+ upgrades.

## Common Traps
- Moving to `UICollectionView` but still calling `reloadData` for every state change.
- Keeping index-path-based business logic after adopting diffable identifiers.
- Letting mutable display fields like `title` or `preview` define item identity.
- Leaving tap handling on arbitrary subviews when collection selection or `UIControl` would express intent more clearly.
- Building custom cells for standard list rows that could use content configurations.
- Replacing a stable `UITableView` only for fashion, not for a concrete maintenance or feature gain.
