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
# run claude plugin marketplace add alirezarezvani/claude-skills  # engineering-advanced-skills — removed, redundant with ECC + superpowers
run claude plugin marketplace add anthropics/knowledge-work-plugins
# WARNING: This command may silently fail due to a CLI bug — the marketplace
# may not appear in known_marketplaces.json. Verify manually after running.
run claude plugin marketplace add yvictor/skills
# run claude plugin marketplace add shyuan/shyuan-marketplace  # writing-humanizer — removed, redundant with ECC avoid-ai-writing
run claude plugin marketplace add jarrodwatts/claude-hud
run claude plugin marketplace add forrestchang/andrej-karpathy-skills
# run claude plugin marketplace add jeffallan/claude-skills  # fullstack-dev-skills — removed, ~80% redundant with ECC
# claude-statusline is installed via npx, not as a plugin

# Install and enable plugins
run claude plugin install ecc@everything-claude-code
run claude plugin install superpowers@claude-plugins-official
run claude plugin install security-guidance@claude-plugins-official
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
run clone_or_pull https://github.com/conorbronsdon/avoid-ai-writing ~/.claude/skills/avoid-ai-writing
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
