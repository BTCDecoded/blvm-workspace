#!/usr/bin/env bash
# Show which submodules are initialized and which become workspace members.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

ROOT="$(blvm_workspace_root)"
cd "$ROOT"

initialized=0
total=0

printf 'blvm-workspace: %s\n\n' "$ROOT"
printf '%-24s %-12s %s\n' "SUBMODULE" "STATE" "NOTES"
printf '%-24s %-12s %s\n' "---------" "-----" "-----"

while IFS= read -r path; do
  [[ -n "$path" ]] || continue
  total=$((total + 1))
  state="missing"
  notes="deps → crates.io"

  if blvm_submodule_initialized "$ROOT" "$path"; then
    initialized=$((initialized + 1))
    state="local"
    if [[ "$path" == "blvm" ]]; then
      notes="CLI; build inside blvm/ (not a workspace member)"
    elif [[ "$path" == "blvm-spec" ]]; then
      notes="Orange Paper; SPEC_LOCK_SPEC_PATH (not a Rust crate)"
    elif [[ -f "$ROOT/$path/Cargo.toml" ]] && grep -q '^\[package\]' "$ROOT/$path/Cargo.toml" 2>/dev/null; then
      notes="workspace member → local path deps"
    else
      notes="initialized"
    fi
  fi

  printf '%-24s %-12s %s\n' "$path" "$state" "$notes"
done < <(blvm_submodule_paths "$ROOT")

printf '\n%d / %d submodules initialized.\n' "$initialized" "$total"

if [[ -f "$ROOT/blvm-spec/PROTOCOL.md" ]]; then
  printf 'SPEC_LOCK_SPEC_PATH: set (blvm-spec present)\n'
else
  printf 'SPEC_LOCK_SPEC_PATH: inactive until blvm-spec is initialized\n'
fi

printf '\nTip: cd <crate> && cargo check  —  build from the crate you are changing.\n'
