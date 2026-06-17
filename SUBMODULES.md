# Submodule catalog

All paths are relative to the **blvm-workspace** repository root.

## Core stack

| Path | Repository | Role |
|------|------------|------|
| `blvm-primitives` | [blvm-primitives](https://github.com/BTCDecoded/blvm-primitives) | Shared types, config, serialization |
| `blvm-secp256k1` | [blvm-secp256k1](https://github.com/BTCDecoded/blvm-secp256k1) | Pure-Rust secp256k1 backend |
| `blvm-muhash` | [blvm-muhash](https://github.com/BTCDecoded/blvm-muhash) | MuHash accumulator |
| `blvm-consensus` | [blvm-consensus](https://github.com/BTCDecoded/blvm-consensus) | Consensus rules, spec-lock macros |
| `blvm-protocol` | [blvm-protocol](https://github.com/BTCDecoded/blvm-protocol) | Network protocol layer |
| `blvm-node` | [blvm-node](https://github.com/BTCDecoded/blvm-node) | Full node library |
| `blvm-sdk` | [blvm-sdk](https://github.com/BTCDecoded/blvm-sdk) | Module SDK + governance helpers |
| `blvm` | [blvm](https://github.com/BTCDecoded/blvm) | `blvm` CLI binary (**not** a workspace member — build inside `blvm/`) |

## Crypto / standalone

| Path | Repository | Role |
|------|------------|------|
| `blvm-miniscript` | [blvm-miniscript](https://github.com/BTCDecoded/blvm-miniscript) | Miniscript utilities |

## Verification & spec

| Path | Repository | Role |
|------|------------|------|
| `blvm-spec-lock` | [blvm-spec-lock](https://github.com/BTCDecoded/blvm-spec-lock) | `#[spec_locked]` / verify tooling |
| `blvm-spec` | [blvm-spec](https://github.com/BTCDecoded/blvm-spec) | Orange Paper (`PROTOCOL.md`, …) — not a Rust crate; excluded from workspace `members` |

## Dev tools

| Path | Repository | Role |
|------|------------|------|
| `blvm-bench` | [blvm-bench](https://github.com/BTCDecoded/blvm-bench) | Benchmarks and scan tooling |
| `blvm-commons` | [blvm-commons](https://github.com/BTCDecoded/blvm-commons) | Commons / governance app helpers |

## Init scripts

| Script | Submodules |
|--------|------------|
| `./scripts/init-minimal.sh` | spec, primitives, secp256k1, muhash, spec-lock, consensus |
| `./scripts/init-core.sh` | minimal + protocol, node, sdk, blvm CLI |
| `./scripts/init-all.sh` | everything in `.gitmodules` |

## Workspace membership

- **`blvm-*` glob**: any initialized top-level submodule with a `[package]` manifest becomes a workspace member.
- **`blvm` CLI**: submodule only — build with `cd blvm && cargo build`.
- **`blvm-spec`**: excluded (not a Rust crate).
- **Uninitialized submodule**: directory absent → not a member → dependents use **crates.io** version pins.

## Node modules

Node modules (blvm-lightning, blvm-stratum-v2, blvm-mesh, etc.) are developed and deployed independently. They are not submodules here — clone them from their own repositories when working on them.
