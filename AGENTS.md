# Repository AGENTS

## 1. Scope

This file defines repository-local operating rules.

Reusable Apple and iOS engineering guidance lives in `skills/` and should not be duplicated here unless the rule is genuinely repository-specific.

## 2. Repository Workflow

- Prefer checking the existing repository structure and active patterns before editing.
- For UI-related work, provide a concrete plan first. Use ASCII sketches when a layout or flow benefits from visual structure.
- Use `Git worktree` when isolation is helpful for multi-step feature work.
- Use commit messages in the format `<type>(<scope>): <subject>`.
- Before handing off significant changes, summarize what changed, how it was verified, and any remaining risk.

## 3. Project-Specific Constraints

- Prefer existing project patterns over introducing a new local convention in one file.
- Keep build, resource, and module ownership explicit; do not assume everything belongs in a global bucket by default.
- Network-facing code must surface failure paths explicitly rather than silently ignoring errors.
- New business logic should include unit-test coverage when the repository has an established place for that coverage.
- Critical user flows should keep or gain UI-test coverage when the repository already exercises that path.
- If the task depends on product design, prefer the existing Figma or design-source direction and do not hardcode ad hoc visual values when a design token or existing asset should be used.

## 4. Security And Safety

- Do not hardcode secrets, passwords, tokens, or private service endpoints.
- When a feature touches camera, microphone, photo library, location, or similar sensitive capabilities, verify the required privacy descriptions exist.
- Before adding a new third-party dependency, verify that its license is acceptable for the project.
- Avoid destructive repository actions unless they are explicitly requested.

## 5. Skill Routing

- Use `ios-app-development` as the default entry skill for broad Apple and iOS development work.
- Let `ios-app-development` route into the narrower specialist skills:
  - `swift-modern`
  - `objective-c-patterns`
  - `uikit-modern`
  - `project-structure-architecture`
- Use a specialist skill directly only when the task is already clearly scoped to that domain.
- Keep reusable language, UIKit, Objective-C, architecture, package-management, and library-selection guidance inside the skill system rather than re-expanding this file.
