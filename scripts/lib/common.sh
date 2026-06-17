# Shared helpers for blvm-workspace scripts.
# shellcheck shell=bash

blvm_workspace_root() {
  local lib_dir root
  lib_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  root="$(cd "$lib_dir/../.." && pwd)"
  if [[ ! -f "$root/Cargo.toml" ]] || ! grep -q '^\[workspace\]' "$root/Cargo.toml" 2>/dev/null; then
    echo "blvm-workspace root not found (expected Cargo.toml with [workspace])" >&2
    return 1
  fi
  printf '%s\n' "$root"
}

# All submodule paths declared in .gitmodules (sorted).
blvm_submodule_paths() {
  local root="$1"
  awk '
    /^[[:space:]]*path = / {
      sub(/^[[:space:]]*path = /, "")
      gsub(/"/, "")
      print
    }
  ' "$root/.gitmodules" | sort -u
}

blvm_submodule_initialized() {
  local root="$1" name="$2"
  [[ -f "$root/$name/Cargo.toml" ]] || [[ -f "$root/$name/.git" ]] || [[ -d "$root/.git/modules/$name" ]]
}

blvm_rust_crates() {
  local root="$1"
  local path name
  while IFS= read -r path; do
    [[ -n "$path" ]] || continue
    if [[ -f "$root/$path/Cargo.toml" ]] && grep -q '^\[package\]' "$root/$path/Cargo.toml" 2>/dev/null; then
      name="$(grep -m1 '^name = ' "$root/$path/Cargo.toml" | sed 's/name = "\(.*\)"/\1/')"
      printf '%s\t%s\n' "$path" "$name"
    fi
  done < <(blvm_submodule_paths "$root")
}

blvm_git_submodule_update() {
  local root="$1"
  shift
  cd "$root"
  if [[ $# -eq 0 ]]; then
    echo "No submodules specified." >&2
    return 1
  fi
  git submodule update --init --progress "$@"
}
