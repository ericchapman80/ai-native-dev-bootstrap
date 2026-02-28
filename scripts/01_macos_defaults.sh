#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

enabled="$(yaml_get enable_phase_1_macos_defaults true)"
is_true "$enabled" || { log "Phase 1 disabled by config."; exit 0; }

log "Phase 1: macOS defaults"

screens_dir="$(yaml_get screenshots_dir "$HOME/Screenshots")"
run_cmd mkdir -p "$screens_dir"

run_cmd defaults write com.apple.screencapture location "$screens_dir"
run_shell 'killall SystemUIServer >/dev/null 2>&1 || true'

run_cmd defaults write NSGlobalDomain AppleShowAllExtensions -bool true
run_cmd defaults write com.apple.finder _FXSortFoldersFirst -bool true
run_cmd defaults write com.apple.finder AppleShowAllFiles -bool true
run_shell 'killall Finder >/dev/null 2>&1 || true'

log "Phase 1 complete."
