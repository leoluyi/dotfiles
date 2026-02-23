# AI / LLM Shell Integrations

## `llm` CLI (`~/.config/bash/41_llm`)

Shell functions powered by the [`llm` CLI](https://llm.datasette.io/).

**Requirements:** `llm-anthropic` plugin (`llm install llm-anthropic`) and an `ANTHROPIC_API_KEY` in `~/.secrets/`.

| Function | Usage | Description |
|---|---|---|
| `llm-cmd` | `llm-cmd "list files modified today"` | Translate natural language to a shell command |
| `llm-explain` | `llm-explain "find . -mtime -1"` or `cmd 2>&1 \| llm-explain` | Explain a command or piped output |
| `llm-fix` | `failing-cmd 2>&1 \| llm-fix` | Suggest a fix for a failing command's error output |
| `Alt+a` | Type a description on the prompt, press `Alt+a` | Replace the current readline line with a generated command |

Default model: `claude-sonnet-4.6` (set via `LLM_MODEL` in `41_llm`).

## fabric-ai (`~/.config/bash/42_fabric`)

Shell integration for [`fabric-ai`](https://github.com/danielmiessler/fabric).

**Requirements:** `fabric-ai` installed and configured via `fabric-ai --setup`.

| Function | Usage | Description |
|---|---|---|
| `fabric` | `fabric -p <pattern> [input]` | Alias for `fabric-ai` |
| `??` | `?? <question>` or `<cmd> \| ??` | General-purpose AI query using the `ai` pattern |

### Custom Patterns

Custom patterns are tracked in this repo and symlinked into `~/.config/fabric/patterns/` via Stow. Downloaded (official) patterns are gitignored.

```
common_dotfiles/.config/fabric/patterns/<pattern-name>/system.md
```

To add a new custom pattern:

1. Create the pattern directory and `system.md`:
   ```bash
   mkdir -p common_dotfiles/.config/fabric/patterns/<pattern-name>
   vim common_dotfiles/.config/fabric/patterns/<pattern-name>/system.md
   ```
2. Un-ignore it in `.gitignore`:
   ```
   !common_dotfiles/.config/fabric/patterns/<pattern-name>
   !common_dotfiles/.config/fabric/patterns/<pattern-name>/**
   ```
3. Re-stow to create the symlink:
   ```bash
   stow -R -t "$HOME" common_dotfiles
   ```

## Claude Code Plugins

Installed via `install_apps_macos.sh`. To install manually: `claude plugin install <name>`.

### everything-claude-code

[everything-claude-code](https://github.com/affaan-m/everything-claude-code) — agents, skills, hooks, and rules for AI-assisted development workflows.

**Agents:** `architect`, `build-error-resolver`, `code-reviewer`, `database-reviewer`, `doc-updater`, `e2e-runner`, `go-build-resolver`, `go-reviewer`, `planner`, `python-reviewer`, `refactor-cleaner`, `security-reviewer`, `tdd-guide`

**Skills:** `plan`, `tdd`, `security-review`, `learn-eval`, `continuous-learning`, `e2e`, `refactor-clean`, `go-review`, `python-review`, and more

**Hooks (always-on):**
- Blocks dev servers (`npm run dev`, etc.) outside tmux
- Blocks ad-hoc `.md`/`.txt` creation outside `docs/`, `README`, `CLAUDE`, etc.
- Reminds to use tmux for long-running commands; review reminder before `git push`
- Session start/end: loads previous context, persists state, evaluates for learnable patterns
- Post-edit: Prettier format, TypeScript check, `console.log` warning
