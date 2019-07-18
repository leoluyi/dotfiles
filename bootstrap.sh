#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")" || return;

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

brew cleanup

echo "###### Fix Bash Completion ######"
# https://dwatow.github.io/2018/09-21-git-cmd-auto-complete/
# 用 brew 安裝 git，
# 安裝完 bash 會自動指向 brew 安裝的路徑，
# 確定版本之後，要去 github 找 git-completion.bash，並且，找到與你的 git 匹配的 版本。

old_dir=$(pwd)
cd $(brew --prefix)/opt/bash-completion/etc/bash_completion.d || return

# Git completion
curl -fsSL -O https://raw.github.com/git/git/master/contrib/completion/git-completion.bash
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

echo "###### Virtualenv Integration with Sublime Text ######"

mkdir -p ~/.local/share/virtualenvs
venv_folder="${HOME}"/.virtualenvs

[[ -L "$venv_folder" && -d "$venv_folder" ]] || ln -sf ~/.local/share/virtualenvs "${venv_folder}"

echo "###### Sublime Text Settings ######"

ln -s -f "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin

echo "###### Tmux Settings ######"

if [ ! -d ~/.tmux ]; then
  git clone https://github.com/gpakosz/.tmux.git ~/.tmux
  ln -sf ~/.tmux/.tmux.conf ~/.tmux.conf
else
  echo ".tmux awesome is already installed."
fi

if [ ! -d ~/.tmux/plugins/tpm ]; then
  echo "Installing tmux plugins manager ..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm \
    && cp tmux/tmux.conf.local ~/.tmux.conf.local \
    && ~/.tmux/plugins/tpm/bin/install_plugins
else
  ~/.tmux/plugins/tpm/bin/install_plugins
fi

echo "###### Install Awesome Vim ######"

if [ ! -d ~/.vim_runtime ]; then
  git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
  bash ~/.vim_runtime/install_awesome_vimrc.sh

  echo "Installing Vim Packages with Pathogen..."

  old_dir=$(pwd)
  cd ~/.vim_runtime/my_plugins || return
  git clone https://github.com/tweekmonster/braceless.vim
  git clone --recursive https://github.com/davidhalter/jedi-vim
  git clone https://github.com/valloric/vim-indent-guides
  git clone https://github.com/asheq/close-buffers.vim
  git clone https://github.com/ctrlpvim/ctrlp.vim
  cd "${old_dir}" || return
  
  echo "Installing Vim Packages with vim-plug ..."
  curl -fLo ~/.vim_runtime/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
else
  echo "Awesome Vim is already installed."
fi

echo "###### sync_dotfile ######"

function sync_dotfile() {
  # rsync --exclude ".git/" \
  #   --exclude ".DS_Store" \
  #   --exclude ".osx" \
  #   --exclude "bootstrap.sh" \
  #   --exclude "README.md" \
  #   --exclude "LICENSE-MIT.txt" \
  #   -avh --no-perms macOS/bash_{profile,rc} ~;
  cp git/macOS.gitignore ~/.gitignore_global
  cp macOS/bash_profile ~/.bash_profile
  cp macOS/bashrc ~/.bashrc
  cp tmux/tmux.conf.local ~/.tmux.conf.local
  cp git/gitconfig ~/.gitconfig
  cp vim/vim_runtime/my_configs.vim ~/.vim_runtime/my_configs.vim
  cp bash-git-prompt/git-prompt-colors.sh ~/.git-prompt-colors.sh
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

echo "###### Source Bash Settings ######"

source ~/.bash_profile;
