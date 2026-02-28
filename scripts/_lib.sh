#!/usr/bin/env bash
set -euo pipefail

LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${LIB_DIR}/.." && pwd)"
DEFAULT_CONFIG_FILE="${BOOTSTRAP_DEFAULT_CONFIG:-$ROOT_DIR/config/config.example.yaml}"
BOOTSTRAP_CONFIG="${BOOTSTRAP_CONFIG:-$ROOT_DIR/config/config.yaml}"
BOOTSTRAP_DRY_RUN="${BOOTSTRAP_DRY_RUN:-false}"

log()  { echo "[$(date +'%H:%M:%S')] $*"; }
warn() { echo "[$(date +'%H:%M:%S')] WARN: $*" >&2; }
die()  { echo "[$(date +'%H:%M:%S')] ERROR: $*" >&2; exit 1; }

is_true() {
  case "${1:-false}" in
    true|TRUE|yes|YES|1|on|ON) return 0 ;;
    *) return 1 ;;
  esac
}

shell_join() {
  local out=()
  local arg
  for arg in "$@"; do
    out+=("$(printf '%q' "$arg")")
  done
  printf '%s' "${out[*]}"
}

run_cmd() {
  local rendered
  rendered="$(shell_join "$@")"
  if [[ "${BOOTSTRAP_DRY_RUN}" == "true" ]]; then
    log "[dry-run] ${rendered}"
  else
    log "${rendered}"
    "$@"
  fi
}

run_shell() {
  local cmd="$1"
  if [[ "${BOOTSTRAP_DRY_RUN}" == "true" ]]; then
    log "[dry-run] ${cmd}"
  else
    log "${cmd}"
    bash -lc "${cmd}"
  fi
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Missing required command: $1"
}

expand_config_value() {
  local value="${1:-}"
  value="${value/#\~/$HOME}"
  value="${value//\$\{HOME\}/$HOME}"
  value="${value//\$HOME/$HOME}"
  printf '%s\n' "$value"
}

yaml_scalar_from_file() {
  local file="$1"
  local key="$2"
  local value=""

  [[ -f "$file" ]] || return 1

  if command -v yq >/dev/null 2>&1; then
    yq -r ".${key} // \"\"" "$file" 2>/dev/null
    return 0
  fi

  value="$(sed -n -E "s/^[[:space:]]*${key}:[[:space:]]*//p" "$file" | head -n 1)"
  value="${value#\"}"
  value="${value%\"}"
  value="${value#\'}"
  value="${value%\'}"
  printf '%s\n' "$value"
}

yaml_get() {
  local key="$1"
  local default="${2:-}"
  local value=""

  if [[ -n "${BOOTSTRAP_CONFIG}" && -f "${BOOTSTRAP_CONFIG}" ]]; then
    value="$(yaml_scalar_from_file "${BOOTSTRAP_CONFIG}" "${key}")"
  fi

  if [[ -z "$value" && -f "${DEFAULT_CONFIG_FILE}" ]]; then
    value="$(yaml_scalar_from_file "${DEFAULT_CONFIG_FILE}" "${key}")"
  fi

  expand_config_value "${value:-$default}"
}

yaml_list_from_file() {
  local file="$1"
  local key="$2"

  [[ -f "$file" ]] || return 1

  if command -v yq >/dev/null 2>&1; then
    yq -r ".${key}[]?" "$file" 2>/dev/null
    return 0
  fi

  awk -v key="$key" '
    $0 ~ "^[[:space:]]*" key ":[[:space:]]*$" { in_list=1; next }
    in_list && $0 ~ "^[[:space:]]*-[[:space:]]*" {
      sub("^[[:space:]]*-[[:space:]]*", "", $0)
      gsub(/^[\"\047]|[\"\047]$/, "", $0)
      print
      next
    }
    in_list && $0 !~ "^[[:space:]]+" { exit }
  ' "$file"
}

yaml_get_list() {
  local key="$1"
  local values=""

  if [[ -n "${BOOTSTRAP_CONFIG}" && -f "${BOOTSTRAP_CONFIG}" ]]; then
    values="$(yaml_list_from_file "${BOOTSTRAP_CONFIG}" "${key}")"
  fi

  if [[ -z "$values" && -f "${DEFAULT_CONFIG_FILE}" ]]; then
    values="$(yaml_list_from_file "${DEFAULT_CONFIG_FILE}" "${key}")"
  fi

  if [[ -n "$values" ]]; then
    printf '%s\n' "$values"
  fi
}

append_line_if_missing() {
  local file="$1"
  local line="$2"
  mkdir -p "$(dirname "$file")"
  touch "$file"

  if grep -Fqx "$line" "$file"; then
    log "Already present in ${file}: ${line}"
    return 0
  fi

  if [[ "${BOOTSTRAP_DRY_RUN}" == "true" ]]; then
    log "[dry-run] append to ${file}: ${line}"
  else
    log "append to ${file}: ${line}"
    printf '%s\n' "$line" >> "$file"
  fi
}
