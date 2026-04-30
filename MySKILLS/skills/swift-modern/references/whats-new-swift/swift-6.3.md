# Swift 6.3

## Major Changes
According to the official Swift 6.3 release announcement, this release expands Swift's boundaries more than it changes everyday surface syntax. Key additions include:

- the `@c` attribute for exposing Swift functions and enums to C, plus `@c @implementation` for implementing C declarations in Swift
- module selectors such as `ModuleA::symbol`, including `Swift::Task` style disambiguation
- new optimization-control attributes such as `@specialize`, guaranteed `@inline(always)` behavior, and `@export(implementation)`
- a Swift Build preview integrated into SwiftPM, plus package-trait and macro-build workflow improvements
- Swift Testing support for warning issues, test cancellation, and image attachments
- DocC experimental capabilities including Markdown output, static HTML content embedding, and richer code-block annotations
- the first official Swift SDK for Android
- a wider set of Embedded Swift improvements, including stronger C interop, debugging, linker-model progress, and diagnostics for unsupported embedded features

## Why It Matters
Swift 6.3 broadens Swift's reach across interoperability, build tooling, and cross-platform work. For app teams, the practical impact is cleaner C boundaries, richer test artifacts, and better documentation output. For library, infrastructure, and tooling authors, 6.3 is more significant: it gives much finer control over interop, optimization, package builds, and embedded deployment.

## Migration Notes
Use `@c` only at explicit C-facing boundaries and keep most implementation surfaces Swift-native. Treat module selectors as a clarity tool when symbol collisions are real, not as a stylistic rewrite. If you evaluate the Swift Build preview, treat it as a tooling experiment rather than a guaranteed drop-in replacement in every production pipeline.

For embedded work specifically:

- use the new embedded diagnostics to catch unsupported language constructs earlier
- evaluate `@section`, `@used`, and `@export(...)` only when you truly need linker or emission control
- treat improved C signature tolerance and LLDB support as enablers for mixed Swift/C firmware projects, not reasons to weaken API discipline

## Compatibility Risks
Interop and optimization attributes can increase surface-area complexity if introduced casually. Swift Build is explicitly a preview in SwiftPM, and DocC enhancements are experimental, so teams should avoid assuming identical behavior across every environment without validation. Embedded Swift features are also specialized; most app teams should treat them as awareness items unless they genuinely ship low-level or firmware-adjacent code.

Sources:
- https://www.swift.org/blog/swift-6.3-released/
- https://juejin.cn/post/7620661836632424483
- https://www.swift.org/blog/embedded-swift-improvements-coming-in-swift-6.3/
Last verified: 2026-04-30
