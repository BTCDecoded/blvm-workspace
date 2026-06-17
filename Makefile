# blvm-workspace Makefile — convenience wrappers around scripts/
# Run `make help` for targets.

SHELL := /bin/bash
.PHONY: help doctor status init-core init-minimal init-all link check-node check-consensus check-protocol test-consensus fmt-node clippy-node clean

help:
	@./scripts/help.sh

doctor:
	@./scripts/doctor.sh

status:
	@./scripts/status.sh

init-core:
	@./scripts/init-core.sh

init-minimal:
	@./scripts/init-minimal.sh

init-all:
	@./scripts/init-all.sh

link:
	@./scripts/link-existing.sh

check-node:
	@./scripts/cargo-in.sh blvm-node check

check-consensus:
	@./scripts/cargo-in.sh blvm-consensus check

check-protocol:
	@./scripts/cargo-in.sh blvm-protocol check

test-consensus:
	@./scripts/cargo-in.sh blvm-consensus test

fmt-node:
	@./scripts/cargo-in.sh blvm-node fmt

clippy-node:
	@./scripts/cargo-in.sh blvm-node clippy -- -D warnings

clean:
	@rm -rf target
