# Architecture Selection

Use this reference when choosing how much architectural structure an Apple app or feature actually needs.

## Core Principle

Choose the smallest architecture that keeps state ownership, effects, and navigation understandable. Do not pay TCA or Redux complexity for screens that only need straightforward local state.

## MVVM

Prefer MVVM when:
- a feature has one or a few screens
- state is mostly local to the feature
- async work is present but manageable
- the team wants a familiar default with clear test seams

Strengths:
- easy to teach
- works well with SwiftUI and UIKit
- scales well for many app features before heavier coordination is necessary

Risks:
- view models can become dumping grounds if state, navigation, and service orchestration are not split carefully

## MVI

Prefer MVI when:
- a feature benefits from explicit event -> state transitions
- state derivation should be easy to trace
- the team wants stricter unidirectional flow without necessarily committing to a whole-app store

Strengths:
- clearer transition logic
- easier to reason about complex form or wizard behavior

Risks:
- can become ceremony-heavy for simple views

## TCA

Prefer TCA when:
- many features share state or effects
- high testability and reducer-driven behavior are core requirements
- the team is comfortable with explicit actions, reducers, effects, and dependency boundaries

Strengths:
- strong consistency for large apps
- explicit state and side-effect modeling
- high leverage for complex product flows

Risks:
- heavier learning curve
- too much ceremony for small apps or isolated screens

## Redux-Style Patterns

Prefer Redux-style architecture when:
- the team already works well with centralized action and state patterns
- cross-feature coordination is important
- store-driven flows are part of the product's complexity

Strengths:
- predictable unidirectional flow
- useful for app-wide orchestration

Risks:
- centralized state can become bloated
- overuse leads to indirection without enough payoff

## Practical Defaults

- Small app or simple feature: start with MVVM.
- Medium-complexity flow with explicit state transitions: consider MVI.
- Large app with shared state, effects, and testing pressure: consider TCA.
- Existing store-centric team or product: Redux-style patterns can be justified.

## Avoid Over-Architecture

Warning signs:
- adding reducers, actions, and effect plumbing for a static screen
- introducing a global store before feature boundaries are understood
- choosing a pattern because it is fashionable rather than because ownership is difficult

If a feature only needs:
- a view
- a small amount of local state
- one service call
- straightforward navigation

then MVVM is usually enough.
