#!/usr/bin/env bash
cat <<'EOF'
blvm-workspace targets

  make doctor          Toolchain + submodule preflight
  make status          Which submodules are local vs crates.io
  make init-minimal    Consensus + spec-lock stack only
  make init-core       Full node spine (recommended default)
  make init-all        Every submodule in .gitmodules
  make link            Symlink ../blvm-* into this tree (flat checkout migration)

  make check-node      cargo check in blvm-node
  make check-consensus cargo check in blvm-consensus
  make check-protocol  cargo check in blvm-protocol
  make test-consensus  cargo test in blvm-consensus
  make clippy-node     clippy -D warnings in blvm-node
  make clean           Remove workspace target/

Build from a crate directory (best DX):
  cd blvm-node && cargo check
  ./scripts/cargo-in.sh blvm-consensus test

See README.md and CONTRIBUTING.md for partial submodule workflows.
EOF
