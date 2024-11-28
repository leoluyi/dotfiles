# My bash config. Not much to see here
#
# How to check if a program exists from a Bash script?
# https://stackoverflow.com/a/677212/3744499

# Detect M1 chip.
if [ "$(uname -m)" = 'arm64' ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  # Homebrew prefix. Faster than `HOMEBREW_PREFIX=$(brew --prefix)`
  command -v brew >/dev/null && export HOMEBREW_PREFIX="$(dirname "$(dirname "$(type -p brew)")")"
fi

export BASH_SILENCE_DEPRECATION_WARNING=1

# ============ Command prompt =============

# enables color in the terminal bash shell
export CLICOLOR=1
# sets up the color scheme for list
export LSCOLORS=Exgxcxdxbxegedabagacad
# enables color for iTerm
export TERM=xterm-256color

# A collection of LS_COLORS definitions.
# https://www.nordtheme.com/docs/ports/dircolors/installation
command -v gdircolors >/dev/null && [ -r "$HOME/.config/dir_colors" ] && eval "$(gdircolors -b "$HOME/.config/dir_colors")"

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

# ============ GNU bins ============
# Use these commands with their normal names, you
# can add a "gnubin" directory to your PATH from your bashrc like:
GNU_UTILS=("coreutils" "findutils" "grep" "gnu-sed" "gawk" "gnu-tar" "gnu-indent")
for GNU_UTIL in "${GNU_UTILS[@]}";do
  if [ -d "${HOMEBREW_PREFIX}/opt" ]; then
    export PATH="${HOMEBREW_PREFIX}/opt/${GNU_UTIL}/libexec/gnubin:$PATH"
    export MANPATH="${HOMEBREW_PREFIX}/opt/${GNU_UTIL}/libexec/gnuman:$MANPATH"
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

# Always use color output for `ls`
if command -v gls >/dev/null; then
  alias ls='${HOMEBREW_PREFIX}/bin/gls ${colorflag} --group-directories-first'
else
  alias ls='command ls ${colorflag}'
fi

# ============ Completions ============

# bash completion
# https://github.com/scop/bash-completion
if command -v brew >/dev/null && [ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]; then
  # bash-completion@2
  # Ensure existing Homebrew v1 completions continue to work
  export BASH_COMPLETION_COMPAT_DIR="${HOMEBREW_PREFIX}"/etc/bash_completion.d;
  source "${HOMEBREW_PREFIX}"/etc/profile.d/bash_completion.sh;
elif [ -r "${HOMEBREW_PREFIX}"/etc/bash_completion ]; then
  # Bash Completion v1 (Deprecated)
  source "${HOMEBREW_PREFIX}"/etc/bash_completion;
elif [ -r /etc/bash_completion ]; then
  source /etc/bash_completion
fi;

# ============ Promt ============

if command -v starship >/dev/null; then
  # starship prompt
  eval "$(starship init bash)"
elif [ -f "${HOMEBREW_PREFIX}/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  # bash-git-prompt.
  # https://github.com/magicmonty/bash-git-prompt#via-homebrew-on-mac-os-x
  __GIT_PROMPT_DIR=${HOMEBREW_PREFIX}/opt/bash-git-prompt/share
  GIT_PROMPT_ONLY_IN_REPO=1
  #GIT_PROMPT_START='\[\e]0;\u@\h:\w\a\]\[\e[01;32m\]\u@\h\[\e[00m\]:\[\e[01;34m\]\w\[\e[0m\]'

  if grep -q 'GIT_PROMPT_THEME_NAME="Custom"' ~/.git-prompt-colors.sh 2>/dev/null ; then
    GIT_PROMPT_THEME=Custom
  fi
  source "${HOMEBREW_PREFIX}/opt/bash-git-prompt/share/gitprompt.sh"
fi

# ============ Path for binaries ============
# User specific environment and startup programs
export PATH="$HOME/.local/bin:$HOME/bin:$HOME/.scripts:$PATH"

# ============ Load the shell dotfiles ============
# * You may want to put all your additions into a separate file like
#   ~/.bash_aliases, instead of adding them here directly.
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don't want to commit.
# * issue(fzf): # fzf must come after `bash_completion.sh`, it appears to
#   remove the cd completion.
#   < https://github.com/junegunn/fzf/issues/872#issuecomment-721933250 >

for file in "$HOME"/.config/{bash/*,*aliases*,*env,path,bash_prompt,exports,utils*,extra}; do
  [ -f "$file" ] && [ -r "$file" ] && source "$file";
done;

# Load secrets.
if [ -d "$HOME/.secrets" ]; then
  for secret in "$HOME"/.secrets/*; do
    [ -f "$secret" ] && [ -r "$secret" ] && source "$secret"
  done
fi

# ============ Footer ============
# Set locale to fix ssh forwarding problem.
# https://askubuntu.com/a/144448
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# command -v neofetch &>/dev/null && neofetch --size 30% --iterm2
# command -v neofetch &>/dev/null \
#   && [ -r "$HOME/.config/ascii/batman.ascii" ] \
#   && neofetch --source "$HOME/.config/ascii/batman.ascii"
