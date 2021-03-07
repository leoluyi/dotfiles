# My bash config. Not much to see here
#
# How to check if a program exists from a Bash script?
# https://stackoverflow.com/a/677212/3744499

# Homebrew prefix
command -v brew &>/dev/null && BREW_PREFIX=$(dirname $(dirname $(type -p brew)))  # faster than `BREW_PREFIX=$(brew --prefix)`

# ============ Command prompt =============

# enables color in the terminal bash shell
export CLICOLOR=1
# sets up the color scheme for list
export LSCOLORS=Exgxcxdxbxegedabagacad
# enables color for iTerm
export TERM=xterm-256color

# The various escape codes that we can use to color our prompt.
#   Based on work by woods
#
#   https://gist.github.com/woods/31967
#   https://misc.flogisoft.com/bash/tip_colors_and_formatting

       GRAY='\[\e[0;37m\]'
  DARK_GRAY='\[\e[1;30m\]'
        RED='\[\e[1;31m\]'
      GREEN='\[\e[1;32m\]'
     YELLOW='\[\e[1;33m\]'
       BLUE='\[\e[1;34m\]'
  LIGHT_RED='\[\e[1;31m\]'
LIGHT_GREEN='\[\e[1;32m\]'
      WHITE='\[\e[1;37m\]'
 LIGHT_GRAY='\[\e[1;37m\]'
       BOLD='\[\e[1m\]'
      RESET='\[\e[0m\]'

#         RED="$(tput setaf 1)"
#       GREEN="$(tput setaf 2)"
#      YELLOW="$(tput setaf 3)"
#        BLUE="$(tput setaf 4)"
#        GRAY="$(tput setaf 8)"
#   LIGHT_RED="$(tput setaf 9)"
# LIGHT_GREEN="$(tput setaf 10)"
#       WHITE="$(tput setaf 15)"
#  LIGHT_GRAY="$(tput setaf 7)"
#        BOLD="$(tput bold)"
#       RESET="$(tput sgr 0)"

PS1="${BOLD}${YELLOW}\u${RESET}${BOLD}@${GREEN}\h:${RESET} ${BOLD}${BLUE}\w${RESET}\n${GRAY}\A ${RESET}\$ "

# ============ Load the shell dotfiles ============
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don't want to commit.
for file in ~/.{bash_aliases*,bash_env,path,bash_prompt,exports,aliases,utils*,extra}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.

# ============ Aliases =============

# Always use color output for `ls`
if command -v gls &>/dev/null; then
  alias ls='${BREW_PREFIX}/bin/gls ${colorflag} --group-directories-first'
else
  alias ls='command ls ${colorflag}'
fi

# sets up proper alias commands when called
alias ll='ls -lvhaF'
alias la='ls -A'
alias l='ls -CF'

# Always enable colored `grep` output
# Note: `GREP_OPTIONS="--color=auto"` is deprecated, hence the alias usage.
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# More information for pager
alias less='less -M -i --underline-special'

# ============ GNU bins ============
# Use these commands with their normal names, you
# can add a "gnubin" directory to your PATH from your bashrc like:
GNU_UTILS=("coreutils" "findutils" "grep" "gnu-sed" "gawk" "gnu-tar" "gnu-indent")
for GNU_UTIL in "${GNU_UTILS[@]}";do
  if [ -d "${BREW_PREFIX}/opt" ]; then
    export PATH="${BREW_PREFIX}/opt/${GNU_UTIL}/libexec/gnubin:$PATH"
    export MANPATH="${BREW_PREFIX}/opt/${GNU_UTIL}/libexec/gnuman:$MANPATH"
  fi
done
unset GNU_UTILS

# Enable color support of ls.
# Detect which `ls` flavor is in use
if ls --color &>/dev/null; then # GNU `ls`
  colorflag="--color"
  # export LS_COLORS='no=00:fi=00:di=01;31:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
else # macOS `ls`
  colorflag="-G"
fi

# ============ Completions ============

# bash completion
# https://github.com/scop/bash-completion
if command -v brew &>/dev/null && [ -r "${BREW_PREFIX}/etc/profile.d/bash_completion.sh" ]; then
  # bash-completion@2
  # Ensure existing Homebrew v1 completions continue to work
  export BASH_COMPLETION_COMPAT_DIR="${BREW_PREFIX}/etc/bash_completion.d";
  source "${BREW_PREFIX}/etc/profile.d/bash_completion.sh";
elif [ -f ${BREW_PREFIX}/etc/bash_completion ]; then
  # Bash Completion v1 (Deprecated)
  source ${BREW_PREFIX}/etc/bash_completion;
elif [ -f /etc/bash_completion ]; then
  source /etc/bash_completion
fi;

# pipenv completion
command -v pipenv &>/dev/null && eval "$(pipenv --completion)"

# pipx completion
if [ $(command -v register-python-argcomplete &>/dev/null) ] && [ $(command -v pipx &>/dev/null) ]; then
  eval "$(register-python-argcomplete pipx)"
fi

# ============ CLI tools ============

# bash-git-prompt.
# https://github.com/magicmonty/bash-git-prompt#via-homebrew-on-mac-os-x
if command -v brew &>/dev/null && [ -f "${BREW_PREFIX}/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR=${BREW_PREFIX}/opt/bash-git-prompt/share
  GIT_PROMPT_ONLY_IN_REPO=1
  source "${BREW_PREFIX}/opt/bash-git-prompt/share/gitprompt.sh"
  #GIT_PROMPT_START='\[\e]0;\u@\h:\w\a\]\[\e[01;32m\]\u@\h\[\e[00m\]:\[\e[01;34m\]\w\[\e[0m\]'

  if grep -q 'GIT_PROMPT_THEME_NAME="Custom"' ~/.git-prompt-colors.sh 2>/dev/null ; then
    GIT_PROMPT_THEME=Custom
  fi
fi

# The fuck.
command -v thefuck &>/dev/null && eval "$(thefuck --alias)"

# pyenv.
command -v pyenv &>/dev/null && \
  eval "$(pyenv init -)" && \
  eval "$(pyenv virtualenv-init -)"
export PYENV_VIRTUALENV_DISABLE_PROMPT=0

# jenv.
command -v jenv &>/dev/null && \
  export PATH="$HOME/.jenv/bin:$PATH" && \
  eval "$(jenv init -)"

# fzf - Ripgrep solution that shows hidden files but ignore .git folder
if command -v fzf &>/dev/null && command -v rg &>/dev/null; then
  export FZF_DEFAULT_COMMAND="rg --files --hidden -g '!.git'"
else
  export FZF_DEFAULT_COMMAND="find . -type f -not -path '*/\.git/*' -not -regex '.*\(\.pyc\|\.o\|\.obj\|\.svn\|\.swp\|\.class\|\.hg\|\.DS_Store\|\.min\..*\)'"
fi

# fzf - Fuzzy completion for bash and zsh.
if [ -f "$HOME"/.fzf.bash ]; then
  source "$HOME"/.fzf.bash

  command -v bat &>/dev/null && \
    export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=header,grid,numbers --line-range :300 {} 2>/dev/null || file --mime {}'"

  # Use fd (https://github.com/sharkdp/fd) instead of the default find
  # command for listing path candidates.
  # - The first argument to the function ($1) is the base path to start traversal
  # - See the source code (completion.{bash,zsh}) for the details.
  if command -v fd &>/dev/null; then
    _fzf_compgen_path() {
      fd --hidden --follow --exclude ".git" . "$1"
    }

    # Use fd to generate the list for directory completion
    _fzf_compgen_dir() {
      fd --type d --hidden --follow --exclude ".git" . "$1"
    }
  fi
fi

# Git diff-so-fancy.
# https://github.com/so-fancy/diff-so-fancy
if command -v diff-so-fancy &>/dev/null; then
  function gd() {
    git diff --color "$@" | diff-so-fancy | less --tabs=4 -RFX
  }
fi

# ============ Env ============
# Use nvim as default editor.
if command -v nvim &>/dev/null; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi

# Set "most" as pager.
command -v most &>/dev/null && export PAGER=most

# Enable syntax-highlighting in less.
# brew install source-highlight
if command -v src-hilite-lesspipe.sh &>/dev/null; then
  # Pipe Highlight to less.
  export LESSOPEN="| $(which src-hilite-lesspipe.sh) %s"
  export LESS=" -R "
fi

# Enable syntax-highlighting in less.
if command -v highlight &>/dev/null; then
  # Pipe Highlight to less
  export LESSOPEN="| $(which highlight) %s --out-format xterm256 --quiet --force --base16=gruvbox-dark-pale"
  export LESS=" -R "
fi

# Fix pyenv bug from git-core. (shims do not work with gettext)
# https://github.com/pyenv/pyenv/issues/688#issuecomment-316237422
export GIT_INTERNAL_GETTEXT_TEST_FALLBACKS=1

# env for pipenv.
export PIPENV_IGNORE_VIRTUALENVS=1

# ============ Path for binaries ============
# User specific environment and startup programs
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# Poetry.
# https://python-poetry.org/docs/
export PATH="$HOME/.poetry/bin:$PATH"

# R Framework
[ -d "/Library/Frameworks/R.framework/Resources" ] && export PATH="/Library/Frameworks/R.framework/Resources:$PATH"

# ============ NVM ===========
export NVM_DIR="$HOME/.nvm"
[ -s "$BREW_PREFIX/opt/nvm/nvm.sh" ] && . "$BREW_PREFIX/opt/nvm/nvm.sh"  # This loads nvm
[ -s "$BREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && . "$BREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# ============ Footer ============
# Set locale to fix ssh forwarding problem.
# https://askubuntu.com/a/144448
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# command -v neofetch &>/dev/null && neofetch --size 30% --iterm2
# command -v neofetch &>/dev/null \
#   && [ -f "$HOME/.config/ascii/batman.ascii" ] \
#   && neofetch --source "$HOME/.config/ascii/batman.ascii"
