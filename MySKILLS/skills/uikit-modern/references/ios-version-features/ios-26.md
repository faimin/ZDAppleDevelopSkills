# iOS 26 UIKit Notes

## Major Additions
- Apple current UIKit updates documentation for June 2025 highlights `UIBackgroundExtensionView`, `UIGlassEffect`, `UIGlassContainerEffect`, `UIScrollEdgeEffect`, `UIUpdateLink`, and `UIBarButtonItem.badge` as notable recent UIKit additions.
- Apple also documents that standard UIKit bars, controls, sheets, and popovers automatically pick up the new Liquid Glass system appearance on the latest platforms.
- Current UIKit updates guidance says UIKit now supports Swift Observable objects in update paths such as `layoutSubviews()`, with the broader observation-tracking guidance documented separately.

## Recommended Usage
- Let standard bars and controls adopt Liquid Glass automatically before adding custom materials.
- Use `UIGlassEffect` and `UIGlassContainerEffect` sparingly for advanced custom surfaces, and test accessibility, contrast, crowding, and focus behavior carefully.
- Treat `UIScrollEdgeEffect` and `UIBackgroundExtensionView` as targeted tools for immersive or edge-aware composition, not as blanket styling defaults.
- Use `UIUpdateLink` only when you truly need precise control over the UIKit update process, such as low-latency drawing or synchronized update timing.

## Migration Notes
- Build with the latest SDK first and audit how standard UIKit components already changed before introducing custom Liquid Glass effects.
- If you must preserve an older visual appearance while adopting the latest SDK, Apple documents `UIDesignRequiresCompatibility` as a compatibility key; use it deliberately rather than as a permanent escape hatch.
- Treat these notes as a summary of current Apple sources, not a claim that every highlighted API first appeared in iOS 26.
- Summary provenance: based on Apple UIKit updates and Liquid Glass guidance, last verified on `2026-04-29`.

## Compatibility Risks
- Overriding standard bars, toolbars, or control backgrounds can fight Liquid Glass and newer edge effects.
- Applying custom glass too broadly can hurt legibility, hierarchy, and accessibility.
- Using advanced effects or update-loop APIs without a concrete need increases maintenance cost and makes cross-version behavior harder to reason about.
