#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")" || return;

CURRENT_DIR=$(pwd)

echo "###### Install Homebrew ######"

if command -v brew >/dev/null; then
  # Make sure we're using the latest Homebrew.
  echo "Updating Homebrew ..."
  brew update

  # Save Homebrew's installed location.
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
diff-so-fancy \
ffmpeg \
findutils `# GNU find, locate, updatedb, and xargs, g-prefixed` \
gcc \
gdal \
git \
gnupg \
gnu-sed \
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

# Switch to using brew-installed bash as default shell
if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "${BREW_PREFIX}/bin/bash";
fi;

# Remove outdated versions from the cellar.
brew cleanup


echo "###### Fix Bash Completion ######"
# https://dwatow.github.io/2018/09-21-git-cmd-auto-complete/
# 用 brew 安裝 git，
# 安裝完 bash 會自動指向 brew 安裝的路徑，
# 確定版本之後，要去 github 找 git-completion.bash，並且，找到與你的 git 匹配的 版本。

# Git completion

if command -v brew >/dev/null; then
    BASH_COMPLETION_COMPAT_DIR="$(brew --prefix)/etc/bash_completion.d"
    curl -fsSLo "${BASH_COMPLETION_COMPAT_DIR}"/git-completion.bash https://raw.github.com/git/git/master/contrib/completion/git-completion.bash
fi

# Docker completion
if [ -w "${BASH_COMPLETION_COMPAT_DIR}" ]; then
  DOCKER_ETC=/Applications/Docker.app/Contents/Resources/etc
  ln -sf "${DOCKER_ETC}/docker.bash-completion" "${BASH_COMPLETION_COMPAT_DIR}"/docker
  ln -sf "${DOCKER_ETC}/docker-machine.bash-completion" "${BASH_COMPLETION_COMPAT_DIR}"/docker-machine
  ln -sf "${DOCKER_ETC}/docker-compose.bash-completion" "${BASH_COMPLETION_COMPAT_DIR}"/docker-compose
else
  echo "Docker is not installed."
fi

echo "###### Virtualenv Integration with Sublime Text ######"

mkdir -p ~/.local/share/virtualenvs
VENV_FOLDER="${HOME}/.virtualenvs"

[[ -L "$VENV_FOLDER" && -d "$VENV_FOLDER" ]] || ln -sf ~/.local/share/virtualenvs "$VENV_FOLDER"

echo "###### Sublime Text Settings ######"

ln -sf "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin

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

  cd ~/.vim_runtime/my_plugins || return
  git clone https://github.com/tweekmonster/braceless.vim
  git clone --recursive https://github.com/davidhalter/jedi-vim
  git clone https://github.com/valloric/vim-indent-guides
  git clone https://github.com/asheq/close-buffers.vim
  git clone https://github.com/ctrlpvim/ctrlp.vim
  cd "${CURRENT_DIR}" || return

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
  cp git/gitignore_global ~/.gitignore_global
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
  read -rp "This may overwrite existing files in your home directory. Are you sure? (y/N) " -n 1;
  echo "";
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    sync_dotfile;
  fi;
fi;
unset sync_dotfile;

echo "###### Source Bash Settings ######"

source ~/.bash_profile;
