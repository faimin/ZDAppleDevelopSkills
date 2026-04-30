# Swift 5.0

## Major Changes
Swift 5.0 established ABI stability on Apple platforms and introduced `Result` into the standard library. It also delivered string and raw-memory improvements that made lower-level work and Unicode-correct text handling more consistent.

## Why It Matters
Swift 5.0 defines the beginning of the modern Swift runtime era. ABI stability changed how libraries evolve on Apple platforms, and `Result` gave pre-concurrency code a standard way to model fallible asynchronous outcomes.

## Migration Notes
Prefer the standard `Result` type over custom result enums. Review string indexing, UTF handling, and low-level memory code carefully because Swift 5 tightened expectations around correctness even when source edits were small.

## Compatibility Risks
The main risks are behavior assumptions around strings, custom result wrappers that shadow the standard library, and libraries that were designed before ABI stability concerns became important.
