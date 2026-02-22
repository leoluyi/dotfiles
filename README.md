# dotfiles

Personal dotfiles for macOS (primary), Ubuntu, and CentOS. Uses [GNU Stow](https://www.gnu.org/software/stow/) to symlink config directories into `$HOME`.

## Setup

### macOS

Clone and run the bootstrap script:

```bash
git clone https://github.com/leoluyi/dotfiles.git ~/.dotfiles \
  && cd ~/.dotfiles \
  && ./bootstrap_macos.sh
```

To re-run without confirmation prompts:

```bash
set -- -f; bash bootstrap_macos.sh
```

### Ubuntu / CentOS

```bash
./bootstrap_ubuntu.sh
# or
./bootstrap_centos.sh
```

## Individual Steps

### Install applications

```bash
./install_apps_macos.sh   # macOS (Homebrew + casks + MAS)
./install_apps_ubuntu.sh  # Ubuntu
```

### macOS system defaults

```bash
./macos/setup-macos-preferences.sh
```

### Stow a specific package

```bash
# From repo root
stow -t "$HOME" common_dotfiles
stow -t "$HOME" nvim

# Dry run
stow -n -t "$HOME" common_dotfiles
```

## Fabric AI Patterns

Custom [fabric](https://github.com/danielmiessler/fabric) patterns live in `common_dotfiles/.config/fabric/patterns/`. Only custom patterns are tracked — the 250+ built-in patterns that fabric downloads are not committed here.

### Adding a new custom pattern

Create it directly in the dotfiles repo, then stow:

```bash
mkdir -p ~/.dotfiles/common_dotfiles/.config/fabric/patterns/<pattern-name>
$EDITOR ~/.dotfiles/common_dotfiles/.config/fabric/patterns/<pattern-name>/system.md

# Stow will symlink the new pattern into ~/.config/fabric/patterns/
stow -t "$HOME" common_dotfiles
```

### Adopting an existing pattern from `~/.config/fabric/patterns/`

```bash
# Copy the pattern into the dotfiles repo
cp -r ~/.config/fabric/patterns/<pattern-name> \
      ~/.dotfiles/common_dotfiles/.config/fabric/patterns/

# Remove the original (stow needs the slot to be free)
rm -rf ~/.config/fabric/patterns/<pattern-name>

# Create the symlink
stow -t "$HOME" common_dotfiles
```

> **Note:** `~/.config/fabric/.env` (API keys) is gitignored. See [Secrets](#secrets--local-overrides) for how to manage it.

## Secrets & Local Overrides

Never commit credentials or machine-specific settings to this repo. Two escape hatches are auto-sourced by `.bash_profile` on every shell startup:

### `~/.secrets/` — credentials and API keys

Create the directory and drop shell files into it. Each file is sourced in alphabetical order.

```bash
mkdir -p ~/.secrets

# Example: ~/.secrets/api_keys
cat > ~/.secrets/api_keys <<'EOF'
export OPENAI_API_KEY="sk-..."
export ANTHROPIC_API_KEY="..."
EOF
```

The directory lives entirely outside the dotfiles repo and should never be committed anywhere.

### `~/.config/bash/99_extra` — local machine overrides

For settings that are real config (not secrets) but shouldn't be shared — e.g., work-specific aliases, host-specific paths. Sourced automatically by `.bash_profile` as the last file in `~/.config/bash/`.

```bash
# Example: ~/.config/bash/99_extra
export WORK_PROXY="http://proxy.corp:3128"
alias vpn='openconnect corp.example.com'
```

This file is gitignored and won't be created by bootstrap. Create it manually as needed.

## AI / LLM Shell Integrations

Shell functions powered by the [`llm` CLI](https://llm.datasette.io/) live in `common_dotfiles/.config/bash/41_llm`. Requires the `llm-anthropic` plugin (`llm install llm-anthropic`) and an `ANTHROPIC_API_KEY` in `~/.secrets/`.

| Function | Usage | Description |
|---|---|---|
| `llm-cmd` | `llm-cmd "list files modified today"` | Translate natural language to a shell command |
| `llm-explain` | `llm-explain "find . -mtime -1"` or `cmd 2>&1 \| llm-explain` | Explain a command or piped output |
| `llm-fix` | `failing-cmd 2>&1 \| llm-fix` | Suggest a fix for a failing command's error output |
| `Alt+a` | Type a description on the prompt, press `Alt+a` | Replace the current readline line with a generated command |

## Cheatsheets

- [Vim](./cheatsheets/vim_shortcut_keys.md)
- [Tmux](./cheatsheets/tmux_cheatsheet.md)
- [Linux commands](./cheatsheets/linux-commands-cheatsheet.txt)

## References

- https://github.com/omerxx/dotfiles
- https://github.com/mathiasbynens/dotfiles
- https://github.com/alrra/dotfiles
- https://github.com/holman/dotfiles
- https://github.com/skwp/dotfiles
- https://github.com/ccwang002/dotfiles
- https://github.com/danteissaias/dotfiles
