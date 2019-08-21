# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# if not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# see bash(1) for more options
histcontrol=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see histsize and histfilesize in bash(1)
histsize=1000
histfilesize=2000

# check the window size after each command and, if necessary,
# update the values of lines and columns.
shopt -s checkwinsize

# if set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(shell=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$term" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # we have color support; assume it's compliant with ecma-48
    # (iso/iec-6429). (lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    ps1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\n\$ '
else
    ps1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# if this is an xterm set the title to user@host:dir
case "$term" in
xterm*|rxvt*)
    ps1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$ps1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto --group-directories-first'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored gcc warnings and errors
#export gcc_colors='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -lhaFH'
alias la='ls -a'
alias l='ls -cf'

# add an "alert" alias for long running commands.  use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# alias definitions.
# you may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# see /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# ============ Custom functions ============

function mkcd {
  last=$(eval "echo \$$#")
  if [ -z "$last" ]; then
    echo "Enter a directory name"
  elif [ -d "$last" ]; then
    echo "\"$last\" already exists"
  else
    mkdir "$@" && cd "$last" || exit
  fi
}

# gitignore api
function gi() { curl -L -s https://www.gitignore.io/api/"$1" ;}

# ============ CLI tools ============

# bash-git-prompt
# https://github.com/magicmonty/bash-git-prompt#via-homebrew-on-mac-os-x
if [ -f ~/.bash-git-prompt/gitprompt.sh ]; then
  source ~/.bash-git-prompt/gitprompt.sh
  GIT_PROMPT_ONLY_IN_REPO=0
  GIT_PROMPT_THEME=Custom
fi

# pyenv
export PATH=~/".pyenv/bin:$PATH"
command -v pyenv >/dev/null 2>&1 && \
  eval "$(pyenv init -)" && \
  eval "$(pyenv virtualenv-init -)"

# pipenv completion
command -v pipenv >/dev/null 2>&1 && eval "$(pipenv --completion)"

# subl + pipenv virtualenv
(command -v pipenv >/dev/null) && \
  (command -v subl >/dev/null) && \
  alias subl-pipenv='pipenv --venv && pipenv run subl'

# fzf
[ -f ~/.fzf.bash ] && \
  source ~/.fzf.bash && \
  export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=header,grid,numbers --line-range :300 {} 2>/dev/null || file --mime {}'"

# tmux completion
if [ -f /usr/share/bash-completion/tmux_completion ]; then
  source /usr/share/bash-completion/tmux_completion
fi

# Git diff-so-fancy
# https://github.com/so-fancy/diff-so-fancy
if command -v diff-so-fancy >/dev/null 2>&1; then
  function gd() {
    git diff --color "$@" | diff-so-fancy | less --tabs=4 -RFX
  }
fi

# ============ Misc ============

# Fix pyenv bug for git
# https://github.com/pyenv/pyenv/issues/688#issuecomment-316237422
export GIT_INTERNAL_GETTEXT_TEST_FALLBACKS=1

# env for pipenv
export PIPENV_IGNORE_VIRTUALENVS=1

# Homebrew
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

# MS-SQL
export PATH="$PATH:/opt/mssql-tools/bin"

# Dropbox
dropbox start > /dev/null 2>&1

# Disable Ctrl-s Software Flow Control
stty -ixon

# Proxy
# export http_proxy="8.8.8.8"
# export https_proxy=$http_proxy
# export HTTP_PROXY=$http_proxy
# export HTTPS_PROXY=$http_proxy
export no_proxy="localhost,127.0.0.1"
