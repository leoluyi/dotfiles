#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")" || return;

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
  cp tmux/tmux.conf.local ${HOME}/.tmux.conf.local
  cp git/gitconfig ${HOME}/.gitconfig
  cp vim/vim_runtime/my_configs.vim ${HOME}/.vim_runtime/my_configs.vim
  cp bash-git-prompt/git-prompt-colors.sh ${HOME}/.git-prompt-colors.sh
}

if [ "$1" == "--force" ] || [ "$1" == "-f" ]; then
  sync_dotfile;
else
  read -rp "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
  echo "";
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    sync_dotfile;
  fi;
fi;
unset sync_dotfile;

echo "###### Install Homebrew ######"

if [ -x "$(command -v brew)" ]; then
  echo "Updating Homebrew ..."
  brew update
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
bash \
bash-completion \
bash-git-prompt \
git \
gnupg \
grep \
htop-osx \
openssl \
peco       `# Simplistic interactive filtering tool` \
pip-completion \
pipenv \
pyenv \
pyenv-virtualenv \
rename \
thefuck \
tldr \
tmux \
tree \
vim \
wget \
2>/dev/null

echo "###### Fix Bash Completion ######"
# https://dwatow.github.io/2018/09-21-git-cmd-auto-complete/
# 用 brew 安裝 git，
# 安裝完 bash 會自動指向 brew 安裝的路徑，
# 確定版本之後，要去 github 找 git-completion.bash，並且，找到與你的 git 匹配的 版本。

old_dir=$(pwd)
cd $(brew --prefix)/opt/bash-completion/etc/bash_completion.d || return

# Git completion
curl -s -L -O https://raw.github.com/git/git/master/contrib/completion/git-completion.bash
brew unlink bash-completion
brew link bash-completion

# Docker
if [ -x "$(command -v docker)" ]; then
  etc=/Applications/Docker.app/Contents/Resources/etc
  ln -s -f $etc/docker.bash-completion $(brew --prefix)/etc/bash_completion.d/docker
  ln -s -f $etc/docker-machine.bash-completion $(brew --prefix)/etc/bash_completion.d/docker-machine
  ln -s -f $etc/docker-compose.bash-completion $(brew --prefix)/etc/bash_completion.d/docker-compose
else
  echo "Docker is not installed."
fi

cd "${old_dir}" || return

echo "###### Virtualenv Settings ######"

mkdir -p "${HOME}/.local/share/virtualenvs/"
ln -s -f "${HOME}/.local/share/virtualenvs/" "${HOME}/.virtualenvs"

echo "###### Sublime Text Settings ######"

ln -s -f "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin

echo "###### Tmux Settings ######"

if [ ! -d "${HOME}/.tmux" ]; then
  git clone https://github.com/gpakosz/.tmux.git "${HOME}/.tmux"
  cp tmux/tmux.conf "${HOME}/.tmux/.tmux.conf"
  ln -s -f "${HOME}/.tmux/.tmux.conf" "${HOME}/.tmux.conf"
else
  echo ".tmux is already installed."
fi

echo "###### Install Awesome Vim ######"

if [ ! -d "${HOME}/.vim_runtime" ]; then
  git clone --depth=1 https://github.com/amix/vimrc.git "${HOME}/.vim_runtime"
  bash ~/.vim_runtime/install_awesome_vimrc.sh

  echo "Installing Vim Packages ..."

  old_dir=$(pwd)
  cd ~/.vim_runtime/my_plugins || return
  git clone https://github.com/tweekmonster/braceless.vim
  git clone --recursive https://github.com/davidhalter/jedi-vim
  git clone https://github.com/valloric/vim-indent-guides
  git clone https://github.com/asheq/close-buffers.vim
  git clone https://github.com/ctrlpvim/ctrlp.vim
  cd "${old_dir}" || return
else
  echo "Awesome Vim is already installed."
fi

echo "###### Source Bash Settings ######"

source "${HOME}/.bash_profile";
