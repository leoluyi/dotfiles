# My dotfiles

## Installation - for MacOS

### Using Git and the bootstrap script

```bash
git clone https://github.com/leoluyi/dotfiles.git && \
  cd dotfiles && \
  source /bootstrap_macos.sh.sh
```

Alternatively, to update while avoiding the confirmation prompt:

```bash
set -- -f; source bootstrap_macos.sh
```

### Install Homebrew formulae

When setting up a new Mac, you may want to install some common Homebrew formulae (after installing Homebrew, of course):

```bash
./install_apps_macos.sh
```

### Sensible macOS defaults

When setting up a new Mac, you may want to set some sensible macOS defaults:

```bash
. ./macos/.scripts/.macos
```

### Fonts

That will give you the font to put in the config:

```bash
fc-list : family | rg -i powerline
```

## Cheatsheets & Shorcut keys

- [Vim](./vim/vim_shortcut_keys.md)
- [Tmux](./tmux/tmux_cheatsheet.md)
- [Sublime-Text](./sublime-text/sublime_shorcut_keys.md)

## Reference

- https://github.com/mathiasbynens/dotfiles
- https://github.com/alrra/dotfiles
- https://github.com/holman/dotfiles
- https://github.com/skwp/dotfiles
- https://github.com/ccwang002/dotfiles
- https://github.com/danteissaias/dotfiles
