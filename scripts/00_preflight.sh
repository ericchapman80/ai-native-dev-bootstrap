#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

log "Phase 0: Preflight"

need_cmd sw_vers
need_cmd uname

log "macOS: $(sw_vers -productVersion) ($(sw_vers -buildVersion))"
log "Arch: $(uname -m)"

if ! xcode-select -p >/dev/null 2>&1; then
  warn "Command Line Tools not found. Run: xcode-select --install"
else
  log "Command Line Tools: $(xcode-select -p)"
fi

log "Preflight complete."
