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

[VimAwesome](https://vimawesome.com)

Install package with Pathogen:

```sh
$ cd ~/.vim_runtime/my_plugins
$ git clone <package_repo>
```

Install packages

```
$ cd ~/.vim_runtime/my_plugins
$ git clone https://github.com/tweekmonster/braceless.vim
$ git clone --recursive https://github.com/davidhalter/jedi-vim
$ git clone https://github.com/valloric/vim-indent-guides
$ git clone https://github.com/asheq/close-buffers.vim
$ git clone https://github.com/jalvesaq/Nvim-R.git
```

- [braceless.vim](https://github.com/tweekmonster/braceless.vim)
- [jedi-vim](https://github.com/davidhalter/jedi-vim)
- [vim-indent-guides](https://github.com/valloric/vim-indent-guides)
- [close-buffers](https://github.com/asheq/close-buffers.vim)
- [Nvim-R](https://github.com/jalvesaq/Nvim-R)
