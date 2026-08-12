#!/usr/bin/env bash
# CLI agent (Claude Code, Codex) skill installation script.
# Optionally sources install-claude-plugins.sh for marketplace/plugin setup.
# Generated: 2026-03-10

set -uo pipefail

FAILURES=()

run() {
  echo "+ $*"
  if ! "$@"; then
    FAILURES+=("$*")
  fi
}

_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Standalone skill repos (not marketplace plugins)
mkdir -p ~/.claude/skills
clone_or_pull() {
  local repo="$1" dest="$2"
  if git clone "$repo" "$dest" 2>/dev/null; then
    return
  fi
  git -C "$dest" pull --rebase --autostash || {
    git -C "$dest" rebase --abort 2>/dev/null || true
    git -C "$dest" merge --abort 2>/dev/null || true
    git -C "$dest" reset --hard origin/HEAD
    git -C "$dest" pull --rebase --autostash
  }
}
# run clone_or_pull https://github.com/conorbronsdon/avoid-ai-writing ~/.claude/skills/avoid-ai-writing  # removed
# run clone_or_pull https://github.com/garrytan/gstack ~/.claude/skills/gstack  # removed, ~90% redundant with ECC + superpowers (bare skill names clash)
# echo "NOTE: gstack requires Bun v1.0+ (https://bun.sh)"
# (cd ~/.claude/skills/gstack && ./setup)
npx skills@latest add mattpocock/skills -g -y --all
# mattpocock ships obsidian-vault pinned to their own vault path; drop it so our
# forked version (in leoluyi/skills) installs cleanly instead of being skipped as
# a name conflict. Order matters: remove AFTER mattpocock's --all, BEFORE leoluyi.
npx skills@latest remove obsidian-vault -g -y 2>/dev/null || true
npx skills@latest add leoluyi/skills -g -y
# Official Anthropic writing skill: brainstorm -> curate -> draft -> polish, section by section
npx skills@latest add anthropics/skills -g -y -s doc-coauthoring
# Official Anthropic skill: generate/apply cohesive visual themes across a project
npx skills@latest add anthropics/skills -g -y -s theme-factory
# caveman is also installed as a Claude Code plugin above; this line targets Codex CLI
npx skills@latest add JuliusBrussee/caveman -g -a codex -y
npx skills@latest add sunbigfly/ppt-agent-skills -g -y

# Claude-style SessionStart hooks do not all emit the single JSON object Codex
# expects. Patch the installed Codex copies after plugin updates.
run "${_SCRIPT_DIR}/fix-codex-session-start-hooks.sh"


# --- ykdojo/claude-code-tips quick setup (Tip 45) ---
# Installs cc-safe, configures MCP lazy-load, permissions, attribution, etc.
# Default skips: 3 (status-line), 4 (auto-updates), 9 (aliases), 10 (fork-shortcut)
read -p "Run ykdojo/claude-code-tips setup script? [y/N]: " run_tips_setup
if [[ "$run_tips_setup" =~ ^[Yy]$ ]]; then
  echo "Running setup with skip: 3 4 8 9 10..."
  if ! echo "3 4 8 9 10" | bash <(curl -s https://raw.githubusercontent.com/ykdojo/claude-code-tips/main/scripts/setup.sh); then
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
