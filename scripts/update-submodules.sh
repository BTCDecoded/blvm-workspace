#!/usr/bin/env bash
# Advance submodule pointers to upstream branch tips (review before committing).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

ROOT="$(blvm_workspace_root)"
cd "$ROOT"

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  cat <<'EOF'
Usage: update-submodules.sh [submodule...]

Runs `git submodule update --remote` for initialized submodules.
Without arguments, updates all initialized submodules.

This moves submodule SHAs — commit the result only after reviewing diffs.
EOF
  exit 0
fi

if [[ $# -gt 0 ]]; then
  git submodule update --remote --progress "$@"
else
  git submodule update --remote --progress
fi

echo "Submodule pointers updated. Run git submodule status and review before committing."
