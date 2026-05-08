# Objective-C Coding Conventions

## Getter: Build Into a Local Variable, Assign ivar Last

In lazy getter methods, create the object through a named local variable and assign to the ivar only as the final statement. This keeps the initialization sequence readable and reduces the chance of accidentally referencing a half-configured `_ivar`.

```objc
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                              style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.estimatedRowHeight = 60;
        [tableView registerClass:[ArticleCell class]
         forCellReuseIdentifier:ArticleCell.reuseIdentifier];
        _tableView = tableView; // assign to ivar last
    }
    return _tableView;
}
```

## Statement Expression for Compact Object Initialization

Wrap multi-property object creation in a `({ })` statement expression (Clang extension). The expression evaluates to the last statement's value, grouping creation and configuration into a single self-contained unit.

```objc
// Inline initialization — creation and configuration are co-located
self.titleLabel = ({
    UILabel *label = [UILabel new];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = UIColor.labelColor;
    label.numberOfLines = 0;
    label.adjustsFontForContentSizeCategory = YES;
    label; // evaluated value of the expression
});

self.stackView = ({
    UIStackView *stack = [[UIStackView alloc] initWithArrangedSubviews:@[
        self.titleLabel,
        self.subtitleLabel,
    ]];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 8;
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack;
});
```

Use in `viewDidLoad` or property declarations where grouping creation with configuration improves clarity. Do not use for objects whose creation involves conditional logic — a regular `if`/`else` block is clearer there.

## Prefer RAC Over KVO When ReactiveObjC Is Available

If the project depends on `ReactiveObjC`, use `RACObserve` instead of raw KVO registration. RAC handles observer lifecycle automatically, eliminates the `-observeValueForKeyPath:ofObject:change:context:` boilerplate, and integrates cleanly with signal pipelines.

```objc
// Prefer: RAC observation
[RACObserve(self.viewModel, isLoading)
    subscribeNext:^(NSNumber *isLoading) {
        self.loadingIndicator.hidden = !isLoading.boolValue;
    }];

[[[RACObserve(self.viewModel, items)
    skip:1]                         // skip initial emission if not needed
    deliverOnMainThread]
    subscribeNext:^(NSArray *items) {
        [self reloadWithItems:items];
    }];

// Avoid: raw KVO for the same purpose when RAC is available
[self.viewModel addObserver:self
                 forKeyPath:@"isLoading"
                    options:NSKeyValueObservingOptionNew
                    context:nil];
```

RAC signals are automatically torn down when the subscriber deallocates. If raw KVO is unavoidable, always balance `-addObserver:` and `-removeObserver:` at symmetric lifecycle points and use a unique context pointer.

## Check respondsToSelector Before Optional Delegate Calls

Always guard optional protocol method invocations with `-respondsToSelector:`. This is a hard requirement: calling an unimplemented optional method crashes at runtime with `unrecognized selector`.

```objc
// Single optional call
- (void)notifyDelegateDidSelectItem:(Item *)item {
    if ([self.delegate respondsToSelector:@selector(listView:didSelectItem:)]) {
        [self.delegate listView:self didSelectItem:item];
    }
}

// Multiple calls — check each selector independently
- (void)notifyDelegateWillBeginEditing {
    id<ListViewDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(listViewWillBeginEditing:)]) {
        [delegate listViewWillBeginEditing:self];
    }
}

- (void)notifyDelegateDidEndEditing {
    id<ListViewDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(listViewDidEndEditing:)]) {
        [delegate listViewDidEndEditing:self];
    }
}
```

Capture `self.delegate` into a local variable when making multiple calls in the same method — the delegate property could be set to `nil` between checks under concurrent access.

Required protocol methods (no `@optional` qualifier) do not need this guard: the compiler enforces conformance.
