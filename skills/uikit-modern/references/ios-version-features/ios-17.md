# iOS 17 UIKit Notes

## Major Additions
- Apple documents `viewIsAppearing(_:)` as the preferred callback for view updates that depend on final traits or accurate geometry during appearance.
- `UIContentUnavailableConfiguration` gives view controllers and views a system-backed empty-state model instead of bespoke placeholder stacks.
- UIKit added trait-observation APIs such as `registerForTraitChanges`, which reduced the need for broad trait-change branching.

## Recommended Usage
- Move trait- and geometry-dependent setup from `viewWillAppear(_:)` into `viewIsAppearing(_:)` when that better matches Apple guidance.
- Use `UIContentUnavailableConfiguration` for loading, search-empty, and no-content states before building custom empty-state scaffolding.
- Prefer narrow trait observation or automatic trait-aware update points over one giant `traitCollectionDidChange` switch.

## Migration Notes
- When updating older controllers, keep `viewWillAppear(_:)` for transition-coordinator work, but move display-state refreshes to `viewIsAppearing(_:)`.
- Standard empty-state configurations are usually easier to adopt incrementally than reworking a whole screen shell.

## Compatibility Risks
- Treating `viewWillAppear(_:)` as the default place for all visual updates can leave traits and geometry out of date.
- Empty states built as custom one-off stacks often drift away from system spacing, accessibility, and later content configuration improvements.
- Trait observation becomes noisy if you register for everything instead of only the traits that matter.
