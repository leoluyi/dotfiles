# Enable aliases to be sudo'ed
alias sudo='sudo '

# Neovim
if command -v nvim &>/dev/null; then
  alias ovim="command vim"
  alias vim="nvim"
  alias vi="nvim"
fi

# R
alias R='R --no-save --no-restore'

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

# Shortcuts
alias d='cd ~/Dropbox'
alias dl='cd ~/Downloads'
alias dt='cd ~/Desktop'

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# IP addresses
alias myip='dig +short myip.opendns.com @resolver1.opendns.com'
#alias localip="ipconfig getifaddr en0"
alias myips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Kill all the tabs in Chrome to free up memory
# [C] explained: http://www.commandlinefu.com/commands/view/402/exclude-grep-from-your-grepped-output-of-ps-alias-included-in-description
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"

# Fancy commands output
alias du='du -k'
alias df='df -kT'
alias free='free -h'
alias less='less -r'

# subl + pipenv virtualenv.
(command -v pipenv &>/dev/null) && \
  (command -v subl &>/dev/null) && \
  alias subl-pipenv='pipenv --venv && pipenv run subl'

# youtube-dl
(command -v youtube-dl &>/dev/null) \
  && alias youtube-dl-mp4='youtube-dl -f mp4 -f "bestvideo[height<=720][ext=mp4]+bestaudio/best[height<=720][ext=mp4]"' \
  && alias youtube-dl-m4a='youtube-dl -f bestaudio[ext=m4a] --embed-thumbnail --add-metadata' \
  && alias youtube-dl-list='youtube-dl-mp4 -ci -f mp4 -o "%(playlist_index)s-%(title)s.%(ext)s" --yes-playlist'

# ====== MacOS only ======

# FZF

# Install (one or multiple) selected application(s)
# using "brew search" as source input
# mnemonic [B]rew [I]nstall [P]lugin
bip() {
  local inst=$(brew search | fzf -m)

  if [[ $inst ]]; then
    for prog in $inst; do
      brew install "$prog"
    done
  fi
}

# Update (one or multiple) selected application(s)
# mnemonic [B]rew [U]pdate [P]lugin
bup() {
  local upd=$(brew leaves | fzf -m)

  if [[ $upd ]]; then
    for prog in $upd; do
      brew upgrade "$prog"
    done
  fi
}

# Delete (one or multiple) selected application(s)
# mnemonic [B]rew [C]lean [P]lugin (e.g. uninstall)
bcp() {
  local uninst=$(brew leaves | fzf -m)

  if [[ $uninst ]]; then
    for prog in $uninst; do
      brew uninstall "$prog"
    done
  fi
}

# Install or open the webpage for the selected application
# using brew cask search as input source
# and display a info quickview window for the currently marked application
brew-cask-install() {
    local token
    token=$(brew search --casks | fzf-tmux --query="$1" +m --preview 'brew cask info {}')

    if [ "x$token" != "x" ]
    then
        echo "(I)nstall or open the (h)omepage of $token"
        read -r input
        if [ "$input" = "i" ] || [ "$input" = "I" ]; then
            brew cask install "$token"
        fi
        if [ "$input" = "h" ] || [ "$input" = "H" ]; then
            brew cask home "$token"
        fi
    fi
}

# Uninstall or open the webpage for the selected application
# using brew list as input source (all brew cask installed applications)
# and display a info quickview window for the currently marked application
brew-cask-uninstall() {
    local token
    token=$(brew cask list | fzf-tmux --query="$1" +m --preview 'brew cask info {}')

    if [ "x$token" != "x" ]
    then
        echo "(U)ninstall or open the (h)omepage of $token"
        read -r input
        if [ "$input" = "u" ] || [ "$input" = "U" ]; then
            brew cask uninstall "$token"
        fi
        if [ "$input" = "h" ] || [ "$token" = "h" ]; then
            brew cask home "$token"
        fi
    fi
}

# Other Apps
alias sourcetree='open -a SourceTree'
