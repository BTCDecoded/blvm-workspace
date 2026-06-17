#!/usr/bin/env bash
# Preflight checks for toolchain, submodules, and a quick cargo metadata probe.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

ROOT="$(blvm_workspace_root)"
cd "$ROOT"

ok=0
warn=0

pass() { printf '  ok  %s\n' "$1"; ok=$((ok + 1)); }
fail() { printf '  FAIL  %s\n' "$1" >&2; exit 1; }
note() { printf '  note  %s\n' "$1"; warn=$((warn + 1)); }

printf 'blvm-workspace doctor\n\n'

command -v git >/dev/null && pass "git $(git --version | awk '{print $3}')" || fail "git not found"
command -v cargo >/dev/null && pass "cargo $(cargo --version | awk '{print $2}')" || fail "cargo not found"
command -v rustc >/dev/null && pass "rustc $(rustc --version | awk '{print $2}')" || fail "rustc not found"

[[ -f "$ROOT/rust-toolchain.toml" ]] && pass "rust-toolchain.toml present" || note "no rust-toolchain.toml"

if [[ -f "$ROOT/.gitmodules" ]]; then
  pass ".gitmodules present"
else
  fail ".gitmodules missing"
fi

if blvm_submodule_initialized "$ROOT" blvm-consensus; then
  pass "blvm-consensus initialized"
else
  note "blvm-consensus not initialized (run ./scripts/init-core.sh or init-minimal.sh)"
fi

if blvm_submodule_initialized "$ROOT" blvm-node; then
  pass "blvm-node initialized"
else
  note "blvm-node not initialized"
fi

if blvm_submodule_initialized "$ROOT" blvm-spec; then
  pass "blvm-spec initialized (spec-lock verify ready)"
else
  note "blvm-spec not initialized (needed for cargo-spec-lock / SPEC_LOCK_SPEC_PATH)"
fi

printf '\nCargo workspace probe'
if blvm_submodule_initialized "$ROOT" blvm-consensus; then
  if ( cd "$ROOT/blvm-consensus" && cargo metadata --format-version=1 --no-deps >/dev/null 2>&1 ); then
    pass "cargo metadata from blvm-consensus"
  else
    note "cargo metadata failed from blvm-consensus (run cd blvm-consensus && cargo metadata for details)"
  fi
else
  note "skipped cargo metadata (no initialized Rust submodule)"
fi

printf '\nSummary: %d checks passed' "$ok"
[[ "$warn" -gt 0 ]] && printf ', %d notes' "$warn"
printf '.\n'
