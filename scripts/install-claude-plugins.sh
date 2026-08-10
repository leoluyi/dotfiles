#!/usr/bin/env bash
# Claude Code plugin marketplace + plugin installation.
# Standalone: runnable directly (reports its own failures, exits 1 on any).
# Sourced: install-agent-skills.sh sources this optionally — reuses caller's
# FAILURES array/run() if present, and skips its own report/exit so the
# caller aggregates failures across both scripts.

set -uo pipefail

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
for orphan in claude-code-skills worktrunk shyuan-marketplace fullstack-dev-skills; do
  claude plugin marketplace remove "$orphan" 2>/dev/null || true
done

# Add marketplaces
# Official Anthropic marketplace — carries superpowers (pinned to an obra/superpowers
# SHA). Must be registered before `claude plugin install superpowers@claude-plugins-official`,
# otherwise the install fails with "not found in marketplace".
run claude plugin marketplace add anthropics/claude-plugins-official
run claude plugin marketplace add affaan-m/everything-claude-code
run claude plugin marketplace add anthropics/knowledge-work-plugins
# WARNING: This command may silently fail due to a CLI bug — the marketplace
# may not appear in known_marketplaces.json. Verify manually after running.
run claude plugin marketplace add yvictor/skills
run claude plugin marketplace add jarrodwatts/claude-hud
run claude plugin marketplace add multica-ai/andrej-karpathy-skills
run claude plugin marketplace add JuliusBrussee/caveman
run claude plugin marketplace add openai/codex-plugin-cc
# run claude plugin marketplace add jeffallan/claude-skills  # fullstack-dev-skills — removed, ~80% redundant with ECC
# claude-statusline is installed via npx, not as a plugin

# Install and enable plugins
run claude plugin install ecc@everything-claude-code
run claude plugin install superpowers@claude-plugins-official
run claude plugin install security-guidance@claude-plugins-official
run claude plugin install document-skills@anthropic-agent-skills
# Lean mattpocock/skills: neutralize superpowers' SessionStart auto-fire (the
# "You have superpowers / 1% rule" bootstrap injection) while keeping its skills
# available for explicit invocation. Re-applied on every install because the
# plugin cache is managed and a `claude plugin update` restores the original hook.
for hj in ~/.claude/plugins/cache/claude-plugins-official/superpowers/*/hooks/hooks.json; do
  [ -f "$hj" ] || continue
  if command -v jq >/dev/null 2>&1; then
    tmp="$(mktemp)" && jq 'del(.hooks.SessionStart)' "$hj" >"$tmp" && mv "$tmp" "$hj"
  else
    printf '{\n  "hooks": {}\n}\n' >"$hj"
  fi
  echo "+ neutralized superpowers SessionStart hook: $hj"
done
# run claude plugin install engineering-advanced-skills@claude-code-skills  # removed, redundant with ECC + superpowers
run claude plugin install engineering@knowledge-work-plugins
run claude plugin install claude-hud@claude-hud
run claude plugin install andrej-karpathy-skills@karpathy-skills
run claude plugin install caveman@caveman
run claude plugin install codex@openai-codex

# WARNING: This install may fail if the Yvictor/skills marketplace wasn't
# registered successfully (see warning above).
run claude plugin install dev-workflow@yvictor-skills

# run claude plugin install writing-humanizer@shyuan-marketplace  # removed, redundant with ECC avoid-ai-writing
# run claude plugin install fullstack-dev-skills@fullstack-dev-skills  # removed, ~80% redundant with ECC

# statusline.sh is now vendored in dotfiles (common_dotfiles/.claude/statusline.sh)
# and stow-symlinked into ~/.claude by bootstrap. It carries a local patch that adds
# a strategic-compact threshold % (✍️ 9%→37%) on top of the upstream script.
# `npx @kamranahmedse/claude-statusline` reinstalls the pristine upstream file and
# would overwrite the patch, so it stays disabled. To resync from upstream, re-run it
# once, then re-apply the patch and re-vendor common_dotfiles/.claude/statusline.sh.
# run npx @kamranahmedse/claude-statusline

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
