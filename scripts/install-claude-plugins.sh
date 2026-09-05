#!/usr/bin/env bash
# Claude Code plugin marketplace + plugin installation.

set -uo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

declare -p FAILURES &>/dev/null || FAILURES=()

if ! declare -f run &>/dev/null; then
  run() {
    echo "+ $*"
    if ! "$@"; then
      FAILURES+=("$*")
    fi
  }
fi

echo "Installing Claude Code plugins..."

# Remove orphan marketplaces (no enabled plugins, just wasting disk)
for orphan in claude-code-skills worktrunk shyuan-marketplace fullstack-dev-skills everything-claude-code; do
  claude plugin marketplace remove "$orphan" 2>/dev/null || true
done

# Add marketplaces
run claude plugin marketplace add anthropics/claude-plugins-official
run claude plugin marketplace add anthropics/knowledge-work-plugins
run claude plugin marketplace add anthropics/skills
run claude plugin marketplace add yvictor/skills
run claude plugin marketplace add jarrodwatts/claude-hud
run claude plugin marketplace add multica-ai/andrej-karpathy-skills
run claude plugin marketplace add JuliusBrussee/caveman
run claude plugin marketplace add openai/codex-plugin-cc
run claude plugin marketplace add DietrichGebert/ponytail
run claude plugin marketplace add upstash/context7
run claude plugin marketplace add cathrynlavery/diagram-design
# run claude plugin marketplace add affaan-m/everything-claude-code  # ECC uninstalled 2026-08-11

# Install and enable plugins
# run claude plugin install ecc@everything-claude-code  # uninstalled 2026-08-11
run claude plugin install superpowers@claude-plugins-official
run claude plugin install security-guidance@claude-plugins-official
run claude plugin install document-skills@anthropic-agent-skills

for hj in ~/.claude/plugins/cache/claude-plugins-official/superpowers/*/hooks/hooks.json; do
  [ -f "$hj" ] || continue
  if command -v jq >/dev/null 2>&1; then
    tmp="$(mktemp)" && jq 'del(.hooks.SessionStart)' "$hj" >"$tmp" && mv "$tmp" "$hj"
  else
    printf '{\n  "hooks": {}\n}\n' >"$hj"
  fi
  echo "+ neutralized superpowers SessionStart hook: $hj"
done

run claude plugin install engineering@knowledge-work-plugins
run claude plugin install claude-hud@claude-hud
run claude plugin install andrej-karpathy-skills@karpathy-skills
run claude plugin install caveman@caveman
run claude plugin install codex@openai-codex
run claude plugin install ponytail@ponytail
run claude plugin install dev-workflow@yvictor-skills
run claude plugin install context7@context7-marketplace
run claude plugin install diagram-design@diagram-design
run "${script_dir}/install-claude-settings.sh"

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  if [[ ${#FAILURES[@]} -gt 0 ]]; then
    echo ""
    echo "WARNING: ${#FAILURES[@]} command(s) failed:"
    for cmd in "${FAILURES[@]}"; do
      echo "  - $cmd"
    done
    exit 1
  fi
  echo "Done! All plugins installed."
fi
