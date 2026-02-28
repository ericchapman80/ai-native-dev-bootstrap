# Phase Guide

This repository is intentionally phase-based so you can run only what you want, in the order you want.

## Phase 0: Preflight

Purpose: Confirm the machine is macOS, report architecture, and check for Xcode Command Line Tools.

Verify:

```bash
./bin/bootstrap 0
xcode-select -p
sw_vers
uname -m
```

Rollback:

No rollback is required. This phase only reads system state.

## Phase 1: Foundation (macOS defaults)

Purpose: Apply a small set of developer-friendly macOS defaults for screenshots and Finder visibility.

Verify:

```bash
./bin/bootstrap 1
defaults read com.apple.screencapture location
defaults read NSGlobalDomain AppleShowAllExtensions
defaults read com.apple.finder AppleShowAllFiles
defaults read com.apple.finder _FXSortFoldersFirst
```

Rollback:

- Restore the screenshot directory with `defaults write com.apple.screencapture location <old-path>`.
- Disable Finder visibility settings with `defaults write ... -bool false` for the keys above.
- Restart Finder or SystemUIServer after changing values.

## Phase 2: Homebrew + Brewfile

Purpose: Install Homebrew if needed, sync packages from `Brewfile`, and keep shell setup idempotent.

Verify:

```bash
./bin/bootstrap 2
brew --version
brew bundle check --file ./Brewfile
```

Rollback:

- Remove individual packages with `brew uninstall <formula>` or `brew uninstall --cask <cask>`.
- Remove Homebrew entirely only if you intend to reset the machine's package manager state.
- Remove the added `brew shellenv` line from `~/.zprofile` if you no longer want Homebrew on PATH.

## Phase 3: Core Dev Tools

Purpose: Set global Git defaults, confirm GitHub CLI and VS Code availability, install VS Code extensions, and create project directories.

Verify:

```bash
./bin/bootstrap 3
git config --global --get user.name
git config --global --get user.email
gh auth status
code --list-extensions
ls "$HOME/projects"
```

Rollback:

- Unset Git config keys with `git config --global --unset <key>`.
- Remove project directories manually if you created them only for this bootstrap.
- Uninstall VS Code extensions with `code --uninstall-extension <publisher.extension>`.

## Phase 4: Containers

Purpose: Start or reuse a Colima runtime, validate Docker, and check for Compose support.

Verify:

```bash
./bin/bootstrap 4
colima status
docker version
docker run --rm hello-world
docker compose version
```

Rollback:

- Stop Colima with `colima stop`.
- Delete the Colima VM with `colima delete` only if you explicitly want to remove its disk image.
- Uninstall Docker or Compose packages with Homebrew if they are no longer needed.

## Phase 5: Python

Purpose: Install the configured Python version with `pyenv`, optionally switch the global version, and configure Poetry.

Verify:

```bash
./bin/bootstrap 5
pyenv versions
pyenv global
pyenv exec python --version
poetry config --list | grep virtualenvs.in-project
```

Rollback:

- Reset the selected version with `pyenv global system` or another installed version.
- Remove an installed Python with `pyenv uninstall <version>`.
- Reset Poetry config with `poetry config --unset virtualenvs.in-project`.

## Phase 6: AI

Purpose: Ensure Ollama is available, optionally start the background service, and pull the configured model list.

Verify:

```bash
./bin/bootstrap 6
ollama list
pgrep -x ollama || true
```

Rollback:

- Stop the background service with `pkill ollama`.
- Remove models with `ollama rm <model>`.
- Disable auto-start or remove models in config if you do not want local model pulls.

## Phase 99: Verify

Purpose: Run a non-destructive tool presence audit and report whether optional `yq` parsing is available.

Verify:

```bash
./bin/bootstrap 99
make verify
```

Rollback:

No rollback is required. This phase only reports system state.
