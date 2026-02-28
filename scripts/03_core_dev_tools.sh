#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

enabled="$(yaml_get enable_phase_3_dev_tools true)"
is_true "$enabled" || { log "Phase 3 disabled by config."; exit 0; }

log "Phase 3: Core dev tools"

need_cmd git

name="$(yaml_get user_full_name "")"
email="$(yaml_get user_email "")"
[[ -n "$name" ]] && run_cmd git config --global user.name "$name"
[[ -n "$email" ]] && run_cmd git config --global user.email "$email"
run_cmd git config --global init.defaultBranch main

if command -v gh >/dev/null 2>&1; then
  log "gh present."
else
  warn "gh not found. Install via Brewfile (brew install gh)."
fi

install_vscode="$(yaml_get install_vscode true)"
install_extensions="$(yaml_get install_vscode_extensions true)"

if is_true "$install_vscode"; then
  if command -v code >/dev/null 2>&1; then
    log "VS Code CLI (code) is available."
  else
    warn "VS Code CLI 'code' not found. In VS Code: Command Palette -> install the 'code' command in PATH."
  fi
fi

if is_true "$install_extensions" && command -v code >/dev/null 2>&1; then
  EXT_FILE="$(cd "$(dirname "$0")/.." && pwd)/vscode/extensions.txt"
  if [[ -f "$EXT_FILE" ]]; then
    while IFS= read -r extension; do
      [[ -z "$extension" || "$extension" == \#* ]] && continue
      if code --list-extensions 2>/dev/null | grep -Fqx "$extension"; then
        log "VS Code extension already installed: $extension"
      else
        run_cmd code --install-extension "$extension"
      fi
    done < "$EXT_FILE"
  else
    warn "No extensions.txt found."
  fi
fi

projects_dir="$(yaml_get projects_dir "$HOME/projects")"
for subdir in work personal sandbox; do
  run_cmd mkdir -p "$projects_dir/$subdir"
done

log "Phase 3 complete."
