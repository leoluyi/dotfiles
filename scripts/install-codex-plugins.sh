#!/usr/bin/env bash
# Codex plugin marketplace + plugin installation.

set -uo pipefail

FAILURES=()

run() {
  echo "+ $*"
  if "$@"; then
    return 0
  fi

  FAILURES+=("$*")
  return 1
}

marketplace_configured() {
  local marketplace="$1"

  if command -v jq >/dev/null 2>&1; then
    codex plugin marketplace list --json 2>/dev/null |
      jq -e --arg name "$marketplace" '.marketplaces[]? | select(.name == $name)' >/dev/null
    return
  fi

  codex plugin marketplace list --json 2>/dev/null |
    awk -v name="$marketplace" '$0 ~ "\"name\": \"" name "\"" { found = 1 } END { exit !found }'
}

plugin_installed() {
  local plugin_id="$1"

  if command -v jq >/dev/null 2>&1; then
    codex plugin list --json 2>/dev/null |
      jq -e --arg id "$plugin_id" '.installed[]? | select(.pluginId == $id and .installed == true)' >/dev/null
    return
  fi

  codex plugin list --json 2>/dev/null |
    awk -v id="$plugin_id" '
      /"pluginId":/ {
        matching = ($0 ~ "\"pluginId\": \"" id "\"")
      }
      matching && /"installed": true/ { found = 1 }
      END { exit !found }
    '
}

add_marketplace() {
  local marketplace="$1"
  local source="$2"
  shift 2

  local -a add_command=(codex plugin marketplace add "$source" "$@")
  local add_output add_status

  echo "+ ${add_command[*]}"
  add_output=$("${add_command[@]}" 2>&1)
  add_status=$?
  if [[ "$add_status" -eq 0 ]]; then
    printf '%s\n' "$add_output"
    return 0
  fi

  if [[ "$add_output" == *"already added from a different source"* ]]; then
    printf 'WARNING: Codex plugin marketplace already exists from a different source: %s\n' "$marketplace" >&2
    return 0
  fi

  printf '%s\n' "$add_output" >&2
  FAILURES+=("${add_command[*]}")
  return "$add_status"
}

install_plugin() {
  local plugin="$1"
  local marketplace="$2"
  local source="$3"
  shift 3

  local plugin_id="${plugin}@${marketplace}"

  if plugin_installed "$plugin_id"; then
    echo "Codex plugin already installed: $plugin_id"
    return 0
  fi

  if marketplace_configured "$marketplace"; then
    echo "Codex plugin marketplace already configured: $marketplace"
  elif ! add_marketplace "$marketplace" "$source" "$@"; then
    return 1
  fi

  run codex plugin add "$plugin_id"
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

install_plugin context7 context7-marketplace upstash/context7
install_plugin x-skills x-skills sergebulaev/x-skills
install_plugin sol-advisor sol-advisor DannyMac180/sol-advisor --ref main
install_plugin ponytail ponytail DietrichGebert/ponytail

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
