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

install_mcp_server() {
  local name="$1"
  shift

  if codex mcp list 2>/dev/null | awk -v server="$name" '$1 == server { found = 1 } END { exit !found }'; then
    echo "Codex MCP server already configured: $name"
    return 0
  fi

  run codex mcp add "$name" -- "$@"
}

echo "Installing Codex plugins..."

run codex plugin marketplace add upstash/context7
run codex plugin add context7@context7-marketplace
run codex plugin marketplace add sergebulaev/x-skills
run codex plugin add x-skills@x-skills
run codex plugin marketplace add DannyMac180/sol-advisor --ref main
run codex plugin add sol-advisor@sol-advisor
run codex plugin marketplace add DietrichGebert/ponytail
run codex plugin add ponytail@ponytail

echo "Installing Codex MCP servers..."
install_mcp_server playwright npx -y @playwright/mcp@latest

if [[ ${#FAILURES[@]} -gt 0 ]]; then
  echo ""
  echo "WARNING: ${#FAILURES[@]} command(s) failed:"
  for cmd in "${FAILURES[@]}"; do
    echo "  - $cmd"
  done
  exit 1
fi

echo "Done! All Codex plugins installed."
