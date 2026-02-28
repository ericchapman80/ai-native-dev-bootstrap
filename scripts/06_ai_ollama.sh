#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

enabled="$(yaml_get enable_phase_6_ai true)"
is_true "$enabled" || { log "Phase 6 disabled by config."; exit 0; }

log "Phase 6: AI (Ollama)"

need_cmd ollama

auto_start_ollama="$(yaml_get auto_start_ollama true)"
if [[ "${BOOTSTRAP_DRY_RUN}" != "true" ]] && is_true "$auto_start_ollama"; then
  if pgrep -x ollama >/dev/null 2>&1; then
    log "Ollama is already running."
  else
    log "Starting ollama serve in background..."
    nohup ollama serve >/tmp/ollama.log 2>&1 &
    sleep 1
  fi
fi

models=()
while IFS= read -r model; do
  [[ -n "$model" ]] && models+=("$model")
done <<EOF_MODELS
$(yaml_get_list ollama_models)
EOF_MODELS

if [[ ${#models[@]} -eq 0 ]]; then
  models=("llama3:8b" "nomic-embed-text")
fi

for model in "${models[@]}"; do
  run_cmd ollama pull "$model"
done

log "Installed models:"
run_cmd ollama list

log "Phase 6 complete."
log "Tip: Stop Ollama when not using it: pkill ollama"
