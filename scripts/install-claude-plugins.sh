#!/usr/bin/env bash
# Claude Code Plugins Installation Script
# Generated: 2026-03-10

set -euo pipefail

echo "Installing Claude Code plugins..."

# Add marketplaces
claude plugin marketplace add obra/superpowers
claude plugin marketplace add affaan-m/everything-claude-code
claude plugin marketplace add alirezarezvani/claude-skills
claude plugin marketplace add anthropics/knowledge-work-plugins
# WARNING: This command may silently fail due to a CLI bug — the marketplace
# may not appear in known_marketplaces.json. Verify manually after running.
claude plugin marketplace add Yvictor/skills
claude plugin marketplace add max-sixty/worktrunk

# Install and enable plugins
claude plugin install everything-claude-code@everything-claude-code
claude plugin install superpowers@superpowers-dev
claude plugin install engineering-advanced-skills@claude-code-skills
claude plugin install engineering@knowledge-work-plugins
# WARNING: This install may fail if the Yvictor/skills marketplace wasn't
# registered successfully (see warning above).
claude plugin install dev-workflow@yvictor-skills
claude plugin install worktrunk@worktrunk

echo "Done! All plugins installed."
