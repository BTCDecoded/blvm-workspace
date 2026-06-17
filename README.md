# blvm-workspace

Development checkout for **cross-crate BLVM work** — git submodules + a Cargo workspace so initialized repos wire together locally; everything else comes from crates.io.

Individual crates stay separate [BTCDecoded](https://github.com/BTCDecoded) repositories (published, reviewed, and CI’d independently). Use this repo when you touch more than one crate. For a single-crate PR, clone that repository alone.

## Quick start

```bash
git clone https://github.com/BTCDecoded/blvm-workspace.git
cd blvm-workspace

make doctor            # toolchain + layout checks
make init-core         # node spine (see init options below)
make status            # what's local vs registry

cd blvm-node && cargo check    # recommended entry point
```

**Partial checkout works:** init only the submodules you need; run `make status` to see local vs crates.io. Build from the crate directory (`cd blvm-node && cargo check`), not necessarily from the workspace root.

## Commands

| Command | Purpose |
|---------|---------|
| `make help` | List all make targets |
| `make doctor` | Preflight (git, rust, cargo, submodule probe) |
| `make status` | Submodule + workspace member summary |
| `make init-minimal` | Consensus + spec-lock stack only |
| `make init-core` | Full node spine (+ `blvm` CLI submodule) |
| `make init-all` | Every submodule in `.gitmodules` |
| `make link` | Symlink existing `../blvm-*` trees (flat checkout migration) |
| `make check-node` | `cargo check` in `blvm-node` |
| `./scripts/cargo-in.sh <crate> <cmd…>` | Run any cargo command in a submodule |

See [CONTRIBUTING.md](CONTRIBUTING.md) and [SUBMODULES.md](SUBMODULES.md) for full detail.

## Layout

```
blvm-workspace/          ← clone this repo
  Cargo.toml             ← workspace root
  .cargo/config.toml     ← SPEC_LOCK_SPEC_PATH (committed)
  blvm-node/             ← git submodule (when initialized)
  blvm-consensus/
  ...
```

Uninitialized submodules **leave no directory** — they are not workspace members, and dependents use **crates.io** version pins.

## Dependency resolution

| Submodule initialized? | Workspace member? | Dep on that crate |
|------------------------|-------------------|-------------------|
| Yes (Rust crate) | Yes | **Local** path via workspace |
| No | No | **crates.io** |
| `blvm` CLI | No (explicit) | Build inside `blvm/` |
| `blvm-spec` | No (not a crate) | Orange Paper files only |

Inside this workspace, **`[patch.crates-io]` in member `Cargo.toml` files is ignored** — Cargo uses workspace member resolution instead. That is what makes partial submodule init work here (unlike cloning a single repo that still has committed patch blocks).

**Exception:** `[patch.crates-io]` at the **workspace root** (`Cargo.toml` here) still applies — currently `quinn-proto` and `time` security pins from `blvm-node`.

## Building

### Recommended

```bash
cd blvm-consensus && cargo test
cd blvm-node && cargo check
./scripts/cargo-in.sh blvm-protocol clippy -- -D warnings
```

Uses workspace `target/`, local members, and root `.cargo/config.toml`.

### Workspace root `cargo -p …`

Possible, but with many members initialized Cargo **unifies features across the whole workspace**, which can conflict (for example `blvm-protocol` between `blvm-node` and other members). Prefer building from the member directory.

### `blvm` CLI

Submodule **`blvm`** is **not** a workspace member (different `blvm-protocol` feature set than `blvm-node`). After init:

```bash
cd blvm && cargo build
```

## Spec-lock / Orange Paper

```bash
git submodule update --init blvm-spec
cd blvm-consensus && ./scripts/spec-lock-verify.sh   # when present in that repo
```

`SPEC_LOCK_SPEC_PATH` is set in `.cargo/config.toml` relative to this repo root.

## Migrating from a flat sibling checkout

```bash
git clone https://github.com/BTCDecoded/blvm-workspace.git new-workspace
cd new-workspace
./scripts/link-existing.sh /path/to/old/parent
make status
```

Symlinks are a local migration aid; use `git submodule update --init` for a clean submodule layout before publishing workspace SHA bumps.

## Toolchain

`rust-toolchain.toml` pins **1.88.0**. Effective MSRV is the **maximum** `rust-version` among crates you build.

## Node modules

Node modules (`blvm-lightning`, `blvm-stratum-v2`, `blvm-mesh`, etc.) are developed and deployed independently. They are **not** submodules here — clone them from their own repos when needed.

## Single-repo contributors

You do **not** need this repository. Clone e.g. [blvm-consensus](https://github.com/BTCDecoded/blvm-consensus) and follow its `CONTRIBUTING.md`.

## Related docs

- [CONTRIBUTING.md](CONTRIBUTING.md) — workflows, partial init, spec-lock
- [SUBMODULES.md](SUBMODULES.md) — full submodule catalog
- [Repository layout (blvm-docs)](https://github.com/BTCDecoded/blvm-docs/blob/main/src/development/repository-architecture.md)

## License

MIT — see [LICENSE](LICENSE).
