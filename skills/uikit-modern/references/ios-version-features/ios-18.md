# iOS 18 UIKit Notes

## Major Additions
- Current Apple UIKit documentation says that in iOS 18 and later, `layoutSubviews()` supports automatic trait tracking for traits from the view's `traitCollection`.
- Apple also documents automatic observation tracking for UIKit update points, with `UIObservationTrackingEnabled` required to enable the behavior on iOS 18.
- `updateProperties()` is positioned as the preferred place for content and styling updates that should react to observed data without forcing extra layout work.

## Recommended Usage
- Put content and styling updates in `updateProperties()` and reserve `layoutSubviews()` for geometry.
- Use automatic observation tracking and configuration update handlers when visible cells or views should refresh from observed model changes.
- Read traits in supported update points so UIKit can track and refresh the relevant work automatically.

## Migration Notes
- For teams adopting Swift Observation with UIKit, gate the behavior carefully and document the `UIObservationTrackingEnabled` requirement for iOS 18.
- Treat Apple current docs here as the source of behavior guidance; the exact set of tracked methods matters more than broad "UIKit is reactive now" claims.

## Compatibility Risks
- Forgetting the `UIObservationTrackingEnabled` plist key can make an intended observation-based update path appear broken on iOS 18.
- Keeping model-driven styling in `layoutSubviews()` increases unnecessary layout churn.
- Mixing manual invalidation with observation-driven refreshes can hide the real source of updates.
