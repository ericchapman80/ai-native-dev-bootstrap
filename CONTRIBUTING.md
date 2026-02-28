# Contributing

Thanks for contributing!

## Principles

- Prefer **safe** defaults.
- Every phase should be **documented** and have a clear **verify** step.
- Prefer **idempotent-ish** scripts (re-running should not break things).
- Keep things **modular** (phases/steps can be enabled/disabled).

## How to contribute

1. Fork the repo
2. Create a feature branch
3. Make changes + update docs
4. Run `./bin/bootstrap --dry-run --all` and `./bin/bootstrap 99`
5. Open a PR

## Style

- Shell scripts: `bash`, strict mode (`set -euo pipefail`)
- Use shared helpers from `scripts/_lib.sh`
- Keep scripts readable and well-commented
