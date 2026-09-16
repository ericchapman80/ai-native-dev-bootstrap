#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

patterns=(
  'chapmanet\.home\.arpa'
  'CHAPMAN-TUF'
  'chapman-htpc'
  'C:\\Users\\ericc'
  '/home/ericc'
  'ssh://chapman@'
  '192\.168\.1\.'
)

failed=0
for pattern in "${patterns[@]}"; do
  if command -v rg >/dev/null 2>&1; then
    if rg -n --hidden \
      --glob '!/.git/**' \
      --glob '!tests/public-privacy.sh' \
      --glob '!docs/repository-split.md' \
      "$pattern" "$ROOT"; then
      failed=1
    fi
  else
    if grep -RInE --exclude-dir=.git --exclude=public-privacy.sh "$pattern" "$ROOT"; then
      failed=1
    fi
  fi
done

if [[ "$failed" -ne 0 ]]; then
  echo 'Public privacy scan failed: private platform identifiers are present.' >&2
  exit 1
fi

echo 'PASS public privacy scan'
