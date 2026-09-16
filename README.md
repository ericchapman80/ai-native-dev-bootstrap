# ai-native-dev-bootstrap

[![CI](https://github.com/ericchapman80/ai-native-dev-bootstrap/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/ericchapman80/ai-native-dev-bootstrap/actions/workflows/ci.yml)
![Platform](https://img.shields.io/badge/platform-macOS-blue)
![Shell](https://img.shields.io/badge/shell-bash-black)
[![License](https://img.shields.io/github/license/ericchapman80/ai-native-dev-bootstrap.svg)](https://github.com/ericchapman80/ai-native-dev-bootstrap/blob/main/LICENSE)
[![Sponsor](https://img.shields.io/badge/sponsor-ericchapman80-ef4b8f)](https://github.com/sponsors/ericchapman80)

A phase-based bootstrap for a modern engineering workstation with local AI
tooling. It is designed to be inspectable, rerunnable, conservative by default,
and safe to publish without exposing a real local network.

This public repository carries reusable patterns, examples, and safety checks.
Live machine inventory, internal DNS, private IP assignments, GitOps URLs,
certificates, credentials, and dedicated-agent runbooks belong in a private
site repository. See [Repository Split](docs/repository-split.md).

## Quickstart

```bash
git clone <your-repo-url>
cd ai-native-dev-bootstrap

cp config/config.example.yaml config/config.local.yaml
./bin/bootstrap --config ./config/config.local.yaml --dry-run --all
./bin/bootstrap --config ./config/config.local.yaml --all
```

If you prefer to edit the checked-in default file directly, `config/config.yaml` is the default config path used by `bin/bootstrap`.

## Safety Notes

- Start with `--dry-run`; every phase supports it.
- The bootstrap does not delete user data.
- System-wide preference changes are limited to phase 1 and are explicit in the docs.
- If `yq` is unavailable, the scripts fall back to a built-in parser for the simple YAML used here.
- Homebrew, Colima, pyenv, and Ollama phases only run when their phase toggle is enabled in config.
- Public examples use placeholder domains and documentation IP ranges.
- Run `make privacy` before publishing new docs or templates.

## Phase List

- `0`: preflight checks for macOS, architecture, and Command Line Tools
- `1`: macOS developer defaults such as screenshot location and Finder visibility
- `2`: Homebrew installation and `Brewfile` sync
- `3`: Git, GitHub CLI, VS Code integration, and project directory scaffolding
- `4`: Colima and Docker validation
- `5`: Python via `pyenv` and Poetry configuration
- `6`: Ollama startup and model pulls
- `99`: non-destructive verification

Phase details, verification commands, and rollback notes live in [docs/PHASES.md](docs/PHASES.md).
The [local AI gateway template](docs/local-ai-gateway-template.md) documents a
reusable pattern for putting authentication and TLS in front of a loopback-only
Ollama runtime.

## Examples

```bash
# Preview the entire bootstrap
./bin/bootstrap --dry-run --all

# Run only preflight, Homebrew, and dev tools
./bin/bootstrap 0 2 3

# Use an alternate config file
./bin/bootstrap --config ./config/config.local.yaml 4 5 6

# Verify the current machine state
./bin/bootstrap 99
```

## Verification Commands

```bash
./bin/bootstrap 99
brew bundle check --file ./Brewfile
colima status
docker run --rm hello-world
pyenv versions
poetry --version
ollama list
```

## CI

GitHub Actions runs on `macos-latest` and exercises the bootstrap in safe mode:

```bash
make help
make dry CONFIG=./config/config.ci.yaml
make verify CONFIG=./config/config.ci.yaml
make privacy
```

The badges currently target `ericchapman80/ai-native-dev-bootstrap`. The CI badge tracks the `main` branch. Add a release badge after the first GitHub Release is published.

## Make Targets

```bash
make help
make dry
make all
make verify
make privacy
```

`make all` runs the live bootstrap. Use `make dry` first unless you have already reviewed the phase effects.

## Configuration

The scripts read `config/config.yaml` by default and fall back to `config/config.example.yaml` for unset values. The most relevant knobs are:

- phase toggles: `enable_phase_1_macos_defaults` through `enable_phase_6_ai`
- paths and identity: `projects_dir`, `user_full_name`, `user_email`, `screenshots_dir`
- runtime sizing: `colima_cpu`, `colima_memory_gb`, `colima_disk_gb`
- Python behavior: `pyenv_python_version`, `set_pyenv_global`, `poetry_in_project_venv`
- AI behavior: `auto_start_ollama`, `ollama_models`

## Support

If this project saves you time, support its maintenance via [GitHub Sponsors for `ericchapman80`](https://github.com/sponsors/ericchapman80).

## License

MIT.
