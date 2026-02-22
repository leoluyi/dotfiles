# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Personal dotfiles for macOS (primary), Ubuntu/CentOS, and Windows. Uses **GNU Stow** to symlink configuration directories into `$HOME`, keeping the repo as the source of truth.

## Key Commands

### Syncing dotfiles to home directory
```bash
# Full setup (interactive)
./bootstrap_macos.sh

# Full setup (non-interactive / force)
set -- -f; bash bootstrap_macos.sh
# or
./bootstrap_macos.sh -f
```

### Installing applications
```bash
./install_apps_macos.sh      # macOS (Homebrew + casks + MAS)
./install_apps_ubuntu.sh     # Ubuntu
```

### macOS system defaults
```bash
./macos/setup-macos-preferences.sh
```

### Manually stowing a directory
```bash
# From repo root - stow a package into $HOME
stow -t "$HOME" common_dotfiles
stow -t "$HOME" nvim
stow -t "$HOME" macos   # Not stowed - macOS scripts only

# Dry run
stow -n -t "$HOME" common_dotfiles
```

## Architecture

### Stow Package Layout

Each top-level directory (except `macos/`, `scripts/`, `cheatsheets/`, etc.) is a **Stow package**. The directory tree inside each package mirrors the desired layout under `$HOME`:

```
common_dotfiles/
  .config/bash/       → ~/.config/bash/
  .config/git/        → ~/.config/git/
  .config/tmux/       → ~/.config/tmux/
  .local/bin/         → ~/.local/bin/
  .claude/            → ~/.claude/       (Claude Code config)

nvim/
  .config/nvim/       → ~/.config/nvim/

espanso/
  Library/Application Support/espanso/  → ~/Library/Application Support/espanso/
```

`.stowrc` at the repo root configures global ignore patterns (`.stowrc`, `DS_Store`).

### Bootstrap Script Flow (`bootstrap_macos.sh`)

1. Validates macOS, sets up Homebrew PATH
2. Switches default shell to Homebrew's Bash 5+
3. Fixes Docker bash completions
4. Links Espanso configs (special path: `~/Library/Application Support/espanso/`)
5. Sets up virtualenv symlink, Sublime Text config
6. Syncs Neovim config via Stow (with force option to overwrite existing)
7. Creates XDG dirs (`~/.config`, `~/.local/bin`, `~/.local/share`)
8. Installs scripts from `scripts/` to `~/.local/bin/`
9. Stows `common_dotfiles` (primary dotfiles package)
10. Creates `~/.dotfiles` symlink pointing to this repo

### Configuration Organization

- **`common_dotfiles/.config/`** - XDG-compliant configs: bash, zsh, git, tmux, fzf, ranger, starship, alacritty, wezterm, etc.
- **`common_dotfiles/.local/bin/`** - User scripts (fzgit, ffmpeg helpers, screenshot, etc.)
- **`common_dotfiles/.config/bash/`** - Modular bash config with numeric-prefix load order (see Shell Configuration Chain)
- **`common_dotfiles/.claude/`** - Claude Code global config (CLAUDE.md, settings)
- **`nvim/`** - Standalone Stow package for Neovim (Lazy.nvim based, Lua only)
- **`macos/`** - macOS setup scripts (not stowed; run directly)
- **`homebrew/`** - Brewfile for `brew bundle`
- **`espanso/`** - Text expansion profiles (default, arc, chrome, zen-browser)
- **`raycast-scripts/`** - Raycast automation scripts
- **`cheatsheets/`** - Reference docs (vim, tmux, git aliases, etc.)
- **`apps-config/`** - App-specific configs that can't be stowed (manual setup)

### Shell Configuration Chain

`.bash_profile` (in `macos/`) sources every file in `~/.config/bash/` in alphanumeric order, then sources every file under `~/.secrets/`. The numeric prefix controls load order:

| File | Purpose |
|---|---|
| `00_xdg_env` | XDG base dirs + tool-specific `$HOME` vars; `$DOTFILES` → repo root |
| `10_env` | General environment variables |
| `20_aliases` | General shell aliases |
| `21_cd_aliases` | Directory navigation aliases |
| `30_apps` | Per-app aliases, env vars, PATH additions; lazy-loads nvm/thefuck |
| `41_llm` | `llm-cmd`, `llm-explain`, `llm-fix`, `Alt+a` readline keybind |
| `50_fzf` | fzf keybindings and completion (must load after bash_completion.sh) |
| `60_utils` | Utility functions |
| `99_extra` | Local machine overrides — gitignored, create manually as needed |

### Git Configuration

Located at `common_dotfiles/.config/git/`. Includes 40+ aliases. Notable ones:
- `lg` - graphical log
- `ac` - add + commit
- `df` - diff with syntax highlighting
- `amend` - amend without editing message

## Platform Notes

- **macOS** is the primary platform; most active development happens here
- **Ubuntu/CentOS** configs are largely shared (centos → symlink to ubuntu)
- **Windows** configs live in `windows/` (WSL + Tabby terminal focused)
- The `bootstrap_centos.sh` / `bootstrap_ubuntu.sh` scripts mirror the macOS pattern

## Neovim Config

See `nvim/.config/nvim/CLAUDE.md` for detailed Neovim architecture notes. Summary:
- Lazy.nvim plugin manager, Lua only
- Leader: `,` / Local leader: `<Space>`
- LSP via native `vim.lsp.config` API (Neovim 0.11+)
- Extras in `lua/plugins/extras/` for optional language/feature support
