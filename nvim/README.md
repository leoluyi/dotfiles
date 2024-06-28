# Vim settings

## Install the Ultimate Vimrc

https://github.com/leoluyi/vimrc

**Install for your own user only**

```bash
# Install Ultimate vimrc
git clone --depth=1 https://github.com/leoluyi/vimrc.git ~/.vim_runtime \
  && bash ~/.vim_runtime/install_awesome_vimrc.sh

# copy settings
wget -qO ~/.vim_runtime/my_configs.vim https://github.com/leoluyi/dotfiles/raw/master/vim/vim_runtime/my_configs.vim
wget -qO ~/.vim_runtime/vimrcs/filetypes.vim https://github.com/leoluyi/dotfiles/raw/master/vim/vim_runtime/vimrcs/filetypes.vim
```

**Install for multiple users**

```bash
$ git clone --depth=1 https://github.com/leoluyi/vimrc.git /opt/vim_runtime
$ sh ~/.vim_runtime/install_awesome_parameterized.sh /opt/vim_runtime user0 user1 user2

# to install for all users with home directories
$ sh ~/.vim_runtime/install_awesome_parameterized.sh /opt/vim_runtime --all
```

**How to update to latest version**

```bash
cd ~/.vim_runtime
git pull --rebase
```

**How to uninstall**

- Remove `rm -rf ~/.vim_runtime`
- Remove any lines that reference `.vim_runtime` in your `~/.vimrc`

## Install Python Requirements

```bash
pip install neovim pynvim jedi black flake8 autopep8 isort
```

## Vim Plugins

[Vim Awesome](https://vimawesome.com)

### 1. Install package with [Pathogen](https://github.com/tpope/vim-pathogen) (Deprecated)

### 2. Install package with vim-plug

**Install [vim-plug](https://github.com/junegunn/vim-plug)**

Download plug.vim and put it in the "autoload" directory.

```bash
curl -fLo ~/.vim_runtime/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

**Usage**

Add a vim-plug section to your `~/.vimrc` (or `~/.config/nvim/init.vim` for Neovim).
Edit `~/.vim_runtime/my_configs.vim` insetead for **Ultimate vimrc** settings:

1. Begin the section with `call plug#begin()`.
2. List the plugins with `Plug` commands.
3. `call plug#end()` to update `&runtimepath` and initialize plugin system.
4. Reload `.vimrc` with `:so %` and `:PlugInstall` to install plugins.

**Commands**

1. `PlugInstall`: Install plugins
2. `PlugUpdate`: Install or update plugins.
3. `PlugClean[!]`: Remove unused directories (bang version will clean without prompt).

## Misc

- `:so %` to reload `.vimrc`


## Neovim rc folder structure

```
📂 ~/.config/nvim
├── 📁 after
├── 📁 ftplugin
├── 📂 lua
│  ├── 🌑 myluamodule.lua
│  └── 📂 other_modules
│     ├── 🌑 anothermodule.lua
│     └── 🌑 init.lua
├── 📁 pack
├── 📁 plugin
├── 📁 syntax
└── 🇻 init.vim
```

## References

- [Setting up VIM as an IDE for Python](https://medium.com/@hanspinckaers/setting-up-vim-as-an-ide-for-python-773722142d1d)
- [Keep your vimrc file clean](https://vim.fandom.com/wiki/Keep_your_vimrc_file_clean)
- [xu-cheng/dotfiles](https://github.com/xu-cheng/dotfiles/tree/master/home/.config/nvim)
- [dezull/awesome-vimrc](https://github.com/dezull/awesome-vimrc) - amix's vimrc, modified to use vim plug
- [WaylonWalker/devtainer)](https://github.com/WaylonWalker/devtainer/tree/main/nvim/.config/nvim)
- [ThePrimeagen](https://github.com/ThePrimeagen/.dotfiles/blob/master/nvim/.config/nvim/init.vim)
- [vim-lua-guide](https://github.com/nanotee/nvim-lua-guide)
