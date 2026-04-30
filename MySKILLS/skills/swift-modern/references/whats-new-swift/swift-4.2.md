# Swift 4.2

## Major Changes
Swift 4.2 was a cleanup release that modernized standard library naming and API shape before the Swift 5 ABI-stable era. It also introduced the modern random APIs such as `random(in:)`, improved diagnostics around collection usage, and added dynamic member lookup as an early building block for more expressive wrapper types and interoperability-heavy code.

## Why It Matters
This is the practical migration baseline for older codebases. If a codebase still uses pre-4.2 naming, ad hoc randomization, or heavily legacy collection code, modernizing here reduces noise before tackling Swift 5 or concurrency-era changes.

## Migration Notes
Apply renames and standard library fix-its first. Replace older random helpers with the standard random APIs, and treat dynamic member lookup as a specialized tool for wrappers rather than a default modeling pattern.

## Compatibility Risks
Most risk comes from source breakage due to renamed APIs and cleanup-driven compiler fixes. Code that depended on old spellings or loosely typed helper extensions may compile differently or reveal hidden assumptions after migration.
