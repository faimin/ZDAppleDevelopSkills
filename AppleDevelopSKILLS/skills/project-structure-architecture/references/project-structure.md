# Project Structure

Use this reference when deciding how an Apple app repository should be laid out before feature code starts sprawling across unrelated folders.

## Preferred App-First Layout

For non-trivial apps, organize by feature first and keep genuinely shared code in a focused library layer:

```text
Project/
├── Features/
│   ├── Home/
│   ├── Settings/
│   ├── Main/
│   └── [Feature]/
├── Library/
│   ├── Routes/
│   ├── Extensions/
│   ├── Views/
│   ├── Models/
│   ├── Services/
│   ├── Database/
│   └── Core/
└── Resources/
    ├── AppAssets.xcassets
    └── App.xcstrings
```

For teams that want a stronger engineering split inside each feature, use a generated shape like this:

```text
Project/
├── App/
│   ├── AppDelegate/
│   ├── Scene/
│   ├── Root/
│   └── Bootstrap/
├── Features/
│   ├── Home/
│   │   ├── Views/
│   │   ├── ViewModels/
│   │   ├── Models/
│   │   ├── Services/
│   │   ├── Routing/
│   │   └── Resources/
│   │       ├── HomeAssets.xcassets
│   │       └── Home.xcstrings
│   ├── Settings/
│   └── [Feature]/
├── Library/
│   ├── Routes/
│   ├── Extensions/
│   ├── Views/
│   ├── Models/
│   ├── Services/
│   ├── Database/
│   ├── Localization/
│   ├── Resources/
│   └── Core/
└── Resources/
    ├── AppAssets.xcassets
    └── App.xcstrings
```

## Structure Rules

- Prefer `Features/` for user-facing product areas that evolve independently.
- Keep `Library/` or an equivalent shared layer small and intentional; it should hold code used across multiple features, not code that simply has no owner.
- Keep `Resources/` separate from executable code so asset, localization, and generated resource management stay predictable.
- Prefer `.xcstrings` for localization catalogs rather than older loose string files in new Apple app projects.
- Keep each feature or module resource set in its own bundle when modularity matters; do not push every asset into the main bundle by default.
- If a screen is SwiftUI-first but depends on one UIKit bridge, keep the UIKit host or adapter close to that feature rather than burying it deep in generic shared folders.

## Feature-First vs Layer-First

Choose feature-first when:
- the app has more than a couple of user-facing flows
- multiple developers work on different product areas
- state, views, services, and models change together within a feature

Keep global layer-first folders only for code that is truly shared:
- route infrastructure
- design-system views
- cross-feature services
- persistence utilities
- low-level helpers
- localization helpers used across many modules
- shared resource-loading utilities for non-main bundles

## SwiftUI and UIKit Coexistence

- Default to SwiftUI for new app surfaces.
- Keep UIKit in explicit legacy, hosting, bridge, or integration boundaries.
- Do not mix SwiftUI views and UIKit controllers in the same feature folder without making the ownership relationship obvious.

Good examples:
- `Features/Profile/ProfileView.swift`
- `Features/Profile/ProfileViewModel.swift`
- `Features/Profile/ProfileHostingController.swift`

Avoid:
- placing unrelated UIKit adapters in a generic catch-all `Controllers/` folder
- moving all SwiftUI code into one app-wide `Views/` folder once the app grows
- flattening all feature assets into one global asset catalog when modules should be independently owned

## File Splitting Rules

- Prefer one primary type or entry point per file.
- Split large SwiftUI views into focused files such as `HomeView+hero.swift` or `HomeView+list.swift` when sections are substantial.
- Split by responsibility, not by arbitrary line count.
- If a file mixes view layout, networking, persistence, and navigation policy, the structure is already too broad.

## Review Heuristics

- If a folder name does not tell you which feature owns the code, the structure is probably too generic.
- If shared folders keep growing while features stay thin, the library layer is becoming a dumping ground.
- If UIKit legacy files are scattered across the app shell, add explicit feature or bridge boundaries before adding more code.
- If a module cannot load its own assets or strings without reaching into the main bundle, the resource ownership boundary is too weak.
