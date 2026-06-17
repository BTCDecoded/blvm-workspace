# Contributing to blvm-workspace

This repository is a **development checkout wrapper**. It does not replace per-crate contribution workflows — code changes still land in the individual BTCDecoded repositories (`blvm-node`, `blvm-consensus`, …).

## When to use this repo

| Goal | Use |
|------|-----|
| Change one crate, open a PR in that repo | Clone **that repo only** — see its `CONTRIBUTING.md` |
| Cross-crate changes (consensus + node + protocol) | Clone **blvm-workspace**, init the submodules you need |
| Full local tree | `./scripts/init-core.sh` or `./scripts/init-all.sh` |
| Work on a node module (lightning, stratum-v2, etc.) | Clone that module repo directly — not part of this workspace |

## First-time setup

```bash
git clone https://github.com/BTCDecoded/blvm-workspace.git
cd blvm-workspace

make doctor          # toolchain + layout preflight
make init-core       # or init-minimal / init-all
make status          # local vs crates.io summary
```

### Migrating an existing flat checkout

If you already have sibling repos under a parent directory:

```bash
git clone https://github.com/BTCDecoded/blvm-workspace.git
cd blvm-workspace
./scripts/link-existing.sh /path/to/parent   # symlinks ../blvm-* into place
make status
```

## Building (important)

**Build from the crate you are changing:**

```bash
cd blvm-node && cargo check
cd blvm-consensus && cargo test
```

Or use wrappers:

```bash
make check-node
./scripts/cargo-in.sh blvm-protocol clippy -- -D warnings
```

### Why not `cargo check -p …` from the workspace root?

With many workspace members initialized, Cargo unifies features across the whole workspace. That can conflict (for example `blvm-protocol` feature sets between crates). Building from the member directory still uses the workspace (shared `target/`, member path deps, root `.cargo/config.toml`) without triggering whole-workspace resolution edge cases.

### Partial submodules (3 of 6 local, 3 from crates.io)

Inside **blvm-workspace**, member `[patch.crates-io]` tables in submodule `Cargo.toml` files are **ignored**. Initialized submodules are workspace members (local); everything else resolves from **crates.io**.

```bash
git submodule update --init blvm-node blvm-consensus blvm-protocol
cd blvm-node && cargo check   # local node/consensus/protocol; registry for the rest
```

Run `make status` to confirm which crates are local.

### `blvm` CLI

The `blvm` binary submodule is **not** a workspace member (feature clash with `blvm-node`). After init:

```bash
cd blvm && cargo build
```

## Spec-lock / Orange Paper

Initialize **`blvm-spec`** for on-disk spec paths:

```bash
git submodule update --init blvm-spec
```

Workspace `.cargo/config.toml` sets `SPEC_LOCK_SPEC_PATH` when the submodule is present. Run verify from the consumer crate, for example:

```bash
cd blvm-consensus && ./scripts/spec-lock-verify.sh
```

## Updating submodule pointers

To advance initialized submodules to upstream `main`:

```bash
./scripts/update-submodules.sh          # all initialized
./scripts/update-submodules.sh blvm-node blvm-consensus
git submodule status
# Review, then commit the SHA bump in blvm-workspace if intentional
```

## Toolchain

`rust-toolchain.toml` pins **1.88.0**. Effective MSRV for a build is the **maximum** `rust-version` among crates you compile.

## What not to commit here

- **`target/`** — workspace build artifacts (gitignored)
- **`Cargo.lock`** — generated per machine/submodule set (gitignored)
- **Symlinks from `link-existing.sh`** — local migration aid only; prefer proper `git submodule update --init` before pushing workspace SHA bumps

## Related documentation

- [README.md](README.md) — overview and quick start
- [SUBMODULES.md](SUBMODULES.md) — full submodule catalog
- [blvm-docs: Repository layout](https://github.com/BTCDecoded/blvm-docs/blob/main/src/development/repository-architecture.md)
