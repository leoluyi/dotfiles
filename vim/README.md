# Vim settings

## Install [The Ultimate vimrc](https://github.com/amix/vimrc)

**Install for your own user only**

```sh
$ git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
$ sh ~/.vim_runtime/install_awesome_vimrc.sh

# copy settings
$ wget -qO ~/.vim_runtime/my_configs.vim https://github.com/leoluyi/dotfiles/raw/master/vim/vim_runtime/my_configs.vim
```

**Install for multiple users**

```sh
$ git clone --depth=1 https://github.com/amix/vimrc.git /opt/vim_runtime
$ sh ~/.vim_runtime/install_awesome_parameterized.sh /opt/vim_runtime user0 user1 user2

# to install for all users with home directories
$ sh ~/.vim_runtime/install_awesome_parameterized.sh /opt/vim_runtime --all
```

How to uninstall

- Remove `~/.vim_runtime`
- Remove any lines that reference `.vim_runtime` in your `~/.vimrc`

## Install Packages

[Vim Awesome](https://vimawesome.com)

### Install package with Pathogen

```sh
$ cd ~/.vim_runtime/my_plugins
$ git clone <package_repo>
```

Install packages

```sh
$ cd ~/.vim_runtime/my_plugins
$ git clone https://github.com/tweekmonster/braceless.vim
$ git clone --recursive https://github.com/davidhalter/jedi-vim
$ git clone https://github.com/valloric/vim-indent-guides
$ git clone https://github.com/asheq/close-buffers.vim
$ git clone https://github.com/ctrlpvim/ctrlp.vim
```

### Install package with vim-plug

**Install [vim-plug](https://github.com/junegunn/vim-plug)**

Download plug.vim and put it in the "autoload" directory.

```
curl -fLo ~/.vim_runtime/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

Usage

Add a vim-plug section to your `~/.vimrc` (or `~/.config/nvim/init.vim` for Neovim):

1. Begin the section with `call plug#begin()`.
2. List the plugins with `Plug` commands.
3. `call plug#end()` to update `&runtimepath` and initialize plugin system.
4. Reload `.vimrc` with `:so %` and `:PlugInstall` to install plugins.
5. `PlugClean[!]` Remove unused directories.

### Packages List

[**braceless.vim**](https://github.com/tweekmonster/braceless.vim)

- Moving to recognized blocks is done with `[[` and `]]`
- `vaP`, `ciP`, `>iP`

[**close-buffers**](https://github.com/asheq/close-buffers.vim)

- `:CloseOtherBuffers` 🔥: Close all buffers except buffer in current window.
- `:CloseHiddenBuffers` 🔥: Close all buffers not visible in any window.
- `:CloseBuffersMenu` 🔥: Lets you choose any other command.

[**ctrlp.vim**](https://github.com/ctrlpvim/ctrlp.vim)

- Run `:CtrlP` or `:CtrlP` [starting-directory] in find file mode.
- Run `:CtrlPBuffer` or `:CtrlPMRU` in find buffer or find MRU file mode.
- Run `:CtrlPMixed` to search in Files, Buffers and MRU files at the same time.

[**Nvim-R**](https://github.com/jalvesaq/Nvim-R)

- https://medium.freecodecamp.org/turning-vim-into-an-r-ide-cd9602e8c217
- https://gist.github.com/leoluyi/2aeb4795c99de487b568178a31f7b635

Commands

- `devtools::install_github("jalvesaq/colorout")`
- `\rf` opens vim-connected R session
- `<Space>` sends code from vim to R; here remapped in `init.vim` from default `\l`
- `:split` or `:vsplit`: splits viewport (similar to pane split in tmux)
- `<C-x><C-o>` omni completion for R objects/functions.
- `<C-w>H` or `<C-w>K`: toggles between horizontal/vertical splits
- `<C-w>w` jumps cursor to R viewport and back
- `<C-w>r` swaps viewports

[**ncim-R**](https://github.com/gaalcaras/ncm-R)

https://github.com/gaalcaras/ncm-R/issues/2#issuecomment-353635826

```
$ pip install neovim
```

Use vim-plug to install:

```
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'jalvesaq/Nvim-R'
Plug 'gaalcaras/ncm-R'

" Vim 8 only
if !has('nvim')
    Plug 'roxma/vim-hug-neovim-rpc'
endif

" Optional: for snippet support
" Further configuration might be required, read below
Plug 'sirver/UltiSnips'
Plug 'ncm2/ncm2-ultisnips'

" Optional: better Rnoweb support (LaTeX completion)
Plug 'lervag/vimtex'
```

[**Nerdtree**](https://github.com/scrooloose/nerdtree)

- `<leader>nn` toggle nerdtree
- `o` open/close folder

[**vim-indent-guides**](https://github.com/valloric/vim-indent-guides)

[**jedi-vim**](https://github.com/davidhalter/jedi-vim)


## Misc

- `:so %` to reload `.vimrc`
