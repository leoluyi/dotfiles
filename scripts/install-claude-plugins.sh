#!/usr/bin/env bash
# Claude Code Plugins Installation Script
# Generated: 2026-03-10

set -uo pipefail

FAILURES=()

run() {
  echo "+ $*"
  if ! "$@"; then
    FAILURES+=("$*")
  fi
}

echo "Installing Claude Code plugins..."

# Add marketplaces
run claude plugin marketplace add obra/superpowers
run claude plugin marketplace add affaan-m/everything-claude-code
run claude plugin marketplace add alirezarezvani/claude-skills
run claude plugin marketplace add anthropics/knowledge-work-plugins
# WARNING: This command may silently fail due to a CLI bug — the marketplace
# may not appear in known_marketplaces.json. Verify manually after running.
run claude plugin marketplace add Yvictor/skills
run claude plugin marketplace add max-sixty/worktrunk
run claude plugin marketplace add jarrodwatts/claude-hud
# claude-statusline is installed via npx, not as a plugin

# Install and enable plugins
run claude plugin install everything-claude-code@everything-claude-code
run claude plugin install superpowers@superpowers-dev
run claude plugin install engineering-advanced-skills@claude-code-skills
run claude plugin install engineering@knowledge-work-plugins
# WARNING: This install may fail if the Yvictor/skills marketplace wasn't
# registered successfully (see warning above).
run claude plugin install dev-workflow@yvictor-skills
run claude plugin install worktrunk@worktrunk
run claude plugin install claude-hud@claude-hud
# Install claude-statusline via npx
run npx @kamranahmedse/claude-statusline

# Install git-cloned skills
mkdir -p ~/.claude/skills
clone_or_pull() {
  local repo="$1" dest="$2"
  git clone "$repo" "$dest" 2>/dev/null || git -C "$dest" pull
}
run clone_or_pull https://github.com/conorbronsdon/avoid-ai-writing ~/.claude/skills/avoid-ai-writing

# --- ykdojo/claude-code-tips quick setup (Tip 45) ---
# Installs cc-safe, configures MCP lazy-load, permissions, attribution, etc.
# Default skips: 3 (status-line), 4 (auto-updates), 9 (aliases), 10 (fork-shortcut)
read -p "Run ykdojo/claude-code-tips setup script? [y/N]: " run_tips_setup
if [[ "$run_tips_setup" =~ ^[Yy]$ ]]; then
  echo "Running setup with skip: 3 4 9 10..."
  if ! echo "3 4 9 10" | bash <(curl -s https://raw.githubusercontent.com/ykdojo/claude-code-tips/main/scripts/setup.sh); then
    FAILURES+=("ykdojo/claude-code-tips setup script")
  fi
fi

if [[ ${#FAILURES[@]} -gt 0 ]]; then
  echo ""
  echo "WARNING: ${#FAILURES[@]} command(s) failed:"
  for cmd in "${FAILURES[@]}"; do
    echo "  - $cmd"
  done
  exit 1
fi

echo "Done! All plugins installed."
