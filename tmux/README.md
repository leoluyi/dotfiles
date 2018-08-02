
# tmux settings

## Oh My Tmux!

https://github.com/gpakosz/.tmux

Installation

```sh
$ cd
$ git clone https://github.com/gpakosz/.tmux.git
$ ln -s -f .tmux/.tmux.conf
$ cp .tmux/.tmux.conf.local .
```

## tmux-completion

```sh
# macOS
$ brew install tmux

# Ubuntu
$ sudo wget -O /usr/share/bash-completion/tmux_completion https://github.com/imomaliev/tmux-bash-completion/raw/master/completions/tmux
```

## Set copy-mode-vi

https://sanctum.geek.nz/arabesque/vi-mode-in-tmux/

Add the following line in `~/.tmux/.tmux.conf`

```
# ~/.tmux/.tmux.conf
set-window-option -g mode-keys vi
```
