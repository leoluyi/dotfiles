#!/usr/bin/env bash
# Claude Code Plugins Installation Script
# Generated: 2026-03-10

set -euo pipefail

echo "Installing Claude Code plugins..."

# Add marketplaces
claude plugin add-marketplace superpowers-dev --source github --repo obra/superpowers
claude plugin add-marketplace everything-claude-code --source github --repo affaan-m/everything-claude-code
claude plugin add-marketplace claude-code-skills --source github --repo alirezarezvani/claude-skills
claude plugin add-marketplace knowledge-work-plugins --source github --repo anthropics/knowledge-work-plugins
claude plugin add-marketplace yvictor-skills --source github --repo Yvictor/skills

# Install and enable plugins
claude plugin install everything-claude-code@everything-claude-code
claude plugin install superpowers@superpowers-dev
claude plugin install engineering-advanced-skills@claude-code-skills
claude plugin install engineering@knowledge-work-plugins
claude plugin install dev-workflow@yvictor-skills

# Install standalone skills
claude install-skill Jyo238/checkpoint

echo "Done! All plugins installed."
