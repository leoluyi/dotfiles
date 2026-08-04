#!/usr/bin/env bash

set -euo pipefail

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required to patch Codex plugin hooks" >&2
  exit 1
fi

patch_json_file() {
  local file="$1"
  shift
  local tmp

  tmp="$(mktemp "${TMPDIR:-/tmp}/codex-hook.XXXXXX")"
  if jq "$@" "$file" >"$tmp"; then
    mv "$tmp" "$file"
    echo "+ patched $file"
  else
    rm -f "$tmp"
    return 1
  fi
}

shopt -s nullglob

security_hooks=(
  "$HOME/.codex/.tmp/marketplaces/claude-plugins-official/plugins/security-guidance/hooks/hooks.json"
  "$HOME/.codex/plugins/cache/claude-plugins-official/security-guidance"/*/hooks/hooks.json
)

for file in "${security_hooks[@]}"; do
  [ -f "$file" ] || continue
  if jq -e '.hooks.SessionStart' "$file" >/dev/null 2>&1; then
    patch_json_file "$file" 'del(.hooks.SessionStart)'
  fi
done

caveman_hooks=(
  "$HOME/.codex/.tmp/marketplaces/caveman/.codex/hooks.json"
  "$HOME/.codex/plugins/cache/caveman"/*/.codex/hooks.json
  "$HOME/.codex/plugins/cache/caveman"/*/*/.codex/hooks.json
)

caveman_command="printf '%s\\n' '{\"hookSpecificOutput\":{\"hookEventName\":\"SessionStart\",\"additionalContext\":\"CAVEMAN MODE ACTIVE. Rules: Drop articles/filler/pleasantries/hedging. Fragments OK. Short synonyms. Pattern: [thing] [action] [reason]. [next step]. Not: Sure! I would be happy to help you with that. Yes: Bug in auth middleware. Fix: Code/commits/security: write normal. User says stop caveman or normal mode to deactivate.\"}}'"

for file in "${caveman_hooks[@]}"; do
  [ -f "$file" ] || continue
  if jq -e '.hooks.SessionStart' "$file" >/dev/null 2>&1; then
    patch_json_file "$file" --arg command "$caveman_command" \
      '(.hooks.SessionStart[]?.hooks[]? | select(.type == "command")).command = $command'
  fi
done
