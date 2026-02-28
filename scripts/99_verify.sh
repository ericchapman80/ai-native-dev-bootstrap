#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

log "Phase 99: Verify"

for cmd in brew git gh code colima docker pyenv python poetry ollama; do
  if command -v "$cmd" >/dev/null 2>&1; then
    log "OK: $cmd -> $(command -v "$cmd")"
  else
    warn "MISSING: $cmd"
  fi
done

if command -v docker-compose >/dev/null 2>&1; then
  log "OK: docker-compose -> $(command -v docker-compose)"
elif docker compose version >/dev/null 2>&1; then
  log "OK: docker compose plugin available"
else
  warn "MISSING: docker-compose or docker compose plugin"
fi

if command -v yq >/dev/null 2>&1; then
  log "INFO: yq available for richer YAML parsing."
else
  log "INFO: yq not installed; using built-in YAML parsing fallback."
fi

if [[ -f "$BOOTSTRAP_CONFIG" ]]; then
  log "Config file present: $BOOTSTRAP_CONFIG"
else
  warn "Config file not found at $BOOTSTRAP_CONFIG; falling back to defaults from $DEFAULT_CONFIG_FILE"
fi

log "Verify complete."
