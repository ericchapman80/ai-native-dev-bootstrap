#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

enabled="$(yaml_get enable_phase_5_python true)"
is_true "$enabled" || { log "Phase 5 disabled by config."; exit 0; }

log "Phase 5: Python (pyenv + Poetry)"

need_cmd pyenv

pyver="$(yaml_get pyenv_python_version 3.12.12)"
set_pyenv_global="$(yaml_get set_pyenv_global true)"
inproj="$(yaml_get poetry_in_project_venv true)"

run_cmd pyenv install -s "$pyver"
if is_true "$set_pyenv_global"; then
  run_cmd pyenv global "$pyver"
fi
run_cmd pyenv rehash
run_cmd pyenv exec python --version

if command -v poetry >/dev/null 2>&1; then
  log "Poetry present: $(poetry --version)"
  if is_true "$inproj"; then
    run_cmd poetry config virtualenvs.in-project true
  fi
else
  warn "Poetry not found. Add to Brewfile: poetry"
fi

log "Phase 5 complete."
