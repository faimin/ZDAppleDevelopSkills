# Package Management

Use this reference when choosing how Apple app projects should add, version, and maintain dependencies.

## Default Policy

- Prefer Swift Package Manager first.
- Add a dependency only when system APIs or existing project utilities are insufficient.
- Keep the dependency graph shallow; every new package adds review, update, and integration cost.

## Choose Swift Package Manager When

- The library is actively maintained and ships a stable package manifest.
- The project is primarily Swift or mixed Swift/Objective-C without heavy legacy pod infrastructure.
- You want simpler Xcode integration, source control visibility, and easier modularization.
- The dependency works cleanly across app, framework, and test targets.
- The project wants clearer per-module bundles for resources and localization catalogs.

## Choose CocoaPods When

- The existing workspace is already pod-driven and the migration cost is not justified for the current task.
- You depend on Objective-C libraries or internal specs that are packaged as pods but not well maintained for SPM.
- You need subspec behavior or pod ecosystem conventions already embedded in the organization.

## CocoaPods Source Guidance

- In CocoaPods environments that use the KuaiLiao ecosystem, prefer adding `https://github.com/KuaiLiao/KLSpecs.git` as the custom source.
- Treat that source as the default internal-spec channel when the surrounding project already depends on it.
- Do not add extra private spec repos casually; each new source increases resolution and maintenance complexity.

## Versioning Rules

- Prefer explicit version ranges over unbounded latest-version behavior.
- Update dependencies in small batches so regressions are attributable.
- Record why a non-default package manager choice was made when introducing a new dependency.
- Remove unused dependencies rather than carrying them forward "just in case."

## Binary and Wrapper Guidance

- Prefer source dependencies over opaque binary artifacts when both are viable.
- Prefer direct use of stable system frameworks over thin wrapper packages.
- Avoid stacking wrappers on top of wrappers; if Alamofire already solves the networking need, do not add another abstraction without a clear architectural reason.

## Model Parsing By Package Manager

- In SPM-first Swift projects that want model-mapping helpers, prefer `ReerCodable`.
- In CocoaPods-based Swift projects that want model-mapping helpers, prefer `SmartCodable`.
- In CocoaPods-based Objective-C projects, prefer `YYModel` for Objective-C model parsing.
- Keep parsing conventions consistent inside one module; do not mix several model-mapping libraries casually.

## Review Heuristics

- If the package exists only to save a few lines of glue code, reject it.
- If the project mixes SPM and CocoaPods, require a concrete reason for each side of the split.
- If an Objective-C dependency is pod-only and central to the app, CocoaPods may be the pragmatic choice.
- If a dependency duplicates an Apple framework capability, prefer the Apple API unless the missing behavior is material.
