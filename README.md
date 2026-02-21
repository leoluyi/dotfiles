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

### `~/.config/extra` — local machine overrides

For settings that are real config (not secrets) but shouldn't be shared — e.g., work-specific aliases, host-specific paths.

```bash
# Example: ~/.config/extra
export WORK_PROXY="http://proxy.corp:3128"
alias vpn='openconnect corp.example.com'
```

This file is not part of the stow package, so it won't be created by bootstrap. Create it manually as needed.

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
