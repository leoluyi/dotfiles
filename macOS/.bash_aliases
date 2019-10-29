# Enable aliases to be sudo'ed
alias sudo='sudo '

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
alias du='du -kh'
alias df='df -kTh'
alias free='free -h'
alias less='less -r'

# subl + pipenv virtualenv
(command -v pipenv &>/dev/null) && \
  (command -v subl &>/dev/null) && \
  alias subl-pipenv='pipenv --venv && pipenv run subl'

# youtube-dl
(command -v youtube-dl &>/dev/null) && \
  && alias youtube-dl-list='youtube-dl -ci -f mp4 -o "%(playlist_index)s-%(title)s.%(ext)s" --yes-playlist' \
  && alias youtube-dl-mp4='youtube-dl -f mp4' \
  && alias youtube-dl-m4a='youtube-dl -f bestaudio[ext=m4a] --embed-thumbnail --add-metadata' \

# Other Apps
alias sourcetree='open -a SourceTree'
