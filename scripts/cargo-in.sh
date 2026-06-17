#!/usr/bin/env bash
# Run cargo inside a submodule directory (recommended build entry point).
#
# Usage:
#   ./scripts/cargo-in.sh blvm-node check
#   ./scripts/cargo-in.sh blvm-consensus test -- --nocapture
#   ./scripts/cargo-in.sh blvm-node clippy -- -D warnings
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

if [[ $# -lt 2 ]]; then
  cat <<'EOF' >&2
Usage: cargo-in.sh <submodule-path> <cargo-args...>

Examples:
  ./scripts/cargo-in.sh blvm-node check
  ./scripts/cargo-in.sh blvm-consensus test
  ./scripts/cargo-in.sh blvm clippy -- -D warnings
EOF
  exit 2
fi

ROOT="$(blvm_workspace_root)"
crate="$1"
shift

dir="$ROOT/$crate"
if [[ ! -f "$dir/Cargo.toml" ]]; then
  echo "No Cargo.toml at $dir — initialize the submodule or run ./scripts/link-existing.sh" >&2
  exit 1
fi

cd "$dir"
exec cargo "$@"
