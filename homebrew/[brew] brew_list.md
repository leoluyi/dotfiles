# Homebrew Package List

### Install packages

```bash
brew install \
ag \
asciinema     `# record terminal sessions` \
atomicparsley `# setting metadata into MPEG-4` \
autopep8 \
bash \
bash-completion@2 \
bash-git-prompt \
bat \
bfg \
brew install \
cmatrix \
coreutils `# Dont forget to add $(brew --prefix coreutils)/libexec/gnubin to $PATH` \
czmq \
diff-so-fancy \
fd \
ffmpeg \
figlet    `# Banner-like program prints strings as ASCII art` \
findutils `# GNU find, locate, updatedb, and xargs, g-prefixed` \
flake8 \
gcc \
gdal \
git \
gnu-sed --with-default-names \
gnu-tar \
gnupg \
grep \
grip \
highlight \
htop-osx \
john-jumbo `# password crack` \
jq \
libpng \
libsvg \
libxml2 \
libzip \
more \
moreutils  `# Some other useful utilities like sponge` \
neofetch \
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
qpdf       `# pdf-to-pdf tool (remove pdf password)` \
ranger     `# a terminal browser for Vim` \
rename \
ripgrep \
shellcheck \
ssh-copy-id \
terminal-notifier \
thefuck \
tldr \
tmux \
tree \
unrar \
vim --with-override-system-vi \
wget \
ydiff \
youtube-dl \
2>/dev/null

# Install other useful binaries.
brew tap eddieantonio/eddieantonio && brew install imgcat
brew tap jesseduffield/lazydocker && brew install lazydocker

# Spreadsheet Calculator Improvised
brew tap nickolasburr/pfa
brew install sc-im
```

### Using homebrew

Update

```bash
$ brew update && brew upgrade
```

List Installed Packages

```bash
$ brew list
```

---------------------------------------------

## brew cask

### Cask list

```bash
# Tap cask GitHub repositories
brew tap caskroom/cask
brew tap homebrew/cask-fonts

# Install apps
brew cask install \
`# dash` \
betterzip \
deckset \
docker \
firefox \
font-meslo-for-powerline \
font-hack-nerd-font \
google-chrome \
google-drive-file-stream \
iina \
iterm2 \
java \
jupyter-notebook-viewer \
keycastr \
`#macdown` \
mounty \
obs \
r \
rstudio \
sourcetree \
spectacle \
tabula \
transmission \
typora \
welly \
xquartz \
qlimagesize qlcolorcode qlstephen qlmarkdown quicklook-json webpquicklook suspicious-package quicklookase qlvideo
```

**Install [qlImageSize](https://github.com/L1cardo/qlImageSize) manually**

1. Download the file from [here](https://github.com/Nyx0uf/qlImageSize/releases/tag/2.6.1)
2. Unzip the file you have just downloaded and you will get a file named `qlImageSize.qlgenerator`
3. Copy the `qlImageSize.qlgenerator` to the `/Users/<your-user-name>/Library/QuickLook⁩/` (You may need a password permission)
4. Launch `Terminal.app` and run `qlmanage -r`

```bash
wget -q - https://github.com/Nyx0uf/qlImageSize/releases/download/2.6.1/qlImageSize.qlgenerator.zip \
&& unzip -c qlImageSize.qlgenerator.zip > ${HOME}/Library/QuickLook/qlImageSize.qlgenerator
```

### Using casks

Searching for Casks

```bash
$ brew search <PGMNAME>
```

List installed cask

```bash
$ brew cask list
```

Upgrade apps

```bash
$ brew cask upgrade
```

Uninstall

```bash
$ brew cask uninstall <PGMNAME>
```

### References

- https://brew.sh/
- http://caskroom.io/
- [Yenlung - [Keynote] 程式碼高亮化](http://yenlung-blog.logdown.com/posts/773053-keynote-code-highlighting)
- [Mac - quick-look-plugins](https://github.com/sindresorhus/quick-look-plugins)
- [QuickLook Video](https://github.com/Marginal/QLVideo)
- [Grip -- GitHub Readme Instant Preview](https://github.com/joeyespo/grip)
