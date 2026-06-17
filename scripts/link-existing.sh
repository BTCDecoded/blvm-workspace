#!/usr/bin/env bash
# Symlink existing sibling checkouts into this workspace (flat monorepo migration).
#
# Usage:
#   ./scripts/link-existing.sh              # search .. for blvm-* / blvm
#   ./scripts/link-existing.sh /path/to/dir # search custom parent directory
#
# Creates symlinks only for paths that are not already initialized submodules.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

ROOT="$(blvm_workspace_root)"
SEARCH="${1:-$ROOT/..}"

if [[ ! -d "$SEARCH" ]]; then
  echo "Search directory not found: $SEARCH" >&2
  exit 1
fi

linked=0
skipped=0

while IFS= read -r path; do
  [[ -n "$path" ]] || continue
  dest="$ROOT/$path"

  if [[ -e "$dest" ]]; then
    skipped=$((skipped + 1))
    continue
  fi

  candidate="$SEARCH/$path"
  if [[ ! -d "$candidate" ]]; then
    continue
  fi

  if [[ "$path" != "blvm-spec" ]] && [[ ! -f "$candidate/Cargo.toml" ]] && [[ ! -f "$candidate/.git" ]]; then
    continue
  fi

  ln -s "$(cd "$candidate" && pwd)" "$dest"
  printf 'linked %s -> %s\n' "$path" "$candidate"
  linked=$((linked + 1))
done < <(blvm_submodule_paths "$ROOT")

printf '\n%d symlink(s) created, %d path(s) already present.\n' "$linked" "$skipped"
printf 'Run ./scripts/status.sh to review.\n'
printf 'Note: symlinks are not tracked by git. Use git submodule update --init for proper submodule state.\n'
