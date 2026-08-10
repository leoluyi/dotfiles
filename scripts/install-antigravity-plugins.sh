#!/usr/bin/env bash
# Antigravity CLI plugin installation.

set -uo pipefail

FAILURES=()

run() {
  echo "+ $*"
  if ! "$@"; then
    FAILURES+=("$*")
  fi
}

echo "Installing Antigravity CLI plugins..."

run agy plugin install https://github.com/DietrichGebert/ponytail

if [[ ${#FAILURES[@]} -gt 0 ]]; then
  echo ""
  echo "WARNING: ${#FAILURES[@]} command(s) failed:"
  for cmd in "${FAILURES[@]}"; do
    echo "  - $cmd"
  done
  exit 1
fi

echo "Done! All Antigravity CLI plugins installed."
