#!/usr/bin/env bash
# Initialize every submodule tracked in .gitmodules.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

ROOT="$(blvm_workspace_root)"
cd "$ROOT"

git submodule update --init --progress

echo "All submodules initialized. Run ./scripts/status.sh for a summary."
