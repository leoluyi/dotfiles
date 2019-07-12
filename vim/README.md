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

**How to update to latest version**

```
cd ~/.vim_runtime
git pull --rebase
```

**How to uninstall**

- Remove `rm -rf ~/.vim_runtime`
- Remove any lines that reference `.vim_runtime` in your `~/.vimrc`

## Packages

[Vim Awesome](https://vimawesome.com)

### 1. Install package with Pathogen

```sh
$ cd ~/.vim_runtime/my_plugins
$ git clone <package_repo>
```

**Install packages**

```sh
cd ~/.vim_runtime/my_plugins \
  && git clone https://github.com/tweekmonster/braceless.vim \
  && git clone --recursive https://github.com/davidhalter/jedi-vim \
  && git clone https://github.com/valloric/vim-indent-guides \
  && git clone https://github.com/asheq/close-buffers.vim \
  && git clone https://github.com/ctrlpvim/ctrlp.vim
```

**Update plugins**

```
cd ~/.vim_runtime/my_plugins

for i in `ls`; do
  cd "$i"
  git pull
  cd ..
done
```


**Remove a plugin**

Simply remove its directory from `~/.vim_runtime/my_plugins`.

### 2. Install package with vim-plug

**Install [vim-plug](https://github.com/junegunn/vim-plug)**

Download plug.vim and put it in the "autoload" directory.

```
curl -fLo ~/.vim_runtime/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

**Install Packages**

Install packages in in vim command:

```
:PlugInstall
```

**Usage**

Add a vim-plug section to your `~/.vimrc` (or `~/.config/nvim/init.vim` for Neovim). Edit `~/.vim_runtime/my_configs.vim` for **Ultimate vimrc** settings:

1. Begin the section with `call plug#begin()`.
2. List the plugins with `Plug` commands.
3. `call plug#end()` to update `&runtimepath` and initialize plugin system.
4. Reload `.vimrc` with `:so %` and `:PlugInstall` to install plugins.

**Commands**

1. `PlugInstall`: Install plugins
2. `PlugUpdate`: Install or update plugins.
3. `PlugClean[!]`: Remove unused directories (bang version will clean without prompt).

### 3. Packages List

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

- Completion `<C-Space>`
- Goto assignments `<leader>g` (typical goto function)
- Goto definitions `<leader>d` (follow identifier as far as possible, includes imports and statements)
- Show Documentation/Pydoc `K` (shows a popup with assignments)
- Renaming `<leader>r`
- Usages `<leader>n` (shows all the usages of a name)
- Open module, e.g. `:Pyimport os` (opens the `os` module)

```
NOTE: subject to change!

let g:jedi#goto_command = "<leader>d"
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#rename_command = "<leader>r"
```

[**Command-T**](https://github.com/wincent/Command-T)

## Misc

- `:so %` to reload `.vimrc`
