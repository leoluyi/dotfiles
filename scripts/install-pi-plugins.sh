#!/usr/bin/env bash
# pi-agent plugin installation.

set -uo pipefail

FAILURES=()

run() {
  echo "+ $*"
  if ! "$@"; then
    FAILURES+=("$*")
  fi
}

echo "Installing pi-agent plugins..."

run pi install git:github.com/DietrichGebert/ponytail
run pi install https://github.com/cathrynlavery/diagram-design

if [[ ${#FAILURES[@]} -gt 0 ]]; then
  echo ""
  echo "WARNING: ${#FAILURES[@]} command(s) failed:"
  for cmd in "${FAILURES[@]}"; do
    echo "  - $cmd"
  done
  exit 1
fi

echo "Done! All pi-agent plugins installed."
