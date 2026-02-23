# CLAUDE.md

## Repository Purpose

Personal dotfiles for macOS (primary), Ubuntu/CentOS, and Windows. Managed with **GNU Stow** — each package directory mirrors the target layout under `$HOME`.

## Key Commands

```bash
# Full setup (interactive)
./bootstrap_macos.sh

# Full setup (force/non-interactive)
./bootstrap_macos.sh -f

# Install apps
./install_apps_macos.sh      # macOS (Homebrew + casks + MAS)
./install_apps_ubuntu.sh     # Ubuntu

# macOS system defaults
./macos/setup-macos-preferences.sh

# Stow a package into $HOME (dry run with -n)
stow -t "$HOME" common_dotfiles
stow -t "$HOME" nvim
stow -n -t "$HOME" common_dotfiles   # dry run
```

## Architecture

### Stow Packages

```
common_dotfiles/
  .config/bash/       → ~/.config/bash/
  .config/git/        → ~/.config/git/
  .config/tmux/       → ~/.config/tmux/
  .local/bin/         → ~/.local/bin/
  .claude/            → ~/.claude/       (Claude Code config)

nvim/
  .config/nvim/       → ~/.config/nvim/

scripts/              → stow --adopt into ~/.local/bin/ (dotfiles only)
```

**NOT managed via Stow:**
- `espanso/` — manually symlinked: `ln -s .../espanso ~/Library/Application\ Support/espanso`
- `macos/` — run scripts directly; `.bash_profile` lives here (not stowed)
- `tmux/` — empty legacy dir; tmux config is under `common_dotfiles/.config/tmux/`

`.stowrc` ignores `.stowrc` and `DS_Store` globally.

### Configuration Organization

| Directory | Contents |
|---|---|
| `common_dotfiles/.config/` | XDG configs: bash, zsh, git, tmux, fzf, lf, ranger, starship, alacritty, wezterm, zed, yabai, skhd, aerospace, etc. |
| `common_dotfiles/.local/bin/` | User scripts (fzgit, ffmpeg helpers, screenshot, etc.) |
| `common_dotfiles/.claude/` | Claude Code global config (CLAUDE.md, settings, rules) |
| `nvim/` | Neovim — standalone Stow package (Lazy.nvim, Lua only) |
| `macos/` | macOS setup scripts — not stowed, run directly |
| `homebrew/` | Brewfile for `brew bundle` |
| `espanso/` | Text expansion profiles (default, arc, chrome, zen-browser) |
| `raycast-scripts/` | Raycast automation scripts |
| `cheatsheets/` | Reference docs (vim, tmux, git aliases, etc.) |
| `apps-config/` | App configs that can't be stowed — manual setup |
| `vscode/` | VSCode keyboard shortcuts reference |
| `windows/` | WSL + Tabby terminal configs |
| `centos/` | CentOS-specific configs |
| `ubuntu/` | Ubuntu configs + `.bash_profile` |

### Bootstrap Script Flow (`bootstrap_macos.sh`)

1. Validates macOS, sets up Homebrew PATH
2. Switches default shell to Homebrew Bash 5+
3. Fixes Docker bash completions
4. Symlinks `espanso/` → `~/Library/Application Support/espanso/`
5. Sets up virtualenv symlink
6. Stows `nvim/` (with force to overwrite existing)
7. Creates XDG dirs (`~/.config`, `~/.local/bin`, `~/.local/share`)
8. Stows `scripts/` into `~/.local/bin/` via `stow --adopt`
9. Stows `common_dotfiles/`
10. Creates `~/.dotfiles` symlink → repo root

### Shell Configuration Chain

`.bash_profile` (in `macos/`) sources all files in `~/.config/bash/` alphanumerically, then all files under `~/.secrets/`.

| File | Purpose |
|---|---|
| `00_xdg_env` | XDG base dirs + tool `$HOME` vars; `$DOTFILES` → repo root |
| `10_env` | General environment variables |
| `20_aliases` | General shell aliases |
| `21_cd_aliases` | Directory navigation aliases |
| `30_apps` | Per-app aliases, env vars, PATH; lazy-loads nvm/thefuck |
| `41_llm` | `llm-cmd`, `llm-explain`, `llm-fix`, `Alt+a` readline keybind |
| `42_fabric` | fabric-ai shell integration |
| `50_fzf` | fzf keybindings and completion (loads after bash_completion.sh) |
| `60_utils` | Utility functions |
| `99_extra` | Local machine overrides — gitignored, create manually |

### Git Configuration

Location: `common_dotfiles/.config/git/`

Notable aliases: `lg` (graphical log), `ac` (add + commit), `df` (diff with syntax highlighting), `amend` (amend without editing message).

## Platform Notes

- **macOS** — primary platform
- **Ubuntu/CentOS** — configs largely shared; `centos/` symlinks to `ubuntu/`
- **Windows** — `windows/` (WSL + Tabby terminal)

## Neovim Config

See `nvim/.config/nvim/CLAUDE.md` for full details.

- Plugin manager: Lazy.nvim, Lua only
- Leader: `,` / Local leader: `<Space>`
- LSP via native `vim.lsp.config` API (Neovim 0.11+)
- Optional extras: `lua/plugins/extras/`
