#!/usr/bin/env bash
# Codex plugin marketplace + plugin installation.

set -uo pipefail

FAILURES=()

run() {
  echo "+ $*"
  if ! "$@"; then
    FAILURES+=("$*")
  fi
}

echo "Installing Codex plugins..."

run codex plugin marketplace add upstash/context7
run codex plugin add context7@context7-marketplace
run codex plugin marketplace add sergebulaev/x-skills
run codex plugin add x-skills@x-skills
run codex plugin marketplace add DannyMac180/sol-advisor --ref main
run codex plugin add sol-advisor@sol-advisor

if [[ ${#FAILURES[@]} -gt 0 ]]; then
  echo ""
  echo "WARNING: ${#FAILURES[@]} command(s) failed:"
  for cmd in "${FAILURES[@]}"; do
    echo "  - $cmd"
  done
  exit 1
fi

echo "Done! All Codex plugins installed."
