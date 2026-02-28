#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

enabled="$(yaml_get enable_phase_2_homebrew true)"
is_true "$enabled" || { log "Phase 2 disabled by config."; exit 0; }

log "Phase 2: Homebrew"

if ! command -v brew >/dev/null 2>&1; then
  local_brew_bin=""
  log "Homebrew not found. Installing..."
  run_shell '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'

  if [[ -x /opt/homebrew/bin/brew ]]; then
    local_brew_bin="/opt/homebrew/bin/brew"
  elif [[ -x /usr/local/bin/brew ]]; then
    local_brew_bin="/usr/local/bin/brew"
  fi

  [[ -n "$local_brew_bin" ]] || die "Homebrew install completed, but brew was not found in a standard location."
  append_line_if_missing "$HOME/.zprofile" "eval \"\$(${local_brew_bin} shellenv)\""

  if [[ "${BOOTSTRAP_DRY_RUN}" != "true" ]]; then
    eval "$(${local_brew_bin} shellenv)"
  fi
else
  log "Homebrew already installed: $(brew --version | head -n 1)"
fi

need_cmd brew

BREWFILE_PATH="$(cd "$(dirname "$0")/.." && pwd)/Brewfile"
run_cmd brew update

if brew bundle check --file "$BREWFILE_PATH" >/dev/null 2>&1; then
  log "Brew bundle already satisfied."
else
  run_cmd brew bundle --file "$BREWFILE_PATH"
fi

log "Phase 2 complete."
