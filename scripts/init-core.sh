#!/usr/bin/env bash
# Initialize the BLVM core spine for cross-crate development.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

ROOT="$(blvm_workspace_root)"
cd "$ROOT"

CORE=(
  blvm-spec
  blvm-primitives
  blvm-secp256k1
  blvm-muhash
  blvm-spec-lock
  blvm-consensus
  blvm-protocol
  blvm-node
  blvm-sdk
  blvm
)

blvm_git_submodule_update "$ROOT" "${CORE[@]}"

cat <<'EOF'

Core submodules ready.

Build from the crate you are changing (recommended):
  cd blvm-node && cargo check
  cd blvm-consensus && cargo test

CLI binary (not a workspace member):
  cd blvm && cargo build

Run ./scripts/status.sh to see which crates are local vs crates.io.
EOF
