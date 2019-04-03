#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";
echo "cd to $(dirname "${BASH_SOURCE}")";

function sync_dotfile() {
  # rsync --exclude ".git/" \
  #   --exclude ".DS_Store" \
  #   --exclude ".osx" \
  #   --exclude "bootstrap.sh" \
  #   --exclude "README.md" \
  #   --exclude "LICENSE-MIT.txt" \
  #   -avh --no-perms macOS/bash_{profile,rc} ~;
  cp git/macOS.gitignore ${HOME}/.gitignore_global
  cp macOS/bash_profile ${HOME}/.bash_profile
  cp macOS/bashrc ${HOME}/.bashrc
  cp tmux/tmux.conf.local .tmux.conf.local
  cp git/gitconfig ${HOME}/.gitconfig
  cp vim/vimrc ${HOME}/.vimrc
  cp vim/vim_runtime/my_configs.vim ${HOME}/.vim_runtime/my_configs.vim
  cp bash-git-prompt/git-prompt-colors.sh ${HOME}/.git-prompt-colors.sh
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
  sync_dotfile;
else
  read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
  echo "";
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    sync_dotfile;
  fi;
fi;
unset sync_dotfile;

echo "###### Install Homebrew ######"

if [[ $(command -v brew) == "" ]]; then
  echo "Installing Hombrew ..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo "Updating Homebrew ..."
    brew update
fi

echo "###### Install Apps with Homebrew ######"

# brew tap caskroom/cask && \
# brew tap homebrew/cask-fonts && \
# brew cask install \
# deckset \
# firefox \
# font-meslo-for-powerline \
# google-chrome \
# iina \
# iterm2 \
# java \
# jupyter-notebook-viewer \
# keycastr \
# macdown \
# obs \
# r \
# rstudio \
# sourcetree \
# spectacle \
# tabula \
# transmission \
# xquartz \
# qlimagesize qlcolorcode qlstephen qlmarkdown quicklook-json webpquicklook suspicious-package quicklookase qlvideo;

echo "###### Install CLI with Homebrew ######"

brew install \
asciinema     `# record terminal sessions` \
atomicparsley `# setting metadata into MPEG-4` \
bash \
bash-completion \
bash-git-prompt \
bfg \
cmatrix \
coreutils \
czmq \
ffmpeg \
gcc \
gdal \
git \
gnupg \
grep \
grip \
highlight \
htop-osx \
john-jumbo `# password crack` \
libpng \
libsvg \
libxml2 \
libzip \
npm \
openssl \
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
terminal-notifier \
thefuck \
tldr \
tmux \
tree \
vim \
wget \
ydiff \
youtube-dl;

echo "###### Virtualenv Settings ######"

mkdir -p ${HOME}/.local/share/virtualenvs/
ln -s -f ${HOME}/.local/share/virtualenvs/ ${HOME}/.virtualenvs

echo "###### Sublime Text Settings ######"

ln -s -f "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin

echo "###### Tmux Settings ######"

git clone https://github.com/gpakosz/.tmux.git "${HOME}/.tmux"
ln -s -f "${HOME}/.tmux/.tmux.conf" "${HOME}/.tmux.conf"

echo "###### Install Awesome Vim ######"

git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
bash ~/.vim_runtime/install_awesome_vimrc.sh

echo "###### Install Vim Packages ######"

old_dir=$(pwd)
cd ~/.vim_runtime/my_plugins \
  && git clone https://github.com/tweekmonster/braceless.vim \
  && git clone --recursive https://github.com/davidhalter/jedi-vim \
  && git clone https://github.com/valloric/vim-indent-guides \
  && git clone https://github.com/asheq/close-buffers.vim \
  && git clone https://github.com/ctrlpvim/ctrlp.vim
cd "${old_dir}";

echo "###### Source Bash Settings ######"

source ${HOME}/.bash_profile;
