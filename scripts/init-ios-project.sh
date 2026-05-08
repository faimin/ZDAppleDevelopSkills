#!/usr/bin/env bash
# init-ios-project.sh
# Add iOS agent skill routing to any iOS project directory.
# Usage: ./init-ios-project.sh [path/to/ios/project]

set -euo pipefail

SKILLS_REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TEMPLATE="$SKILLS_REPO_DIR/templates/ios-project/AGENTS.md"
TARGET_DIR="${1:-$(pwd)}"
TARGET_FILE="$TARGET_DIR/AGENTS.md"

# Verify the target looks like an iOS project
is_ios_project() {
    local dir="$1"
    [[ -n "$(find "$dir" -maxdepth 2 \( \
        -name "*.xcodeproj" -o \
        -name "*.xcworkspace" -o \
        -name "Podfile" -o \
        -name "Package.swift" \
    \) 2>/dev/null | head -1)" ]]
}

if ! is_ios_project "$TARGET_DIR"; then
    echo "Warning: No .xcodeproj / .xcworkspace / Podfile / Package.swift found in $TARGET_DIR"
    read -rp "Continue anyway? [y/N] " confirm
    [[ "$confirm" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 1; }
fi

if [[ -f "$TARGET_FILE" ]]; then
    echo "AGENTS.md already exists at $TARGET_FILE"
    read -rp "Overwrite? [y/N] " confirm
    [[ "$confirm" =~ ^[Yy]$ ]] || { echo "Skipped."; exit 0; }
fi

cp "$TEMPLATE" "$TARGET_FILE"
echo "✓ Created $TARGET_FILE"
echo ""
echo "All agents (Claude, Codex, Gemini, etc.) will now load iOS skills"
echo "automatically when working in this project."
