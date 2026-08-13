## Skill routing

A request matching an available skill → invoke it via the Skill tool as the first action,
before answering and before any other tool.

Two skill names collide here; pick this one:

- Report bugs conversationally, file them as issues, "QA session" → `qa`
  (`diagnose` is for root-causing a bug already reported)
- Review a diff, branch, or PR → `review`
  (`code-review` is a near-duplicate copy of it)

## Agent Configuration Scope

When adjusting Codex or other agent configuration from this dotfiles repository, treat the change as global by default and update the corresponding tracked dotfile under `common_dotfiles/`.
Only modify a repository-local `.codex/` or other project-scoped configuration when I explicitly request it.
