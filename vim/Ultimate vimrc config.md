# The Ultimate vimrc 

https://github.com/amix/vimrc

## How to install the Awesome version

**Install for your own user only**

The awesome version includes a lot of great plugins, configurations and color schemes that make Vim a lot better. To install it simply do following from your terminal:

```sh
$ git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
$ sh ~/.vim_runtime/install_awesome_vimrc.sh
```

**Install for multiple users**

To install for multiple users, the repository needs to be cloned to a location accessible for all the intended users.

```sh
$ git clone --depth=1 https://github.com/amix/vimrc.git /opt/vim_runtime
$ sh ~/.vim_runtime/install_awesome_parameterized.sh /opt/vim_runtime user0 user1 user2

# to install for all users with home directories
$ sh ~/.vim_runtime/install_awesome_parameterized.sh /opt/vim_runtime --all
```

## How to uninstall

Just do following:

- Remove `~/.vim_runtime`
- Remove any lines that reference `.vim_runtime` in your `~/.vimrc`

