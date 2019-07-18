#!/usr/bin/env bash

# Install command-line tools using Homebrew.

echo "###### Install Homebrew ######"

if [ -x "$(command -v brew)" ]; then
  # Make sure we're using the latest Homebrew.
  echo "Updating Homebrew ..."
  brew update

  # Save Homebrew’s installed location.
  BREW_PREFIX=$(brew --prefix)
else
  echo "Installing Hombrew ..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "###### Install Apps with Homebrew ######"

brew tap caskroom/cask && \
brew tap homebrew/cask-fonts && \
brew cask install \
firefox \
font-meslo-for-powerline \
google-chrome \
iina \
iterm2 \
jupyter-notebook-viewer \
xquartz \
qlimagesize qlcolorcode qlstephen qlmarkdown quicklook-json webpquicklook suspicious-package quicklookase qlvideo \
2>/dev/null;

echo "###### Install CLI with Homebrew ######"

brew install \
asciinema     `# record terminal sessions` \
atomicparsley `# setting metadata into MPEG-4` \
bash \
bash-completion@2 \
bash-git-prompt \
bfg \
cmatrix \
coreutils `# Dont forget to add $(brew --prefix coreutils)/libexec/gnubin to $PATH` \
czmq \
ffmpeg \
findutils `# GNU find, locate, updatedb, and xargs, g-prefixed` \
gcc \
gdal \
git \
gnupg \
gnu-sed --with-default-names \
grep \
grip \
highlight \
htop-osx \
john-jumbo `# password crack` \
libpng \
libsvg \
libxml2 \
libzip \
moreutils  `# Some other useful utilities like sponge` \
npm \
openssl \
p7zip \
pdfcrack   `# pdf password crack` \
peco       `# Simplistic interactive filtering tool` \
pip-completion \
pipenv \
plowshare  `# 免空神器` \
proj \
pyenv \
pyenv-virtualenv \
rename \
shellcheck \
ssh-copy-id \
terminal-notifier \
thefuck \
tldr \
tmux \
tree \
vim --with-override-system-vi \
wget \
ydiff \
youtube-dl \
2>/dev/null

ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Switch to using brew-installed bash as default shell
if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "${BREW_PREFIX}/bin/bash";
fi;


# Remove outdated versions from the cellar.
brew cleanup
