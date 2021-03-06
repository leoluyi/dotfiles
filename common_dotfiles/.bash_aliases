# Enable aliases to be sudo'ed
alias sudo='sudo '

# Neovim
if command -v nvim >/dev/null; then
  alias ovim="command vim"
  alias vi="nvim"
  alias vim="nvim"
  alias view="nvim -R"
  alias vimdiff="nvim -d"
fi

# ls sort by most recently modified.
alias lr='ls -hAltr --time-style=long-iso'

# Just lazy.
alias f='fuck'

# R.
alias R='R --no-save --no-restore'

# Print each PATH entry on a separate line.
alias path='echo -e ${PATH//:/\\n}'

# Shortcuts.
alias d='cd ~/Dropbox'
alias dl='cd ~/Downloads'
alias dt='cd ~/Desktop'

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias work='[ -d ~/_playground_side_projects ] && cd ~/_playground_side_projects'
alias Dropbox='[ -d ~/Dropbox ] && cd ~/Dropbox'
alias temp='[ -d ~/Downloads/.temp ] && cd ~/Downloads/.temp'

# IP addresses.
alias myip='dig +short myip.opendns.com @resolver1.opendns.com'
#alias localip="ipconfig getifaddr en0"
alias myips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Kill all the tabs in Chrome to free up memory.
# [C] explained: http://www.commandlinefu.com/commands/view/402/exclude-grep-from-your-grepped-output-of-ps-alias-included-in-description
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"

# Fancy commands output.
alias du='du -k'
alias df='df -kT'
alias free='free -h'
alias less='less -r'

# Find the largest top 10 files and directories.
alias ducks='du -cksh -- * | sort -rh | head'

# subl + pipenv virtualenv.
(command -v pipenv >/dev/null) && (command -v subl >/dev/null) \
  && alias subl-pipenv='pipenv --venv && pipenv run subl'

# youtube-dl.
(command -v youtube-dl >/dev/null) \
  && alias youtube-dl-mp4='youtube-dl -f "bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/mp4"' \
  && alias youtube-dl-best='youtube-dl -f "bestvideo[height<=1080][ext=mp4]+bestaudio/best[height<=720][ext=mp4]"' \
  && alias youtube-dl-m4a='youtube-dl -f bestaudio[ext=m4a] --embed-thumbnail --add-metadata' \
  && alias youtube-dl-list='youtube-dl -ci -o "%(playlist_index)s-%(title)s.%(ext)s" --yes-playlist' \
  && alias youtube-dl-list-mp4='youtube-dl -ci -o "%(playlist_index)s-%(title)s.%(ext)s" -f "bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/mp4" --yes-playlist'

# Alacritty theme.
(command -v alacritty-colorscheme >/dev/null) \
  && alias light='alacritty-colorscheme -c $HOME/.alacritty.yml -t PaperColor.yaml' \
  && alias dark='alacritty-colorscheme -c $HOME/.alacritty.yml -t gruvbox.yaml' \
  && alias colorlist='alacritty-colorscheme -c $HOME/.alacritty.yml -l' \
  && alias colorapply='alacritty-colorscheme -c $HOME/.alacritty.yml -a'

# tmux.
(command -v tmux >/dev/null) \
  && alias tm='tmux attach || tmux new'

# tty-clock.
(command -v tty-clock >/dev/null) \
  && alias clock='tty-clock -sc -f "%a, %d %b %Y %T %Z%z"'

# matrix.
(command -v cmatrix >/dev/null) \
  && alias matrix='cmatrix'
