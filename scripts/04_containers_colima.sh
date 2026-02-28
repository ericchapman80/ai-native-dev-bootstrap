#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

enabled="$(yaml_get enable_phase_4_containers true)"
is_true "$enabled" || { log "Phase 4 disabled by config."; exit 0; }

log "Phase 4: Containers (Colima)"

need_cmd colima
need_cmd docker

cpu="$(yaml_get colima_cpu 6)"
mem="$(yaml_get colima_memory_gb 12)"
disk="$(yaml_get colima_disk_gb 80)"

run_cmd colima start --cpu "$cpu" --memory "$mem" --disk "$disk"

if command -v docker-compose >/dev/null 2>&1; then
  log "docker-compose present: $(docker-compose version | head -n 1)"
elif docker compose version >/dev/null 2>&1; then
  log "docker compose plugin present: $(docker compose version | head -n 1)"
else
  warn "Compose is missing. Add docker-compose or Docker's compose plugin via Homebrew."
fi

run_cmd docker run --rm hello-world

log "Phase 4 complete."
log "Tip: Stop Colima when not using containers: colima stop"
