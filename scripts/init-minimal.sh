#!/usr/bin/env bash
# Minimal set for consensus / spec-lock work (no node, protocol, or sdk).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

ROOT="$(blvm_workspace_root)"
cd "$ROOT"

MINIMAL=(
  blvm-spec
  blvm-primitives
  blvm-secp256k1
  blvm-muhash
  blvm-spec-lock
  blvm-consensus
)

blvm_git_submodule_update "$ROOT" "${MINIMAL[@]}"

cat <<'EOF'

Minimal submodules ready (consensus + spec-lock stack).

  cd blvm-consensus && cargo test
  cd blvm-consensus && ./scripts/spec-lock-verify.sh   # when present

Add blvm-protocol / blvm-node via ./scripts/init-core.sh when you need the full stack.
EOF
